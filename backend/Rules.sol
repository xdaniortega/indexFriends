// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @title Rules Contract
 * @dev Manages allowed tokens and NFT collections for the protocol
 * @dev Defines which tokens can be used in strategies and which NFT collections are valid
 * @dev Only the contract owner can modify the allowed tokens list
 */
contract Rules is Ownable {
  event AllowedToken(address indexed token, string symbol);
  event RemovedToken(address indexed token, string symbol);
  event NFTCollectionUpdated(address indexed oldCollection, address indexed newCollection);
  event WithdrawalTimeoutUpdated(uint256 indexed oldTimeout, uint256 indexed newTimeout);

  error InvalidMaxAllowedTokens();
  error InvalidWithdrawalTimeout();
  error ArraysLengthMismatch();
  error TooManyInitialTokens();
  error InvalidNFTCollectionAddress();
  error InvalidTokenAddress();
  error InvalidTokenSymbol();
  error TokenAlreadyAllowed();
  error MaxTokensLimitReached();
  error TokenNotAllowed();

  /// @dev Array of all allowed token addresses
  address[] public allowedTokensList;
  
  /// @dev Address of the allowed NFT collection
  address public allowedNFTCollection;
  
  /// @dev Withdrawal timeout in seconds
  uint256 public withdrawalTimeout;
  
  /// @dev Maximum number of allowed tokens
  uint256 public immutable maxAllowedTokens;
  
  /// @dev Token symbol mapping for better identification
  mapping(address => string) public tokenSymbols;

  /// @dev Mapping of token addresses to their allowed status
  mapping(address => bool) public allowedTokens;

  /**
   * @dev Constructor initializes the contract with configurable parameters
   * @param _maxAllowedTokens Maximum number of tokens that can be allowed
   * @param _withdrawalTimeout Initial withdrawal timeout in seconds
   * @param _initialTokens Array of initial allowed token addresses
   * @param _initialTokenSymbols Array of corresponding token symbols
   * @param _nftCollection Initial allowed NFT collection address
   */
  constructor(
    uint256 _maxAllowedTokens,
    uint256 _withdrawalTimeout,
    address[] memory _initialTokens,
    string[] memory _initialTokenSymbols,
    address _nftCollection
  ) {
    if (_maxAllowedTokens == 0) revert InvalidMaxAllowedTokens();
    if (_withdrawalTimeout == 0) revert InvalidWithdrawalTimeout();
    if (_initialTokens.length != _initialTokenSymbols.length) revert ArraysLengthMismatch();
    if (_initialTokens.length > _maxAllowedTokens) revert TooManyInitialTokens();
    if (_nftCollection == address(0)) revert InvalidNFTCollectionAddress();
    
    maxAllowedTokens = _maxAllowedTokens;
    withdrawalTimeout = _withdrawalTimeout;
    allowedNFTCollection = _nftCollection;
    
    // Initialize with provided tokens
    for (uint256 i = 0; i < _initialTokens.length; i++) {
      if (_initialTokens[i] == address(0)) revert InvalidTokenAddress();
      if (bytes(_initialTokenSymbols[i]).length == 0) revert InvalidTokenSymbol();
      
      allowedTokens[_initialTokens[i]] = true;
      tokenSymbols[_initialTokens[i]] = _initialTokenSymbols[i];
      allowedTokensList.push(_initialTokens[i]);
    }
  }

  /**
   * @dev Adds a new token to the allowed tokens list
   * @param _token The address of the token to allow
   * @param _symbol The symbol of the token
   * @notice Only the contract owner can call this function
   * @notice Emits AllowedToken event
   */
  function setNewToken(address _token, string memory _symbol) public onlyOwner {
    if (_token == address(0)) revert InvalidTokenAddress();
    if (bytes(_symbol).length == 0) revert InvalidTokenSymbol();
    if (allowedTokens[_token]) revert TokenAlreadyAllowed();
    if (allowedTokensList.length >= maxAllowedTokens) revert MaxTokensLimitReached();
    
    allowedTokens[_token] = true;
    tokenSymbols[_token] = _symbol;
    allowedTokensList.push(_token);
    
    emit AllowedToken(_token, _symbol);
  }

  /**
   * @dev Removes a token from the allowed tokens list
   * @param _token The address of the token to remove
   * @notice Only the contract owner can call this function
   * @notice Emits RemovedToken event
   */
  function removeToken(address _token) public onlyOwner {
    if (_token == address(0)) revert InvalidTokenAddress();
    if (!allowedTokens[_token]) revert TokenNotAllowed();
    
    allowedTokens[_token] = false;
    delete tokenSymbols[_token];
    
    // Remove from array
    for (uint256 i = 0; i < allowedTokensList.length; i++) {
      if (allowedTokensList[i] == _token) {
        allowedTokensList[i] = allowedTokensList[allowedTokensList.length - 1];
        allowedTokensList.pop();
        break;
      }
    }
    
    emit RemovedToken(_token, "");
  }

  /**
   * @dev Checks if a token is allowed
   * @param _token The address of the token to check
   * @return True if the token is allowed, false otherwise
   */
  function isTokenAllowed(address _token) public view returns (bool) {
    return allowedTokens[_token];
  }

  /**
   * @dev Returns the address of the allowed NFT collection
   * @return The address of the allowed NFT collection
   */
  function getAllowedNFTCollection() public view returns (address) {
    return allowedNFTCollection;
  }

  /**
   * @dev Updates the allowed NFT collection
   * @param _newCollection The new NFT collection address
   * @notice Only the contract owner can call this function
   */
  function setAllowedNFTCollection(address _newCollection) external onlyOwner {
    if (_newCollection == address(0)) revert InvalidNFTCollectionAddress();
    if (_newCollection == allowedNFTCollection) revert InvalidNFTCollectionAddress();
    
    address oldCollection = allowedNFTCollection;
    allowedNFTCollection = _newCollection;
    
    emit NFTCollectionUpdated(oldCollection, _newCollection);
  }

  /**
   * @dev Sets withdrawal timeout
   * @param _newTimeout New withdrawal timeout in seconds
   * @notice Only the contract owner can call this function
   */
  function setWithdrawalTimeout(uint256 _newTimeout) external onlyOwner {
    if (_newTimeout == 0) revert InvalidWithdrawalTimeout();
    if (_newTimeout == withdrawalTimeout) revert InvalidWithdrawalTimeout();
    
    uint256 oldTimeout = withdrawalTimeout;
    withdrawalTimeout = _newTimeout;
    
    emit WithdrawalTimeoutUpdated(oldTimeout, _newTimeout);
  }

  /**
   * @dev Returns the list of all allowed token addresses
   * @return An array of all allowed token addresses
   */
  function getAllowedTokenList() public view returns (address[] memory) {
    return allowedTokensList;
  }

  /**
   * @dev Returns the count of allowed tokens
   * @return The number of allowed tokens
   */
  function getAllowedTokenCount() public view returns (uint256) {
    return allowedTokensList.length;
  }

  /**
   * @dev Returns token information including symbol and allowance status
   * @param _token The token address to query
   * @return _allowed Whether the token is allowed
   * @return _symbol The token symbol
   * @return _index The index in the allowed tokens list
   */
  function getTokenInfo(address _token) external view returns (
    bool _allowed,
    string memory _symbol,
    uint256 _index
  ) {
    _allowed = allowedTokens[_token];
    _symbol = tokenSymbols[_token];
    _index = type(uint256).max; // Default to max if not found
    
    if (_allowed) {
      for (uint256 i = 0; i < allowedTokensList.length; i++) {
        if (allowedTokensList[i] == _token) {
          _index = i;
          break;
        }
      }
    }
  }

  /**
   * @dev Batch operation to add multiple tokens
   * @param _tokens Array of token addresses
   * @param _symbols Array of corresponding token symbols
   * @notice Only the contract owner can call this function
   */
  function batchAddTokens(
    address[] memory _tokens,
    string[] memory _symbols
  ) external onlyOwner {
    if (_tokens.length != _symbols.length) revert ArraysLengthMismatch();
    if (_tokens.length == 0) revert InvalidTokenAddress();
    if (allowedTokensList.length + _tokens.length > maxAllowedTokens) revert MaxTokensLimitReached();
    
    for (uint256 i = 0; i < _tokens.length; i++) {
      setNewToken(_tokens[i], _symbols[i]);
    }
  }

  /**
   * @dev Emergency function to remove all tokens and reset the contract
   * @notice Only the contract owner can call this function
   * @notice Use with extreme caution as this will break all existing strategies
   */
  function emergencyReset() external onlyOwner {
    for (uint256 i = 0; i < allowedTokensList.length; i++) {
      address token = allowedTokensList[i];
      allowedTokens[token] = false;
      delete tokenSymbols[token];
    }
    
    delete allowedTokensList;
    allowedTokensList = new address[](0);
  }
}

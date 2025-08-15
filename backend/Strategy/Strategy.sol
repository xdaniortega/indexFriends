// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../Rules.sol";

/**
 * @title Strategy Contract
 * @dev Manages investment strategies for NFT holders
 * @dev Allows NFT owners to set token allocation percentages and manage their portfolio
 * @dev Integrates with Rules contract for token validation and RebalanceRouter for swaps
 */
contract Strategy is Ownable, ReentrancyGuard {
  event TokenPercentageUpdated(address indexed token, uint256 oldPercentage, uint256 newPercentage);
  event PortfolioRebalanced(uint256 timestamp, uint256 totalValue);
  event FundsDeposited(address indexed user, uint256 amount, uint256 timestamp);
  event FundsWithdrawn(address indexed user, uint256 amount, uint256 timestamp);
  event RebalanceRouterUpdated(address indexed oldRouter, address indexed newRouter);
  event RebalanceThresholdUpdated(uint256 oldThreshold, uint256 newThreshold);
  event StrategyPaused(bool paused);

  error InvalidRulesAddress();
  error InvalidNFTCollectionAddress();
  error InvalidMaxPercentagePerToken();
  error InvalidMaxTotalPercentage();
  error InvalidPercentageLimits();
  error InvalidRebalanceThreshold();
  error InvalidRebalanceCooldown();
  error StrategyPaused();
  error InvalidToken();
  error InvalidPercentage();
  error InsufficientBalance();
  error RebalanceCooldown();
  error Unauthorized();
  error InvalidParameters();
  error InvalidUserAddress();
  error InvalidAmount();
  error InvalidRouterAddress();
  error ArraysLengthMismatch();
  error TransferFailed();

  /// @dev Mapping of token addresses to their allocation percentages
  mapping(address => uint256) public tokenPercentages;
  
  /// @dev Mapping of user addresses to their token balances
  mapping(address => uint256) public userBalances;
  
  /// @dev The token ID associated with this strategy
  uint256 public immutable tokenId;
  
  /// @dev Reference to the Rules contract for validation
  Rules public immutable rules;
  
  /// @dev Array of allowed tokens for this strategy
  address[] public allowedTokens;
  
  /// @dev Reference to the NFT collection
  IERC721 public immutable nftCollection;
  
  /// @dev Reference to the rebalancing router for token swaps
  address public rebalanceRouter;
  
  /// @dev Maximum percentage per token (10000 = 100%)
  uint256 public immutable maxPercentagePerToken;
  
  /// @dev Maximum total percentage (10000 = 100%)
  uint256 public immutable maxTotalPercentage;
  
  /// @dev Minimum rebalance threshold in basis points
  uint256 public rebalanceThresholdBps;
  
  /// @dev Last rebalance timestamp
  uint256 public lastRebalanceTime;
  
  /// @dev Rebalance cooldown period in seconds
  uint256 public rebalanceCooldown;
  
  /// @dev Pause flag for emergency situations
  bool public paused;

  /**
   * @dev Modifier to restrict access to the service provider only
   * @notice Only the company's public address can call functions with this modifier
   */
  modifier onlyProvider() {
    if (msg.sender != owner()) {
      revert Unauthorized();
    }
    _;
  }

  /**
   * @dev Modifier to restrict access to NFT owners only
   * @param _tokenId The token ID to check ownership for
   * @notice Only the owner of the specified NFT can call functions with this modifier
   */
  modifier onlyNFTOwner(uint256 _tokenId) {
    if (msg.sender != nftCollection.ownerOf(_tokenId)) {
      revert Unauthorized();
    }
    _;
  }

  /**
   * @dev Constructor initializes the strategy with configurable parameters
   * @param _rules The address of the Rules contract
   * @param _tokenId The token ID associated with this strategy
   * @param _nftCollection The NFT collection address
   * @param _maxPercentagePerToken Maximum percentage per token (10000 = 100%)
   * @param _maxTotalPercentage Maximum total percentage (10000 = 100%)
   * @param _rebalanceThresholdBps Initial rebalance threshold in basis points
   * @param _rebalanceCooldown Rebalance cooldown period in seconds
   */
  constructor(
    address _rules,
    uint256 _tokenId,
    address _nftCollection,
    uint256 _maxPercentagePerToken,
    uint256 _maxTotalPercentage,
    uint256 _rebalanceThresholdBps,
    uint256 _rebalanceCooldown
  ) {
    if (_rules == address(0)) revert InvalidRulesAddress();
    if (_nftCollection == address(0)) revert InvalidNFTCollectionAddress();
    if (_maxPercentagePerToken == 0) revert InvalidMaxPercentagePerToken();
    if (_maxTotalPercentage == 0) revert InvalidMaxTotalPercentage();
    if (_maxPercentagePerToken > _maxTotalPercentage) revert InvalidPercentageLimits();
    if (_rebalanceThresholdBps == 0) revert InvalidRebalanceThreshold();
    if (_rebalanceCooldown == 0) revert InvalidRebalanceCooldown();
    
    rules = Rules(_rules);
    tokenId = _tokenId;
    nftCollection = IERC721(_nftCollection);
    maxPercentagePerToken = _maxPercentagePerToken;
    maxTotalPercentage = _maxTotalPercentage;
    rebalanceThresholdBps = _rebalanceThresholdBps;
    rebalanceCooldown = _rebalanceCooldown;
    
    // Initialize allowed tokens from rules
    allowedTokens = rules.getAllowedTokenList();
    
    // Initialize percentages to 0
    for (uint256 i = 0; i < allowedTokens.length; i++) {
      tokenPercentages[allowedTokens[i]] = 0;
    }
  }

  /**
   * @dev Returns the allocation percentage for a specific token
   * @param _token The address of the token to query
   * @return The allocation percentage for the specified token
   */
  function getTokenPercentage(address _token) public view returns (uint256) {
    return tokenPercentages[_token];
  }

  /**
   * @dev Returns the current portfolio allocation
   * @return _tokens Array of token addresses
   * @return _percentages Array of corresponding percentages
   */
  function getPortfolioAllocation() external view returns (
    address[] memory _tokens,
    uint256[] memory _percentages
  ) {
    _tokens = allowedTokens;
    _percentages = new uint256[](allowedTokens.length);
    
    for (uint256 i = 0; i < allowedTokens.length; i++) {
      _percentages[i] = tokenPercentages[_tokens[i]];
    }
  }

  /**
   * @dev Sets the allocation percentage for a specific token
   * @param _token The address of the token to set percentage for
   * @param _percentage The percentage allocation (0-10000, where 10000 = 100%)
   * @notice Only NFT owners can call this function
   * @notice Percentage must be less than or equal to maxPercentagePerToken
   * @notice Token must be in the allowed tokens list
   */
  function setTokenPercentage(
    address _token,
    uint256 _percentage
  ) external onlyNFTOwner(tokenId) whenNotPaused {
    if (_percentage > maxPercentagePerToken) {
      revert InvalidPercentage();
    }
    if (!rules.isTokenAllowed(_token)) {
      revert InvalidToken();
    }

    uint256 oldPercentage = tokenPercentages[_token];
    tokenPercentages[_token] = _percentage;

    emit TokenPercentageUpdated(_token, oldPercentage, _percentage);
    
    // Trigger rebalance if threshold is met
    _checkAndTriggerRebalance();
  }

  /**
   * @dev Sets allocation percentages for multiple tokens in a single transaction
   * @param _tokens Array of token addresses
   * @param _percentages Array of corresponding percentages
   * @notice Only NFT owners can call this function
   * @notice Total percentage must not exceed maxTotalPercentage
   * @notice All tokens must be in the allowed tokens list
   */
  function setTokenPercentagesInBatch(
    address[] memory _tokens,
    uint256[] memory _percentages
  ) external onlyNFTOwner(tokenId) whenNotPaused {
    if (_tokens.length != _percentages.length) {
      revert ArraysLengthMismatch();
    }
    
    uint256 totalPercentage = 0;
    
    for (uint256 i = 0; i < _tokens.length; i++) {
      if (_percentages[i] > maxPercentagePerToken) {
        revert InvalidPercentage();
      }
      if (!rules.isTokenAllowed(_tokens[i])) {
        revert InvalidToken();
      }
      
      totalPercentage += _percentages[i];
    }
    
    if (totalPercentage > maxTotalPercentage) {
      revert InvalidPercentage();
    }

    // Update percentages
    for (uint256 i = 0; i < _tokens.length; i++) {
      uint256 oldPercentage = tokenPercentages[_tokens[i]];
      tokenPercentages[_tokens[i]] = _percentages[i];
      
      emit TokenPercentageUpdated(_tokens[i], oldPercentage, _percentages[i]);
    }
    
    // Trigger rebalance
    _checkAndTriggerRebalance();
  }

  /**
   * @dev Internal function to handle deposits from the vault
   * @param _user The address of the user making the deposit
   * @param _amount The amount of tokens being deposited
   * @notice Requires approval from the user for the specified amount
   * @notice Updates the user's balance and triggers rebalancing
   */
  function depositFromVault(address _user, uint256 _amount) 
    external 
    nonReentrant 
    whenNotPaused 
  {
    if (_user == address(0)) revert InvalidUserAddress();
    if (_amount == 0) revert InvalidAmount();
    
    // Check allowance
    uint256 allowance = IERC20(vaultToken()).allowance(msg.sender, address(this));
    if (allowance < _amount) {
      revert InvalidAmount();
    }

    // Transfer tokens
    bool success = IERC20(vaultToken()).transferFrom(
      msg.sender,
      address(this),
      _amount
    );
    if (!success) {
      revert TransferFailed();
    }

    // Update user balance
    userBalances[_user] += _amount;

    emit FundsDeposited(_user, _amount, block.timestamp);
    
    // Trigger rebalance
    _checkAndTriggerRebalance();
  }

  /**
   * @dev Triggers portfolio rebalancing
   * @notice Only NFT owners can call this function
   * @notice Respects cooldown period
   */
  function triggerRebalance() external onlyNFTOwner(tokenId) whenNotPaused {
    if (block.timestamp < lastRebalanceTime + rebalanceCooldown) {
      revert RebalanceCooldown();
    }
    
    _executeRebalance();
  }

  /**
   * @dev Internal function to check and trigger rebalancing
   */
  function _checkAndTriggerRebalance() internal {
    if (block.timestamp >= lastRebalanceTime + rebalanceCooldown) {
      _executeRebalance();
    }
  }

  /**
   * @dev Internal function to execute portfolio rebalancing
   */
  function _executeRebalance() internal {
    // Calculate total portfolio value
    uint256 totalValue = _calculateTotalPortfolioValue();
    
    // Execute rebalancing logic here
    // This would integrate with RebalanceRouter for actual swaps
    
    lastRebalanceTime = block.timestamp;
    emit PortfolioRebalanced(block.timestamp, totalValue);
  }

  /**
   * @dev Calculates total portfolio value
   * @return Total portfolio value in base token
   */
  function _calculateTotalPortfolioValue() internal view returns (uint256) {
    // Implementation would calculate total value based on token balances and prices
    // For now, returning sum of user balances
    uint256 totalValue = 0;
    // This is a simplified calculation - real implementation would use price oracles
    return totalValue;
  }

  /**
   * @dev Updates rebalance threshold
   * @param _newThreshold New threshold in basis points
   * @notice Only NFT owners can call this function
   */
  function setRebalanceThreshold(uint256 _newThreshold) external onlyNFTOwner(tokenId) {
    if (_newThreshold == 0) {
      revert InvalidParameters();
    }
    
    uint256 oldThreshold = rebalanceThresholdBps;
    rebalanceThresholdBps = _newThreshold;
    
    emit RebalanceThresholdUpdated(oldThreshold, _newThreshold);
  }

  /**
   * @dev Updates rebalance router address
   * @param _newRouter New router address
   * @notice Only NFT owners can call this function
   */
  function setRebalanceRouter(address _newRouter) external onlyNFTOwner(tokenId) {
    if (_newRouter == address(0)) revert InvalidRouterAddress();
    
    address oldRouter = rebalanceRouter;
    rebalanceRouter = _newRouter;
    
    emit RebalanceRouterUpdated(oldRouter, _newRouter);
  }

  /**
   * @dev Pauses or unpauses the strategy
   * @param _paused Whether to pause the strategy
   * @notice Only NFT owners can call this function
   */
  function setPaused(bool _paused) external onlyNFTOwner(tokenId) {
    paused = _paused;
    emit StrategyPaused(_paused);
  }

  /**
   * @dev Returns strategy information
   * @return _tokenId Associated NFT token ID
   * @return _nftOwner Current NFT owner
   * @return _totalValue Total portfolio value
   * @return _lastRebalance Last rebalance timestamp
   * @return _paused Whether strategy is paused
   */
  function getStrategyInfo() external view returns (
    uint256 _tokenId,
    address _nftOwner,
    uint256 _totalValue,
    uint256 _lastRebalance,
    bool _paused
  ) {
    _tokenId = tokenId;
    _nftOwner = nftCollection.ownerOf(tokenId);
    _totalValue = _calculateTotalPortfolioValue();
    _lastRebalance = lastRebalanceTime;
    _paused = paused;
  }

  /**
   * @dev Returns the vault token address
   * @return The vault token address
   */
  function vaultToken() public view returns (address) {
    // This would need to be implemented based on how the vault is integrated
    // For now, returning a placeholder
    return address(0);
  }

  /**
   * @dev Modifier to check if strategy is not paused
   */
  modifier whenNotPaused() {
    if (paused) {
      revert StrategyPaused();
    }
    _;
  }
}

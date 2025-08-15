//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title IndexFriends
 * @dev A collection of unique NFTs called "IndexFriends" with minting functionality
 * @dev This contract extends ERC721Enumerable and Ownable for additional features
 * @dev Each NFT represents a unique digital asset in the IndexFriends collection
 */
contract IndexFriends is ERC721Enumerable, Ownable {
  using SafeMath for uint256;
  using Counters for Counters.Counter;

  event NFTMinted(address indexed to, uint256 indexed tokenId);
  event BaseURIUpdated(string indexed oldURI, string indexed newURI);
  event PriceUpdated(uint256 indexed oldPrice, uint256 indexed newPrice);
  event MaxPerMintUpdated(uint256 indexed oldMax, uint256 indexed newMax);

  error InvalidMaxSupply();
  error InvalidMaxPerMint();
  error InvalidMaxPerMintExceedsSupply();
  error InvalidOwnerAddress();
  error InvalidTokenAddress();
  error InvalidAmount();
  error InsufficientPayment();
  error NotEnoughNFTsLeft();
  error InvalidMintCount();
  error NoEtherToWithdraw();
  error TransferFailed();

  /// @dev Counter for tracking token IDs
  Counters.Counter private _tokenIds;

  /// @dev Maximum supply of NFTs in the collection
  uint public immutable maxSupply;
  
  /// @dev Price per NFT
  uint public immutable price;
  
  /// @dev Maximum number of NFTs that can be minted in a single transaction
  uint public immutable maxPerMint;

  /// @dev Base URI for token metadata
  string public baseTokenURI;

  /// @dev Collection name and symbol
  string public immutable collectionName;
  string public immutable collectionSymbol;

  /**
   * @dev Constructor for the IndexFriends NFT collection
   * @param _baseURI The base URI for token metadata
   * @param _maxSupply Maximum supply of NFTs
   * @param _price Price per NFT in wei
   * @param _maxPerMint Maximum NFTs per transaction
   * @param _name Collection name
   * @param _symbol Collection symbol
   */
  constructor(
    string memory _baseURI,
    uint _maxSupply,
    uint _price,
    uint _maxPerMint,
    string memory _name,
    string memory _symbol
  ) ERC721(_name, _symbol) {
    if (_maxSupply == 0) revert InvalidMaxSupply();
    if (_maxPerMint == 0) revert InvalidMaxPerMint();
    if (_maxPerMint > _maxSupply) revert InvalidMaxPerMintExceedsSupply();
    
    baseTokenURI = _baseURI;
    maxSupply = _maxSupply;
    price = _price;
    maxPerMint = _maxPerMint;
    collectionName = _name;
    collectionSymbol = _symbol;
  }

  /**
   * @dev Returns the base URI for token metadata
   * @return The base URI string
   */
  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  /**
   * @dev Sets the base URI for token metadata
   * @param _newBaseURI The new base URI
   * @notice Only the contract owner can call this function
   */
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    string memory oldURI = baseTokenURI;
    baseTokenURI = _newBaseURI;
    emit BaseURIUpdated(oldURI, _newBaseURI);
  }

  /**
   * @dev Mints a specified number of NFTs
   * @param _count The number of NFTs to mint
   * @notice Users can mint up to maxPerMint NFTs per transaction
   * @notice The total supply cannot exceed maxSupply
   */
  function mintNFTs(uint _count) public payable {
    uint totalMinted = _tokenIds.current();

    if (totalMinted.add(_count) > maxSupply) revert NotEnoughNFTsLeft();
    if (_count == 0 || _count > maxPerMint) revert InvalidMintCount();
    
    if (price > 0) {
      if (msg.value < price.mul(_count)) revert InsufficientPayment();
    }

    for (uint i = 0; i < _count; i++) {
      _mintSingleNFT();
    }
  }

  /**
   * @dev Internal function to mint a single NFT
   * @notice Increments the token ID counter and mints to the caller
   */
  function _mintSingleNFT() private {
    uint newTokenID = _tokenIds.current();
    _safeMint(msg.sender, newTokenID);
    _tokenIds.increment();
    emit NFTMinted(msg.sender, newTokenID);
  }

  /**
   * @dev Returns an array of token IDs owned by a specific address
   * @param _owner The address to query for owned tokens
   * @return An array of token IDs owned by the specified address
   */
  function tokensOfOwner(address _owner) external view returns (uint[] memory) {
    if (_owner == address(0)) revert InvalidOwnerAddress();
    
    uint tokenCount = balanceOf(_owner);
    uint[] memory tokensId = new uint256[](tokenCount);

    for (uint i = 0; i < tokenCount; i++) {
      tokensId[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokensId;
  }

  /**
   * @dev Returns the total number of tokens minted
   * @return Total tokens minted so far
   */
  function totalMinted() external view returns (uint) {
    return _tokenIds.current();
  }

  /**
   * @dev Returns the remaining tokens available for minting
   * @return Remaining tokens that can be minted
   */
  function remainingSupply() external view returns (uint) {
    return maxSupply - _tokenIds.current();
  }

  /**
   * @dev Allows the contract owner to withdraw all ETH from the contract
   * @notice Only the contract owner can call this function
   * @notice Requires the contract to have a positive ETH balance
   */
  function withdraw() public onlyOwner {
    uint balance = address(this).balance;
    if (balance == 0) revert NoEtherToWithdraw();

    (bool success, ) = payable(owner()).call{value: balance}("");
    if (!success) revert TransferFailed();
  }

  /**
   * @dev Emergency function to withdraw specific token
   * @param _token The token address to withdraw
   * @param _amount The amount to withdraw
   * @notice Only the contract owner can call this function
   */
  function emergencyWithdraw(address _token, uint _amount) external onlyOwner {
    if (_token == address(0)) revert InvalidTokenAddress();
    if (_amount == 0) revert InvalidAmount();
    
    IERC20(_token).transfer(owner(), _amount);
  }

  /**
   * @dev Pause minting functionality
   * @notice Only the contract owner can call this function
   */
  function pauseMinting() external onlyOwner {
    // This would require implementing Pausable from OpenZeppelin
    // For now, this is a placeholder for future implementation
  }

  /**
   * @dev Resume minting functionality
   * @notice Only the contract owner can call this function
   */
  function resumeMinting() external onlyOwner {
    // This would require implementing Pausable from OpenZeppelin
    // For now, this is a placeholder for future implementation
  }
}

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./Strategy.sol";
import "../Rules.sol";

/**
 * @title StrategyFactory Contract
 * @dev Factory contract for deploying new Strategy contracts
 * @dev Allows NFT owners to create personalized investment strategies
 * @dev Maintains a list of all deployed strategies for tracking purposes
 */
contract StrategyFactory is Ownable, ReentrancyGuard {
  event StrategyDeployed(
    address indexed strategyAddress,
    uint256 indexed tokenId,
    address indexed owner,
    uint256 timestamp
  );
  event DeploymentFeeUpdated(uint256 oldFee, uint256 newFee);
  event FeeRecipientUpdated(address indexed oldRecipient, address indexed newRecipient);
  event FactoryPaused(bool paused);
  event StrategyRemoved(address indexed strategy, uint256 indexed tokenId);

  error InvalidRulesAddress();
  error InvalidNFTCollectionAddress();
  error InvalidMaxPercentagePerToken();
  error InvalidMaxTotalPercentage();
  error InvalidPercentageLimits();
  error InvalidRebalanceThreshold();
  error InvalidRebalanceCooldown();
  error InvalidFeeRecipient();
  error InvalidMaxStrategiesPerNFT();
  error FactoryPaused();
  error InvalidTokenId();
  error MaxStrategiesReached();
  error InsufficientFee();
  error InvalidParameters();
  error Unauthorized();
  error InvalidStrategyAddress();
  error FeeTransferFailed();
  error RefundTransferFailed();
  error NoFeesToWithdraw();
  error FeeWithdrawalFailed();

  /// @dev Array of all Strategy contracts deployed by this factory
  address[] public deployedStrategies;
  
  /// @dev Reference to the Rules contract for validation
  Rules public immutable rules;
  
  /// @dev Reference to the NFT collection
  IERC721 public immutable nftCollection;
  
  /// @dev Maximum percentage per token (10000 = 100%)
  uint256 public immutable maxPercentagePerToken;
  
  /// @dev Maximum total percentage (10000 = 100%)
  uint256 public immutable maxTotalPercentage;
  
  /// @dev Default rebalance threshold in basis points
  uint256 public immutable defaultRebalanceThresholdBps;
  
  /// @dev Default rebalance cooldown period in seconds
  uint256 public immutable defaultRebalanceCooldown;
  
  /// @dev Strategy deployment fee in wei
  uint256 public strategyDeploymentFee;
  
  /// @dev Fee recipient address
  address public feeRecipient;
  
  /// @dev Pause flag for emergency situations
  bool public paused;
  
  /// @dev Maximum number of strategies per NFT
  uint256 public immutable maxStrategiesPerNFT;
  
  /// @dev Mapping of NFT token ID to deployed strategies
  mapping(uint256 => address[]) public nftStrategies;
  
  /// @dev Mapping of NFT token ID to strategy count
  mapping(uint256 => uint256) public nftStrategyCount;

  /**
   * @dev Constructor initializes the factory with configurable parameters
   * @param _rules The address of the Rules contract
   * @param _nftCollection The NFT collection address
   * @param _maxPercentagePerToken Maximum percentage per token (10000 = 100%)
   * @param _maxTotalPercentage Maximum total percentage (10000 = 100%)
   * @param _defaultRebalanceThresholdBps Default rebalance threshold in basis points
   * @param _defaultRebalanceCooldown Default rebalance cooldown period in seconds
   * @param _strategyDeploymentFee Initial strategy deployment fee in wei
   * @param _feeRecipient Initial fee recipient address
   * @param _maxStrategiesPerNFT Maximum number of strategies per NFT
   */
  constructor(
    address _rules,
    address _nftCollection,
    uint256 _maxPercentagePerToken,
    uint256 _maxTotalPercentage,
    uint256 _defaultRebalanceThresholdBps,
    uint256 _defaultRebalanceCooldown,
    uint256 _strategyDeploymentFee,
    address _feeRecipient,
    uint256 _maxStrategiesPerNFT
  ) {
    if (_rules == address(0)) revert InvalidRulesAddress();
    if (_nftCollection == address(0)) revert InvalidNFTCollectionAddress();
    if (_maxPercentagePerToken == 0) revert InvalidMaxPercentagePerToken();
    if (_maxTotalPercentage == 0) revert InvalidMaxTotalPercentage();
    if (_maxPercentagePerToken > _maxTotalPercentage) revert InvalidPercentageLimits();
    if (_defaultRebalanceThresholdBps == 0) revert InvalidRebalanceThreshold();
    if (_defaultRebalanceCooldown == 0) revert InvalidRebalanceCooldown();
    if (_feeRecipient == address(0)) revert InvalidFeeRecipient();
    if (_maxStrategiesPerNFT == 0) revert InvalidMaxStrategiesPerNFT();
    
    rules = Rules(_rules);
    nftCollection = IERC721(_nftCollection);
    maxPercentagePerToken = _maxPercentagePerToken;
    maxTotalPercentage = _maxTotalPercentage;
    defaultRebalanceThresholdBps = _defaultRebalanceThresholdBps;
    defaultRebalanceCooldown = _defaultRebalanceCooldown;
    strategyDeploymentFee = _strategyDeploymentFee;
    feeRecipient = _feeRecipient;
    maxStrategiesPerNFT = _maxStrategiesPerNFT;
  }

  /**
   * @dev Deploys a new Strategy contract for a specific NFT
   * @param _tokenId The token ID to associate with the new strategy
   * @return The address of the newly deployed Strategy contract
   * @notice Only NFT owners can deploy strategies for their tokens
   * @notice Emits StrategyDeployed event
   * @notice Requires payment of deployment fee if configured
   */
  function deployStrategy(uint256 _tokenId) 
    external 
    payable 
    nonReentrant 
    whenNotPaused 
    returns (address) 
  {
    if (_tokenId == 0) {
      revert InvalidTokenId();
    }
    
    if (msg.sender != nftCollection.ownerOf(_tokenId)) {
      revert Unauthorized();
    }
    
    if (nftStrategyCount[_tokenId] >= maxStrategiesPerNFT) {
      revert MaxStrategiesReached();
    }
    
    if (msg.value < strategyDeploymentFee) {
      revert InsufficientFee();
    }

    // Deploy new strategy
    Strategy newStrategy = new Strategy(
      address(rules),
      _tokenId,
      address(nftCollection),
      maxPercentagePerToken,
      maxTotalPercentage,
      defaultRebalanceThresholdBps,
      defaultRebalanceCooldown
    );

    // Add to deployed strategies list
    deployedStrategies.push(address(newStrategy));
    
    // Add to NFT strategies mapping
    nftStrategies[_tokenId].push(address(newStrategy));
    nftStrategyCount[_tokenId]++;

    // Transfer ownership to NFT owner
    newStrategy.transferOwnership(msg.sender);

    // Transfer fee to recipient if any
    if (strategyDeploymentFee > 0 && feeRecipient != address(0)) {
      (bool success, ) = payable(feeRecipient).call{value: strategyDeploymentFee}("");
      if (!success) revert FeeTransferFailed();
    }

    // Refund excess payment
    if (msg.value > strategyDeploymentFee) {
      uint256 refund = msg.value - strategyDeploymentFee;
      (bool success, ) = payable(msg.sender).call{value: refund}("");
      if (!success) revert RefundTransferFailed();
    }

    emit StrategyDeployed(address(newStrategy), _tokenId, msg.sender, block.timestamp);

    return address(newStrategy);
  }

  /**
   * @dev Returns the list of all deployed strategy addresses
   * @return An array of all deployed strategy contract addresses
   */
  function listDeployedStrategies() external view returns (address[] memory) {
    return deployedStrategies;
  }

  /**
   * @dev Returns strategies for a specific NFT
   * @param _tokenId The NFT token ID
   * @return Array of strategy addresses for the NFT
   */
  function getStrategiesForNFT(uint256 _tokenId) external view returns (address[] memory) {
    return nftStrategies[_tokenId];
  }

  /**
   * @dev Returns the count of strategies for a specific NFT
   * @param _tokenId The NFT token ID
   * @return Number of strategies for the NFT
   */
  function getStrategyCountForNFT(uint256 _tokenId) external view returns (uint256) {
    return nftStrategyCount[_tokenId];
  }

  /**
   * @dev Returns total number of deployed strategies
   * @return Total count of deployed strategies
   */
  function getTotalStrategyCount() external view returns (uint256) {
    return deployedStrategies.length;
  }

  /**
   * @dev Updates the strategy deployment fee
   * @param _newFee New deployment fee in wei
   * @notice Only the contract owner can call this function
   */
  function setDeploymentFee(uint256 _newFee) external onlyOwner {
    uint256 oldFee = strategyDeploymentFee;
    strategyDeploymentFee = _newFee;
    
    emit DeploymentFeeUpdated(oldFee, _newFee);
  }

  /**
   * @dev Updates the fee recipient address
   * @param _newRecipient New fee recipient address
   * @notice Only the contract owner can call this function
   */
  function setFeeRecipient(address _newRecipient) external onlyOwner {
    if (_newRecipient == address(0)) revert InvalidFeeRecipient();
    
    address oldRecipient = feeRecipient;
    feeRecipient = _newRecipient;
    
    emit FeeRecipientUpdated(oldRecipient, _newRecipient);
  }

  /**
   * @dev Pauses or unpauses the factory
   * @param _paused Whether to pause the factory
   * @notice Only the contract owner can call this function
   */
  function setPaused(bool _paused) external onlyOwner {
    paused = _paused;
    emit FactoryPaused(_paused);
  }

  /**
   * @dev Emergency function to pause all operations
   * @notice Only the contract owner can call this function
   */
  function emergencyPause() external onlyOwner {
    paused = true;
    emit FactoryPaused(true);
  }

  /**
   * @dev Removes a strategy from tracking (does not delete the contract)
   * @param _strategy The strategy address to remove
   * @param _tokenId The NFT token ID associated with the strategy
   * @notice Only the contract owner can call this function
   * @notice This is for emergency situations only
   */
  function removeStrategyFromTracking(address _strategy, uint256 _tokenId) external onlyOwner {
    if (_strategy == address(0)) revert InvalidStrategyAddress();
    
    // Remove from deployed strategies array
    for (uint256 i = 0; i < deployedStrategies.length; i++) {
      if (deployedStrategies[i] == _strategy) {
        deployedStrategies[i] = deployedStrategies[deployedStrategies.length - 1];
        deployedStrategies.pop();
        break;
      }
    }
    
    // Remove from NFT strategies mapping
    address[] storage strategies = nftStrategies[_tokenId];
    for (uint256 i = 0; i < strategies.length; i++) {
      if (strategies[i] == _strategy) {
        strategies[i] = strategies[strategies.length - 1];
        strategies.pop();
        break;
      }
    }
    
    // Decrease NFT strategy count
    if (nftStrategyCount[_tokenId] > 0) {
      nftStrategyCount[_tokenId]--;
    }
    
    emit StrategyRemoved(_strategy, _tokenId);
  }

  /**
   * @dev Returns factory configuration
   * @return _rules Rules contract address
   * @return _nftCollection NFT collection address
   * @return _maxPercentagePerToken Maximum percentage per token
   * @return _maxTotalPercentage Maximum total percentage
   * @return _deploymentFee Current deployment fee
   * @return _feeRecipient Current fee recipient
   * @return _paused Whether factory is paused
   */
  function getFactoryConfig() external view returns (
    address _rules,
    address _nftCollection,
    uint256 _maxPercentagePerToken,
    uint256 _maxTotalPercentage,
    uint256 _deploymentFee,
    address _feeRecipient,
    bool _paused
  ) {
    _rules = address(rules);
    _nftCollection = address(nftCollection);
    _maxPercentagePerToken = maxPercentagePerToken;
    _maxTotalPercentage = maxTotalPercentage;
    _deploymentFee = strategyDeploymentFee;
    _feeRecipient = feeRecipient;
    _paused = paused;
  }

  /**
   * @dev Withdraws accumulated fees
   * @notice Only the contract owner can call this function
   */
  function withdrawFees() external onlyOwner {
    uint256 balance = address(this).balance;
    if (balance == 0) revert NoFeesToWithdraw();
    
    (bool success, ) = payable(owner()).call{value: balance}("");
    if (!success) revert FeeWithdrawalFailed();
  }

  /**
   * @dev Modifier to check if factory is not paused
   */
  modifier whenNotPaused() {
    if (paused) {
      revert FactoryPaused();
    }
    _;
  }

  /**
   * @dev Receive function to accept ETH
   */
  receive() external payable {}
}

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title Vault Contract
 * @dev Manages token deposits and withdrawals for investment strategies
 * @dev Acts as an intermediary between users and strategy contracts
 * @dev Handles token approvals and transfers for strategy interactions
 */
contract Vault is Ownable, ReentrancyGuard {
  event FundsDeposited(address indexed user, uint256 amount, uint256 timestamp);
  event FundsWithdrawn(address indexed user, uint256 amount, uint256 fee, uint256 timestamp);
  event StrategyApproved(address indexed strategy, bool approved, uint256 timestamp);
  event VaultPaused(bool paused, uint256 timestamp);
  event ParametersUpdated(
    uint256 maxDeposit,
    uint256 minDeposit,
    uint256 maxWithdrawal,
    uint256 withdrawalFee,
    address feeRecipient
  );

  error InvalidTokenAddress();
  error InvalidDepositLimits();
  error InvalidMinDeposit();
  error InvalidMaxWithdrawal();
  error WithdrawalFeeTooHigh();
  error InvalidFeeRecipient();
  error InvalidAmount();
  error InvalidStrategy();
  error InsufficientBalance();
  error TransferFailed();
  error InvalidParameters();
  error SameDepositLimits();
  error SameMaxWithdrawal();
  error SameWithdrawalFee();
  error SameFeeRecipient();
  error NoFeesToWithdraw();
  error FeeWithdrawalFailed();

  /// @dev The token address that this vault manages
  address public immutable vaultToken;
  
  /// @dev Mapping of user addresses to their staking balances
  mapping(address => uint256) public stakingBalance;
  
  /// @dev Mapping of user addresses to their total deposits
  mapping(address => uint256) public totalDeposits;
  
  /// @dev Mapping of user addresses to their total withdrawals
  mapping(address => uint256) public totalWithdrawals;
  
  /// @dev Mapping of strategy addresses to their approval status
  mapping(address => bool) public approvedStrategies;
  
  /// @dev Maximum deposit amount per transaction
  uint256 public maxDepositAmount;
  
  /// @dev Minimum deposit amount per transaction
  uint256 public minDepositAmount;
  
  /// @dev Maximum withdrawal amount per transaction
  uint256 public maxWithdrawalAmount;
  
  /// @dev Withdrawal fee in basis points (100 = 1%)
  uint256 public withdrawalFeeBps;
  
  /// @dev Fee recipient address
  address public feeRecipient;
  
  /// @dev Pause flag for emergency situations
  bool public paused;

  /**
   * @dev Constructor initializes the vault with configurable parameters
   * @param _vaultToken The token address that this vault manages
   * @param _maxDepositAmount Maximum deposit amount per transaction
   * @param _minDepositAmount Minimum deposit amount per transaction
   * @param _maxWithdrawalAmount Maximum withdrawal amount per transaction
   * @param _withdrawalFeeBps Withdrawal fee in basis points
   * @param _feeRecipient Address to receive withdrawal fees
   */
  constructor(
    address _vaultToken,
    uint256 _maxDepositAmount,
    uint256 _minDepositAmount,
    uint256 _maxWithdrawalAmount,
    uint256 _withdrawalFeeBps,
    address _feeRecipient
  ) {
    if (_vaultToken == address(0)) revert InvalidTokenAddress();
    if (_maxDepositAmount <= _minDepositAmount) revert InvalidDepositLimits();
    if (_minDepositAmount == 0) revert InvalidMinDeposit();
    if (_maxWithdrawalAmount == 0) revert InvalidMaxWithdrawal();
    if (_withdrawalFeeBps > 1000) revert WithdrawalFeeTooHigh();
    if (_feeRecipient == address(0)) revert InvalidFeeRecipient();
    
    vaultToken = _vaultToken;
    maxDepositAmount = _maxDepositAmount;
    minDepositAmount = _minDepositAmount;
    maxWithdrawalAmount = _maxWithdrawalAmount;
    withdrawalFeeBps = _withdrawalFeeBps;
    feeRecipient = _feeRecipient;
  }

  /**
   * @dev Deposits funds into the vault and approves them for strategy use
   * @param _amount The amount of tokens to deposit
   * @param _strategy The address of the strategy contract to approve
   * @notice Requires the user to have approved this contract to spend the tokens
   * @notice Transfers tokens from the user to the vault and approves the strategy
   */
  function depositFunds(uint256 _amount, address _strategy) 
    external 
    nonReentrant 
    whenNotPaused 
  {
    if (_amount < minDepositAmount || _amount > maxDepositAmount) {
      revert InvalidAmount();
    }
    
    if (_strategy != address(0) && !approvedStrategies[_strategy]) {
      revert InvalidStrategy();
    }

    uint256 allowance = IERC20(vaultToken).allowance(msg.sender, address(this));
    if (allowance < _amount) {
      revert InvalidAmount();
    }

    bool success = IERC20(vaultToken).transferFrom(
      msg.sender,
      address(this),
      _amount
    );
    if (!success) {
      revert TransferFailed();
    }

    // Update user balances
    stakingBalance[msg.sender] += _amount;
    totalDeposits[msg.sender] += _amount;

    // Approve strategy if provided
    if (_strategy != address(0)) {
      IERC20(vaultToken).approve(_strategy, _amount);
    }

    emit FundsDeposited(msg.sender, _amount, block.timestamp);
  }

  /**
   * @dev Withdraws funds from the vault to the user
   * @param _amount The amount of tokens to withdraw
   * @notice Requires the user to have sufficient balance
   * @notice Applies withdrawal fee if configured
   */
  function withdrawFunds(uint256 _amount) 
    external 
    nonReentrant 
    whenNotPaused 
  {
    if (_amount == 0 || _amount > maxWithdrawalAmount) {
      revert InvalidAmount();
    }
    
    if (_amount > stakingBalance[msg.sender]) {
      revert InsufficientBalance();
    }

    // Calculate fee
    uint256 fee = (_amount * withdrawalFeeBps) / 10000;
    uint256 netAmount = _amount - fee;

    // Update balances
    stakingBalance[msg.sender] -= _amount;
    totalWithdrawals[msg.sender] += _amount;

    // Transfer tokens to user
    bool success = IERC20(vaultToken).transfer(msg.sender, netAmount);
    if (!success) {
      revert TransferFailed();
    }

    // Transfer fee if any
    if (fee > 0) {
      success = IERC20(vaultToken).transfer(feeRecipient, fee);
      if (!success) {
        revert TransferFailed();
      }
    }

    emit FundsWithdrawn(msg.sender, _amount, fee, block.timestamp);
  }

  /**
   * @dev Approves or disapproves a strategy contract
   * @param _strategy The strategy address to approve/disapprove
   * @param _approved Whether to approve the strategy
   * @notice Only the contract owner can call this function
   */
  function setStrategyApproval(address _strategy, bool _approved) external onlyOwner {
    if (_strategy == address(0)) revert InvalidStrategy();
    
    approvedStrategies[_strategy] = _approved;
    emit StrategyApproved(_strategy, _approved, block.timestamp);
  }

  /**
   * @dev Updates vault parameters
   * @param _maxDeposit New maximum deposit amount
   * @param _minDeposit New minimum deposit amount
   * @param _maxWithdrawal New maximum withdrawal amount
   * @param _withdrawalFee New withdrawal fee in basis points
   * @param _newFeeRecipient New fee recipient address
   * @notice Only the contract owner can call this function
   */
  function updateParameters(
    uint256 _maxDeposit,
    uint256 _minDeposit,
    uint256 _maxWithdrawal,
    uint256 _withdrawalFee,
    address _newFeeRecipient
  ) external onlyOwner {
    if (_maxDeposit <= _minDeposit || _minDeposit == 0 || _maxWithdrawal == 0) {
      revert InvalidParameters();
    }
    if (_withdrawalFee > 1000) {
      revert InvalidParameters();
    }
    if (_newFeeRecipient == address(0)) {
      revert InvalidParameters();
    }

    if (_maxDeposit == maxDepositAmount && _minDeposit == minDepositAmount) {
      revert SameDepositLimits();
    }
    if (_maxWithdrawal == maxWithdrawalAmount) {
      revert SameMaxWithdrawal();
    }
    if (_withdrawalFee == withdrawalFeeBps) {
      revert SameWithdrawalFee();
    }
    if (_newFeeRecipient == feeRecipient) {
      revert SameFeeRecipient();
    }

    maxDepositAmount = _maxDeposit;
    minDepositAmount = _minDeposit;
    maxWithdrawalAmount = _maxWithdrawal;
    withdrawalFeeBps = _withdrawalFee;
    feeRecipient = _newFeeRecipient;

    emit ParametersUpdated(
      _maxDeposit,
      _minDeposit,
      _maxWithdrawal,
      _withdrawalFee,
      _newFeeRecipient
    );
  }

  /**
   * @dev Pauses or unpauses the vault
   * @param _paused Whether to pause the vault
   * @notice Only the contract owner can call this function
   */
  function setPaused(bool _paused) external onlyOwner {
    paused = _paused;
    emit VaultPaused(_paused, block.timestamp);
  }

  /**
   * @dev Returns user's vault information
   * @param _user The user address to query
   * @return _balance Current staking balance
   * @return _totalDeposits Total deposits made
   * @return _totalWithdrawals Total withdrawals made
   * @return _availableBalance Available balance for withdrawal
   */
  function getUserInfo(address _user) external view returns (
    uint256 _balance,
    uint256 _totalDeposits,
    uint256 _totalWithdrawals,
    uint256 _availableBalance
  ) {
    _balance = stakingBalance[_user];
    _totalDeposits = totalDeposits[_user];
    _totalWithdrawals = totalWithdrawals[_user];
    _availableBalance = _balance;
  }

  /**
   * @dev Returns vault statistics
   * @return _totalStaked Total tokens staked in the vault
   * @return _totalDeposits Total deposits across all users
   * @return _totalWithdrawals Total withdrawals across all users
   * @return _vaultBalance Current vault token balance
   */
  function getVaultStats() external view returns (
    uint256 _totalStaked,
    uint256 _totalDeposits,
    uint256 _totalWithdrawals,
    uint256 _vaultBalance
  ) {
    _totalStaked = IERC20(vaultToken).balanceOf(address(this));
    _vaultBalance = _totalStaked;
    
    // Note: These would need to be tracked separately for accurate totals
    // For now, returning current balance as approximation
    _totalDeposits = _totalStaked;
    _totalWithdrawals = 0;
  }

  /**
   * @dev Emergency function to pause all operations
   * @notice Only the contract owner can call this function
   */
  function emergencyPause() external onlyOwner {
    paused = true;
    emit VaultPaused(true, block.timestamp);
  }

  /**
   * @dev Modifier to check if vault is not paused
   */
  modifier whenNotPaused() {
    if (paused) {
      revert VaultPaused();
    }
    _;
  }
}

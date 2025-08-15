// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

/**
 * @title RebalanceRouter
 * @dev Contract for executing token swaps through Uniswap V3
 * @dev This contract handles token approvals, transfers, and swap execution
 * @dev Designed to work with multiple networks and configurable parameters
 */
contract RebalanceRouter is Ownable, ReentrancyGuard {
  event SwapExecuted(
    address indexed tokenIn,
    address indexed tokenOut,
    uint256 amountIn,
    uint256 amountOut,
    address indexed user
  );
  event ParametersUpdated(
    uint24 feeTier,
    uint256 deadlineBuffer,
    uint256 slippageBps
  );
  event TokenAllowed(address indexed token, bool allowed);
  event RouterPaused(bool paused);

  error InvalidRouterAddress();
  error InvalidFeeTier();
  error InvalidDeadlineBuffer();
  error InvalidSlippage();
  error MaxDeadlineTooLow();
  error MaxSlippageTooLow();
  error InvalidMinSwapAmount();
  error RouterPaused();
  error InvalidToken();
  error InvalidAmount();
  error InsufficientAllowance();
  error SwapFailed();
  error InvalidParameters();
  error InvalidTokenAddress();
  error FeeTransferFailed();
  error RefundTransferFailed();

  /// @dev Uniswap V3 router interface for executing swaps
  ISwapRouter public immutable router;
  
  /// @dev Default fee tier for swaps (5000 = 0.5%)
  uint24 public defaultFeeTier;
  
  /// @dev Default deadline buffer in seconds
  uint256 public defaultDeadlineBuffer;
  
  /// @dev Default slippage tolerance in basis points (100 = 1%)
  uint256 public defaultSlippageBps;
  
  /// @dev Maximum deadline buffer allowed
  uint256 public immutable maxDeadlineBuffer;
  
  /// @dev Maximum slippage tolerance allowed
  uint256 public immutable maxSlippageBps;
  
  /// @dev Minimum swap amount to prevent dust attacks
  uint256 public immutable minSwapAmount;
  
  /// @dev Pause flag for emergency situations
  bool public paused;
  
  /// @dev Mapping of allowed tokens for swaps
  mapping(address => bool) public allowedTokens;
  
  /// @dev Array of allowed token addresses
  address[] public allowedTokensList;

  /**
   * @dev Constructor initializes the router with configurable parameters
   * @param _router Uniswap V3 router address
   * @param _defaultFeeTier Default fee tier for swaps (e.g., 5000 for 0.5%)
   * @param _defaultDeadlineBuffer Default deadline buffer in seconds
   * @param _defaultSlippageBps Default slippage tolerance in basis points
   * @param _maxDeadlineBuffer Maximum deadline buffer allowed
   * @param _maxSlippageBps Maximum slippage tolerance allowed
   * @param _minSwapAmount Minimum swap amount to prevent dust attacks
   */
  constructor(
    address _router,
    uint24 _defaultFeeTier,
    uint256 _defaultDeadlineBuffer,
    uint256 _defaultSlippageBps,
    uint256 _maxDeadlineBuffer,
    uint256 _maxSlippageBps,
    uint256 _minSwapAmount
  ) {
    if (_router == address(0)) revert InvalidRouterAddress();
    if (_defaultFeeTier == 0) revert InvalidFeeTier();
    if (_defaultDeadlineBuffer == 0) revert InvalidDeadlineBuffer();
    if (_defaultSlippageBps == 0) revert InvalidSlippage();
    if (_maxDeadlineBuffer < _defaultDeadlineBuffer) revert MaxDeadlineTooLow();
    if (_maxSlippageBps < _defaultSlippageBps) revert MaxSlippageTooLow();
    if (_minSwapAmount == 0) revert InvalidMinSwapAmount();
    
    router = ISwapRouter(_router);
    defaultFeeTier = _defaultFeeTier;
    defaultDeadlineBuffer = _defaultDeadlineBuffer;
    defaultSlippageBps = _defaultSlippageBps;
    maxDeadlineBuffer = _maxDeadlineBuffer;
    maxSlippageBps = _maxSlippageBps;
    minSwapAmount = _minSwapAmount;
  }

  /**
   * @dev Executes a token swap through Uniswap V3
   * @param _tokenIn The address of the input token
   * @param _tokenOut The address of the output token
   * @param _amountIn The amount of input tokens to swap
   * @param _feeTier Fee tier for the swap (0 for default)
   * @param _deadlineBuffer Deadline buffer in seconds (0 for default)
   * @param _slippageBps Slippage tolerance in basis points (0 for default)
   * @return amountOut The amount of output tokens received
   * @notice Requires the caller to have approved this contract to spend the input tokens
   * @notice The contract will transfer tokens from the caller, execute the swap, and send output tokens back
   */
  function swapTokens(
    address _tokenIn,
    address _tokenOut,
    uint256 _amountIn,
    uint24 _feeTier,
    uint256 _deadlineBuffer,
    uint256 _slippageBps
  ) external nonReentrant whenNotPaused returns (uint256 amountOut) {
    if (_amountIn < minSwapAmount) {
      revert InvalidAmount();
    }
    
    if (!allowedTokens[_tokenIn] || !allowedTokens[_tokenOut]) {
      revert InvalidToken();
    }

    // Use default values if not specified
    uint24 feeTier = _feeTier > 0 ? _feeTier : defaultFeeTier;
    uint256 deadlineBuffer = _deadlineBuffer > 0 ? _deadlineBuffer : defaultDeadlineBuffer;
    uint256 slippageBps = _slippageBps > 0 ? _slippageBps : defaultSlippageBps;
    
    // Validate parameters
    if (deadlineBuffer > maxDeadlineBuffer) {
      revert InvalidParameters();
    }
    if (slippageBps > maxSlippageBps) {
      revert InvalidParameters();
    }

    uint256 allowance = IERC20(_tokenIn).allowance(msg.sender, address(this));
    if (allowance < _amountIn) {
      revert InsufficientAllowance();
    }

    // Transfer tokens from caller to this contract
    TransferHelper.safeTransferFrom(
      _tokenIn,
      msg.sender,
      address(this),
      _amountIn
    );

    // Approve router to spend input tokens
    TransferHelper.safeApprove(_tokenIn, address(router), _amountIn);

    // Build swap parameters
    ISwapRouter.ExactInputSingleParams memory params = _buildInputParams(
      _tokenIn,
      _tokenOut,
      _amountIn,
      feeTier,
      deadlineBuffer,
      slippageBps
    );

    // Execute swap
    amountOut = router.exactInputSingle(params);
    
    if (amountOut == 0) {
      revert SwapFailed();
    }

    // Transfer output tokens to caller
    TransferHelper.safeTransfer(_tokenOut, msg.sender, amountOut);

    emit SwapExecuted(_tokenIn, _tokenOut, _amountIn, amountOut, msg.sender);
    
    return amountOut;
  }

  /**
   * @dev Builds the parameters for a single exact input swap
   * @param _tokenIn The address of the input token
   * @param _tokenOut The address of the output token
   * @param _amountIn The amount of input tokens
   * @param _feeTier Fee tier for the swap
   * @param _deadlineBuffer Deadline buffer in seconds
   * @param _slippageBps Slippage tolerance in basis points
   * @return The ExactInputSingleParams struct for the swap
   */
  function _buildInputParams(
    address _tokenIn,
    address _tokenOut,
    uint256 _amountIn,
    uint24 _feeTier,
    uint256 _deadlineBuffer,
    uint256 _slippageBps
  ) internal view returns (ISwapRouter.ExactInputSingleParams memory) {
    uint256 deadline = block.timestamp + _deadlineBuffer;
    uint256 amountOutMinimum = (_amountIn * (10000 - _slippageBps)) / 10000;

    return ISwapRouter.ExactInputSingleParams({
      tokenIn: _tokenIn,
      tokenOut: _tokenOut,
      fee: _feeTier,
      recipient: address(this),
      deadline: deadline,
      amountIn: _amountIn,
      amountOutMinimum: amountOutMinimum,
      sqrtPriceLimitX96: 0
    });
  }

  /**
   * @dev Updates router parameters
   * @param _feeTier New default fee tier
   * @param _deadlineBuffer New default deadline buffer
   * @param _slippageBps New default slippage tolerance
   * @notice Only the contract owner can call this function
   */
  function updateParameters(
    uint24 _feeTier,
    uint256 _deadlineBuffer,
    uint256 _slippageBps
  ) external onlyOwner {
    if (_feeTier == 0 || _deadlineBuffer == 0 || _slippageBps == 0) {
      revert InvalidParameters();
    }
    if (_deadlineBuffer > maxDeadlineBuffer) {
      revert InvalidParameters();
    }
    if (_slippageBps > maxSlippageBps) {
      revert InvalidParameters();
    }

    defaultFeeTier = _feeTier;
    defaultDeadlineBuffer = _deadlineBuffer;
    defaultSlippageBps = _slippageBps;

    emit ParametersUpdated(_feeTier, _deadlineBuffer, _slippageBps);
  }

  /**
   * @dev Allows or disallows a token for swaps
   * @param _token The token address to allow/disallow
   * @param _allowed Whether to allow the token
   * @notice Only the contract owner can call this function
   */
  function setTokenAllowed(address _token, bool _allowed) external onlyOwner {
    if (_token == address(0)) revert InvalidTokenAddress();
    
    if (_allowed && !allowedTokens[_token]) {
      allowedTokens[_token] = true;
      allowedTokensList.push(_token);
    } else if (!_allowed && allowedTokens[_token]) {
      allowedTokens[_token] = false;
      
      // Remove from array
      for (uint256 i = 0; i < allowedTokensList.length; i++) {
        if (allowedTokensList[i] == _token) {
          allowedTokensList[i] = allowedTokensList[allowedTokensList.length - 1];
          allowedTokensList.pop();
          break;
        }
      }
    }
    
    emit TokenAllowed(_token, _allowed);
  }

  /**
   * @dev Returns the list of allowed tokens
   * @return Array of allowed token addresses
   */
  function getAllowedTokens() external view returns (address[] memory) {
    return allowedTokensList;
  }

  /**
   * @dev Pauses or unpauses the router
   * @param _paused Whether to pause the router
   * @notice Only the contract owner can call this function
   */
  function setPaused(bool _paused) external onlyOwner {
    paused = _paused;
    emit RouterPaused(_paused);
  }

  /**
   * @dev Emergency function to pause all operations
   * @notice Only the contract owner can call this function
   */
  function emergencyPause() external onlyOwner {
    paused = true;
    emit RouterPaused(true);
  }

  /**
   * @dev Returns router configuration
   * @return _router Router address
   * @return _feeTier Current default fee tier
   * @return _deadlineBuffer Current default deadline buffer
   * @return _slippageBps Current default slippage tolerance
   * @return _paused Whether router is paused
   */
  function getRouterConfig() external view returns (
    address _router,
    uint24 _feeTier,
    uint256 _deadlineBuffer,
    uint256 _slippageBps,
    bool _paused
  ) {
    _router = address(router);
    _feeTier = defaultFeeTier;
    _deadlineBuffer = defaultDeadlineBuffer;
    _slippageBps = defaultSlippageBps;
    _paused = paused;
  }

  /**
   * @dev Modifier to check if router is not paused
   */
  modifier whenNotPaused() {
    if (paused) {
      revert RouterPaused();
    }
    _;
  }
}

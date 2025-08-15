// SPDX-License-Identifier: Apache-2.0 (see LICENSE)
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title IRebalanceRouter Interface
 * @dev Interface for rebalancing router contracts that handle token swaps
 * @dev Defines the standard functions for executing swaps through different protocols
 * @dev Supports both generic swap operations and Clipper-specific swaps
 */
interface IRebalanceRouter {
  /**
   * @dev Executes a token swap using provided swap data
   * @param _amountIn The amount of input tokens to swap
   * @param _tokenIn The address of the input token
   * @param _tokenOut The address of the output token
   * @param _swapData Calldata containing the swap parameters
   * @return amountOut The amount of output tokens received
   */
  function swap(
    uint256 _amountIn,
    address _tokenIn,
    address _tokenOut,
    bytes calldata _swapData
  ) external returns (uint256 amountOut);

  /**
   * @dev Executes a token swap using the Clipper protocol
   * @param srcToken The source token to swap from
   * @param dstToken The destination token to swap to
   * @param amount The amount of source tokens to swap
   * @param minReturn The minimum amount of destination tokens to receive
   * @return returnAmount The actual amount of destination tokens received
   */
  function clipperSwap(
    IERC20 srcToken,
    IERC20 dstToken,
    uint256 amount,
    uint256 minReturn
  ) external returns (uint256 returnAmount);
}

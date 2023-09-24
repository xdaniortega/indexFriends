// SPDX-License-Identifier: Apache-2.0 (see LICENSE)
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title IRebalanceRouter

interface IRebalanceRouter {
  function swap(
    uint256 _amountIn,
    address _tokenIn,
    address _tokenOut,
    bytes calldata _swapData
  ) external returns (uint256 amountOut);

  function clipperSwap(
    IERC20 srcToken,
    IERC20 dstToken,
    uint256 amount,
    uint256 minReturn
  ) external returns (uint256 returnAmount);
}

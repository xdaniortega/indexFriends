// SPDX-License-Identifier: Apache-2.0 (see LICENSE)
pragma solidity ^0.8.8;

//import {IRebalanceRouter} from "./interfaces/IRebalanceRouter.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

/// @title RebalanceRouter

//this contract should be the one that will comunicate with 1inch contracts,
contract RebalanceRouter is IRebalanceRouter {
  ISwapRouter public router;

  struct ExactInputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 deadline;
    uint256 amountIn;
    uint256 amountOutMinimum;
    uint160 sqrtPriceLimitX96;
  }

  struct ExactOutputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 deadline;
    uint256 amountOut;
    uint256 amountInMaximum;
    uint160 sqrtPriceLimitX96;
  }

  constructor() {
    /* See interface at https://www.npmjs.com/package/@uniswap/v3-periphery?activeTab=code */
    router = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564); //UNISWAP ON CELO NETWORK
  }

  function swapTokens(
    address tokenIn_,
    address tokenOut_,
    uint256 amountIn_
  ) internal returns (uint256 amountOut) {
    require(amountIn_ > 0);

    //check whether _tokenIn has been allowed by the user for the amount given
    uint256 allowance = IERC20(_tokenIn).allowance(msg.sender, address(this));
    require(allowance >= amountIn, "Amount is greater than allowance");

    // Transfer amountIn of _tokenIn to this contract.
    TransferHelper.safeTransferFrom(
      _tokenIn,
      msg.sender,
      address(this),
      amountIn
    );

    // Approve uniswapRouter to spend _tokenIn.
    TransferHelper.safeApprove(_tokenIn, address(uniswapRouter), amountIn);

    ISwapRouter.ExactInputSingleParams memory params = _buildInputParams(
      _tokenIn,
      _tokenOut,
      amountIn
    );

    amountOut = uniswapRouter.exactInputSingle(params);
    return amountOut;
  }

  function _buildInputParams(
    address tokenIn_,
    address tokenOut_,
    uint256 amountIn_
  ) internal returns (ExactInputSingleParams e) {
    uint24 fee = 5000;
    address recipient = msg.sender;
    uint256 deadline = block.timestamp + 10;
    uint256 amountOutMinimum = 1;
    uint160 sqrtPriceLimitX96 = 0;

    return
      ExactInputSingleParams(
        tokenIn_,
        tokenOut_,
        fee,
        recipient,
        deadline,
        amountIn_,
        amountOutMinimum,
        sqrtPriceLimitX96
      );
  }
}

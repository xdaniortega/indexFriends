// SPDX-License-Identifier: Apache-2.0 (see LICENSE)
pragma solidity ^0.8.8;

//import {IRebalanceRouter} from "./interfaces/IRebalanceRouter.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title RebalanceRouter

//this contract should be the one that will comunicate with 1inch contracts,
contract RebalanceRouter {
  ISwapRouter public router;

  constructor() {
    /* See interface at https://www.npmjs.com/package/@uniswap/v3-periphery?activeTab=code */
    //router = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564); //UNISWAP ON CELO NETWORK
    router = ISwapRouter(0x5615CDAb10dc425a742d643d949a7F474C01abc4); //UNISWAP ON CELO NETWORK
  }

  function swapTokens(
    address tokenIn_,
    address tokenOut_,
    uint256 amountIn_
  ) public returns (uint256 amountOut) {
    require(amountIn_ > 0);

    //check whether _tokenIn has been allowed by the user for the amount given
    uint256 allowance = IERC20(tokenIn_).allowance(msg.sender, address(this));
    require(
      allowance >= amountIn_,
      "RebalanceRouter: Amount is greater than allowance"
    );

    // Transfer amountIn of _tokenIn to this contract.
    TransferHelper.safeTransferFrom(
      tokenIn_,
      msg.sender,
      address(this),
      amountIn_
    );

    // Approve uniswapRouter to spend _tokenIn.
    TransferHelper.safeApprove(tokenIn_, address(router), amountIn_);

    ISwapRouter.ExactInputSingleParams memory params = _buildInputParams(
      tokenIn_,
      tokenOut_,
      amountIn_
    );

    amountOut = router.exactInputSingle(params);
    return amountOut;
  }

  function _buildInputParams(
    address tokenIn_,
    address tokenOut_,
    uint256 amountIn_
  ) internal view returns (ISwapRouter.ExactInputSingleParams memory e) {
    uint24 fee = 5000;
    address recipient = msg.sender;
    uint256 deadline = block.timestamp + 10;
    uint256 amountOutMinimum = 1;
    uint160 sqrtPriceLimitX96 = 0;

    return
      ISwapRouter.ExactInputSingleParams(
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

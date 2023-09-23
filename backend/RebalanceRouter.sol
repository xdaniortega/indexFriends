// SPDX-License-Identifier: Apache-2.0 (see LICENSE)
pragma solidity ^0.8.8;

import {IRebalanceRouter} from "./interfaces/IRebalanceRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
/// @title RebalanceRouter

//this contract should be the one that will comunicate with 1inch contracts,
contract RebalanceRouter is IRebalanceRouter {
  IRebalanceRouter public uniSwap;

  constructor(address uniSwapAddress) {
    uniSwap = IRebalanceRouter(uniSwapAddress);
  }

  /*function clipperSwap(
    IERC20 srcToken,
    IERC20 dstToken,
    uint256 amount,
    uint256 minReturn
  ) external returns (uint256 returnAmount); */

    function clipperSwap(
    )

}

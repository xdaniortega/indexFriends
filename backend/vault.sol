// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.8;

/// @title VAULT

contract vault is Ownable {
  address public token; //can be allowedTokens in a future
  mapping(address => uint) public stakingBalance;

  constructor() {
    token = 0x0; //USDC token adress
  }

  function deposit(uint amount_) public payable {
    require(
      IERC20(token).allowance(msg.sender, address(this)),
      "Not approved to send balance requested"
    );
    bool success = IERC20(token).transferFrom(
      msg.sender,
      address(this),
      _amount
    );
    require(success, "Transaction was not successful");
  }

  function subscribeToStrategy() {}

  function depositAndSubscribe(uint amount_) public {
    bool successfulDeposit = deposit(amount_);
    require(successfulDeposit);
    bool succesfullSubscribe = subscribeToStrategy();
    require(succesfullSubscribe);
  }
}

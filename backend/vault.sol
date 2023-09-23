// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.8;

/// @title VAULT

contract Vault is Ownable {
  address public token; //can be allowedTokens in a future
  mapping(address => uint) public stakingBalance;

  constructor() {
    token = address(0xFEca406dA9727A25E71e732F9961F680059eF1F9); //USDC token adress in polygon MUMBAI TESTNET
  }

  function depositFunds(uint amount_) public payable {
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

    //APPROVE THE VAULT TO SEND FUNDS TO THE STRATEGY
    IERC20(token).approve(strategy, amount_);
  }

  function withdrawFunds(uint amount_) public payable {
    require(
      IERC20(token).allowance(address(this), msg.sender),
      "Not approved to send balance requested"
    );
    bool success = IERC20(token).transferFrom(
      address(this),
      msg.sender,
      _amount
    );
    require(success, "Transaction was not successful");
  }

  function subscribeToStrategy(address strategy) {
    bool success = IERC20(token).transferFrom(
      address(this),
      strategy,
      stakingBalance[msg.sender]
    ); //Transfer funds from vault to strategy
    //require(success, "Transaction was not successful");
  }

  /*function depositAndSubscribe(uint amount_) public {
    bool successfulDeposit = deposit(amount_);
    require(successfulDeposit);
    bool succesfullSubscribe = subscribeToStrategy();
    require(succesfullSubscribe);
  }*/
}

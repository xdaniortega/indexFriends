// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.8;

import "../Rules/Rules.sol";

/// @title Strategy

contract Strategy is Ownable {
  mapping(address => uint) public tokenPercentatges;

  modifier onlyProvider() {
    require(msg.sender == address(0x0)); //Company address
  }

  constructor(address rules_) {
    token = 0x0; //USDC token adress
    rules = Rules(rules_); //Set the address of the rules contract;
  }

  //About Token Percentatges
  function setTokenPercentage(address token_, uint percentage_) public {
    require(percentage_ <= 100, "Percentage must be less than 100");
    tokenPercentatges[token_] = percentage_;
  }

  function getTokenPercentatges(address token_) public view returns (uint) {
    return tokenPercentatges[token_];
  }

  //About Rules
  function setRules(address rules) onlyProvider {
    rules = Rules(rules);
  }

  function getTokenRules() {
    Rules rules = Rules(address(0x0));
    rules.isTokenAllowed(address(0x0));
  }
}

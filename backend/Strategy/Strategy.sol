// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IRebalanceRouter.sol";

pragma solidity ^0.8.8;

import "../Rules/Rules.sol";

/// @title Strategy

contract Strategy is Ownable {
  mapping(address => uint) public tokenPercentatges;
  mapping(address => uint) public userBalances;
  address NFTAlias;
  IRebalanceRouter rebalanceRouter;

  modifier onlyProvider() {
    require(msg.sender == address(0x0)); //Company address
  }

  constructor(address rules_, address NFTAlias_, address rebalanceRouter_) {
    rules = Rules(rules_); //Set the address of the rules contract;
    NFTAlias = NFTAlias_;
    rebalanceRouter = IRebalanceRouter(rebalanceRouter_);
  }

  function getTokenPercentatges(address token_) public view returns (uint) {
    return tokenPercentatges[token_];
  }

  //About Rules

  function getTokenRules() {
    Rules rules = Rules(address(0x0));
    rules.isTokenAllowed(address(0x0));
  }

  //Deposit Function
  function depositFromVault(address user_, amount_) internal payable {
    //Not sure if we have to approve this
    require(
      IERC20(token).allowance(msg.sender, address(this)),
      "Not approved to send balance requested"
    );
    bool success = IERC20(token).transferFrom(
      msg.sender,
      address(this),
      amount_
    );
    require(success, "Transaction was not successful");

    //UpdateUsersBalance
    userBalances[user_] += amount_;

    rebalanceRouter.purchase();
  }

  //NFT Holder actions
  //About Token Percentatges
  function setTokenPercentage(address token_, uint percentage_) public {
    require(percentage_ <= 100, "Percentage must be less than 100");
    require(rules.isTokenAllowed(_token), "Token is not allowed");
    tokenPercentatges[token_] = percentage_;

    updateBalances();
  }

  function updateBalances() internal {}
}

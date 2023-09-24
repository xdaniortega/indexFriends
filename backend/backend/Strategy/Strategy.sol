// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//import "../interfaces/IRebalanceRouter.sol";

pragma solidity ^0.8.8;

import "../Rules.sol";

/// @title Strategy

contract Strategy is Ownable {
  mapping(address => uint) public tokenPercentatges;
  mapping(address => uint) public userBalances;
  address tokenId;
  Rules rules;
  address[] tokensAllowed;
  IERC721 nftCollection;

  IRebalanceRouter rebalanceRouter;

  modifier onlyProvider() {
    require(msg.sender == address(0xdb9927C4e5480F50A79B3C0279Eeb1Cc3F370365)); //Company public address
  }

  modifier onlyNFTOwner(uint256 tokenId_) {
    require(msg.sender == nftCollection.ownerOf(tokenId_));
    _;
  }

  constructor(address rules_, address tokenId_) {
    rules = Rules(rules_); //Set the address of the rules contract;
    tokenId = tokenId_;
    tokensAllowed = rules.getAllowedTokenList();
    IERC721 nftCollection = IERC721(rules.getAllowedNFTCollection());

    for (int i = 0; i < tokensAllowed.length; i++) {
      tokenPercentatges[tokensAllowed[i]] = 0;
    }
    //rebalanceRouter = IRebalanceRouter(rebalanceRouter_);
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

    //rebalanceRouter.purchase(); //TODO
  }

  //NFT Holder actions
  //About Token Percentatges
  function setTokenPercentage(
    address token_,
    uint percentage_
  ) public onlyNFTOwner {
    require(percentage_ <= 100, "Percentage must be less than 100");
    require(rules.isTokenAllowed(_token), "Token is not allowed");
    tokenPercentatges[token_] = percentage_;

    updateBalances();
  }

  //About Token Percentatges
  function setTokenPercentagesInBatch(
    address[] token_,
    uint[] percentages_
  ) public onlyNFTOwner {
    uint256 counter = 0;
    for (uint256 i = 0; i < token_.length; i++) {
      counter += percentages_[i];
      require(percentages_[i] <= 100, "Percentage must be less than 100");
      require(counter <= 100, "Percentage must be less than 100");

      require(rules.isTokenAllowed(_token[i]), "Token is not allowed");
      tokenPercentatges[token_[i]] = percentage_[i];
    }

    updateBalances();
  }

  function updateBalances() internal {}
}

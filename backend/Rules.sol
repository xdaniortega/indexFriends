// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.8;

/// @title Rules Contract, here we can define allowedTokens, timeouts for withdrawals,...

contract Rules is Ownable {
  event AllowedToken(address indexed token_);
  event RemovedToken(address indexed token_);

  modifier onlyOwner() {
    msg.sender = owner;
  }

  mapping(address => bool) public allowedTokens; //can be allowedTokens in a future

  constructor() {}

  function setNewToken(address token_) onlyOwner {
    allowedTokens[token_] = true;
    emit AllowedToken(token_);
  }

  function removeToken(address token_) onlyOwner {
    allowedTokens[token_] = false;
    emit RemovedToken(token_);
  }

  function isTokenAllowed(address _token) public view returns (bool) {
    return allowedTokens[_token];
  }

  function setTimeoutForWithdrawal() public {}
}

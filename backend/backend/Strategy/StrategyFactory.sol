// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./Strategy.sol";
import "../Rules.sol";

contract StrategyFactory is Ownable {
  // List of Strategy contracts deployed by this Factory
  address[] public deployedStrategies;
  Rules rules;
  IERC721 nftCollection;

  event StrategyDeployed(address indexed strategyAddress);

  modifier onlyOwner() {
    msg.sender = owner;
  }

  modifier onlyNFTOwner(uint256 tokenId_) {
    require(msg.sender == nftCollection.ownerOf(tokenId_));
    _;
  }

  constructor(address rules) {
    rules = new Rules(rules);
    nftCollection = IERC721(rules.getAllowedNFTCollection());
  }

  function deployStrategy(
    uint256 tokenId_
  ) external onlyNFTOwner returns (address) {
    Strategy newStrategy = new Strategy(rules, tokenId_);
    deployedStrategies.push(address(newStrategy));

    emit StrategyDeployed(address(newStrategy));

    return address(newStrategy);
  }

  function listDeployedStrategies() external view returns (address[] memory) {
    return deployedStrategies;
  }

  function setRules(address rules) onlyOwner {
    rules = Rules(rules);
  }
}

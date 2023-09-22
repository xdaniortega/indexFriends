// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Strategy.sol";
import "../Rules/Rules.sol";

contract StrategyFactory is Ownable {
  // List of Strategy contracts deployed by this Factory
  address[] public deployedStrategies;
  Rules rules;

  event StrategyDeployed(address indexed strategyAddress);

  modifier onlyOwner() {
    msg.sender = owner;
  }

  constructor(address rules) {
    rules = new Rules(rules);
  }

  function deployStrategy() external onlyOwner returns (address) {
    Strategy newStrategy = new Strategy(rules);
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

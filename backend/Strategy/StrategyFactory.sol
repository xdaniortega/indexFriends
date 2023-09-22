// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Strategy.sol"; // Assuming Strategy.sol is in the same folder

contract StrategyFactory is Ownable {
  // List of Strategy contracts deployed by this Factory
  address[] public deployedStrategies;

  event StrategyDeployed(address indexed strategyAddress);
8
  function deployStrategy(
    address rulesAddress
  ) external onlyOwner returns (address) {
    Strategy newStrategy = new Strategy(rulesAddress);
    deployedStrategies.push(address(newStrategy));

    emit StrategyDeployed(address(newStrategy));

    return address(newStrategy);
  }

  function listDeployedStrategies() external view returns (address[] memory) {
    return deployedStrategies;
  }
}

// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";

interface ISimpleStore {
  function setValue(uint256) external;
  function getValue() external view returns (uint256);
}

contract DeployFakeNFTMarketPlace is Script {
  function run() public returns (ISimpleStore simpleStore) {
    vm.startBroadcast();
    simpleStore = ISimpleStore(
      HuffDeployer
        .config()
        .deploy("SimpleStore")
    );
    vm.stopBroadcast();
  }
}

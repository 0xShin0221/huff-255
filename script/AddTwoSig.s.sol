// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";

interface IAddTwoSig {
	 function addTwo(uint256,uint256) external returns (uint256);
}

contract DeployFakeNFTMarketPlace is Script {
  function run() public returns (IAddTwoSig AddTwoSig) {
    vm.startBroadcast();
    IAddTwoSig(
      HuffDeployer
        .config()
        .deploy("AddTwoSig")
    );
    vm.stopBroadcast();
  }
}

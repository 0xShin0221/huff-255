// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";

interface IFakeNFTMarketPlace {
	function available(uint256) external view returns (bool);
	function getPrice() external returns (uint256);
	function purchase(uint256) external;
}

contract DeployFakeNFTMarketPlace is Script {
  function run() public returns (IFakeNFTMarketPlace fakeNFTMarketplace) {
    vm.startBroadcast();
    IFakeNFTMarketPlace(
      HuffDeployer
        .config()
        .deploy("FakeNFTMarketPlace")
    );
    vm.stopBroadcast();
  }
}

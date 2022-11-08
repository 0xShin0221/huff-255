// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import {Script} from "forge-std/Script.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import "../src/IBlckNum.sol";

contract DeployBlckNum is Script {
    function run() external {
        // deployed = HuffDeployer.deploy("BlckNum");

        vm.startBroadcast();

        IBlckNum(
            HuffDeployer
                .config()
                .deploy("BlckNum")
        );

        vm.stopBroadcast();
    }
}

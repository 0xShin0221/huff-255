// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract BlckNumTest is Test {
    /// @dev Address of the BlckNum contract.
    BlckNum public blckNum;

    /// @dev Setup the testing environment.
    function setUp() public {
        blckNum = BlckNum(HuffDeployer.deploy("BlckNum"));
    }

    // /// @dev Ensure that you can set and get the value.
    // function testSetAndGetValue(uint256 value) public {
    //     simpleStore.setValue(value);
    //     console.log(value);
    //     console.log(simpleStore.getValue());
    //     assertEq(value, simpleStore.getValue());
    // }
}

interface BlckNum {
    // function setValue(uint256) external;
    // function getValue() external returns (uint256);
}

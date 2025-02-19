// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract SimpleStoreTest is Test {
    /// @dev Address of the SimpleStore contract.
    SimpleStore public simpleStore;

    /// @dev Setup the testing environment.
    function setUp() public {
        simpleStore = SimpleStore(HuffDeployer.deploy("huff/SimpleStore"));
    }

    /// @dev Ensure that you can set and get the value.
    function testSetAndGetValue() public {
        uint256 value = 42;
        simpleStore.setValue(value);
        console.log(value);
        console.log(simpleStore.getValue());
        assertEq(value, simpleStore.getValue());
    }

    function testSettledValue() public {
        uint256 value = 42;
        simpleStore.setValue(value);
        // console.log(value);
        // console.log(simpleStore.getValue());
        // assertEq(value, simpleStore.getValue());
    }
}

interface SimpleStore {
    function setValue(uint256) external;
    function getValue() external returns (uint256);
}
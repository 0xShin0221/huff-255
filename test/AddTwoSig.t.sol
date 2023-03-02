// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract AddTwoTest is Test {
    /// @dev Address of the AddTwo contract.
    IAddTwoSig public addTwoSig;
    /// @dev Setup the testing environment.
    function setUp() public {
        addTwoSig = IAddTwoSig(HuffDeployer.deploy("AddTwoSIG"));
    }

    /// @dev Ensure that you can set and get the value.
    function testAddTwo(uint256 _value1, uint256 _value2) public {
        uint256 result = addTwoSig.addTwo(_value1,_value2);
        console.log(_value1);
        console.log(result);
        uint256 expect = _value1 + _value2;
        assertEq(expect, result);
    }
}
interface IAddTwoSig {
    function addTwo(uint256,uint256) external returns (uint256);
}
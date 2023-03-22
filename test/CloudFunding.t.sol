// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
contract CludFunding is Test {

    /// @dev Address of the CloudFunding contract.
    ICloudFunding public cloudFunding;

    /// @dev Setup the testing environment.
    function setUp() public {
        cloudFunding = ICloudFunding(HuffDeployer.deploy("huff/CloudFunding"));
    }

    /// @dev Ensure that you can set and get the value.
    function testPurchase(uint256 tokenId) public {

    }
}

interface ICloudFunding {

}
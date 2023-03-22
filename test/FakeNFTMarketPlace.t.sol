// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";


contract FakeNFTMarketPlaceTest is Test {
    /// @dev Address of the FakeNFTMarketPlace contract.
    FakeNFTMarketPlace public fakeNFTMarketPlace;

    /// @dev Setup the testing environment.
    function setUp() public {
        fakeNFTMarketPlace = FakeNFTMarketPlace(HuffDeployer.deploy("huff/FakeNFTMarketPlace"));
    }

    /// @dev Ensure that you can set and get the value.
    function testSetPrice() public {
        // console.logString("testPurchase");
        // console.logUint(1e18);
        uint256 value = 1;
        fakeNFTMarketPlace.setPrice(value);
        console.log('value',value);
        console.log('fakeNFTMarketPlace.getPrice()',fakeNFTMarketPlace.getPrice());
        assertEq(value, fakeNFTMarketPlace.getPrice());
    }

    function testPurchase() public {
        uint256 value = 1;
        fakeNFTMarketPlace.setPrice(value);
        fakeNFTMarketPlace.purchase(value);

        console.log(fakeNFTMarketPlace.getPrice());
        assertEq(value, fakeNFTMarketPlace.getValue(value));
    }
}

interface FakeNFTMarketPlace {
    function purchase(uint256) external;
    function getValue(uint256) external returns (uint256);
    function getPrice() external returns (uint256);
    function setPrice(uint256) external;
}
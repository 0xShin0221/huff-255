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
        fakeNFTMarketPlace = FakeNFTMarketPlace(HuffDeployer.deploy("FakeNFTMarketPlace"));
    }

    /// @dev Ensure that you can set and get the value.
    function testPurchase(uint256 tokenId) public {
        fakeNFTMarketPlace.purchase(tokenId);
        console.log(tokenId);
        // console.log(fakeNFTMarketPlace.getPrice());
        // assertEq(value, fakeNFTMarketPlace.getValue());
    }
}

interface FakeNFTMarketPlace {
    function purchase(uint256) external;
    function getPrice() external returns (uint256);
}
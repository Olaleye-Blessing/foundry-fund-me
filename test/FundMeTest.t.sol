// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "./../src/FundMe.sol";

contract FundMeTest is Test {
  FundMe fundMe;
  function setUp() external {
    // Sepolia ETH / USD Address
    // https://docs.chain.link/data-feeds/price-feeds/addresses
    fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
  }

  function testMinimumDollarIs5() public view {
    assertEq(fundMe.MINIMUM_USD(), 5e18);
  }

  function testOwnerIsMsgSender() public view {
    assertEq(address(this), fundMe.i_owner());
  }

  function testVersionIsAccurate() public view {
    uint256 version = fundMe.getVersion();
    assertEq(version, 4);
  }
}

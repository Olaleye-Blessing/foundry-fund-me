// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "./../src/FundMe.sol";
import { DeployFundMe } from "./../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
  FundMe fundMe;

  function setUp() external {
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    // fundMe = (new DeployFundMe()).run();
  }

  function testMinimumDollarIs5() public view {
    assertEq(fundMe.MINIMUM_USD(), 5e18);
  }

  function testOwnerIsMsgSender() public view {
    // assertEq(address(this), fundMe.i_owner());
    assertEq(msg.sender, fundMe.i_owner());
  }

  function testVersionIsAccurate() public view {
    uint256 version = fundMe.getVersion();
    assertEq(version, 4);
  }
}

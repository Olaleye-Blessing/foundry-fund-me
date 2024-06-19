// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "./../src/FundMe.sol";
import { DeployFundMe } from "./../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
  FundMe fundMe;
  address USER = makeAddr("user");
  uint256 constant START_BALANCE = 30 ether;
  uint256 constant AMOUNT_TO_FUND = 5 ether;

  function setUp() external {
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    // https://book.getfoundry.sh/cheatcodes/deal
    vm.deal(USER, START_BALANCE);
  }

  modifier funded() {
    vm.startPrank(USER);
    fundMe.fund{value: AMOUNT_TO_FUND}();
    vm.stopPrank();
    _;
  }

  function testMinimumDollarIs5() public view {
    assertEq(fundMe.MINIMUM_USD(), 5e18);
  }

  function testOwnerIsMsgSender() public view {
    assertEq(msg.sender, fundMe.getOwner());
  }

  function testVersionIsAccurate() public view {
    uint256 version = fundMe.getVersion();
    assertEq(version, 4);
  }

  // TODO: This test is not working as expected.
  // It's supposed to fail without the `vm.expectRevert()`
  function testFailsWithoutEnoughEth() public {
    // https://book.getfoundry.sh/cheatcodes/prank
    vm.prank(USER);
    // vm.expectRevert(); // this means that next line will revert
    fundMe.fund{value: 0 ether}();
  }

  function testPassWithEnoughEth() public funded {
    uint256 amountFounded = fundMe.getAmountFunded(USER);
    assertEq(amountFounded, AMOUNT_TO_FUND);
  }

  function testAddFunderToFunders() public funded {
    address funder = fundMe.getFunder(0);
    assertEq(funder, USER);
  }

  function testOnlyOwnerCanWithdraw() public funded {
    vm.expectRevert();
    fundMe.withdraw();
  }

  function testWithdrawWithASingleFounder() public funded {
    address owner = fundMe.getOwner();
    address fundMeContract = address(fundMe);
    uint256 startingOwnerBalance = owner.balance;
    uint256 startingContractBalance = fundMeContract.balance;

    vm.prank(owner);
    fundMe.withdraw();

    uint256 endingOwnerBalance = owner.balance;
    uint256 endingContractBalance = fundMeContract.balance;

    assertEq(endingContractBalance, 0);
    assertEq(startingContractBalance + startingOwnerBalance, endingOwnerBalance);
  }

  function testWithdrawFromMultipleFounders() public {
    // uint256 can't be casted into an address
    uint160 numOfFunders = 10;
    uint160 startingFunderIndex = 2;

    for (uint160 i = startingFunderIndex; i < numOfFunders; i++) {
      hoax(address(i), AMOUNT_TO_FUND);
      fundMe.fund{value: AMOUNT_TO_FUND}();
    }

    address owner = fundMe.getOwner();
    address fundMeContract = address(fundMe);
    uint256 startingOwnerBalance = owner.balance;
    uint256 startingContractBalance = fundMeContract.balance;

    vm.prank(owner);
    fundMe.withdraw();

    assertEq(fundMeContract.balance, 0);
    assertEq(startingContractBalance + startingOwnerBalance, owner.balance);
  }

  function testWithdrawFromMultipleFoundersCheaper() public {
    // uint256 can't be casted into an address
    uint160 numOfFunders = 10;
    uint160 startingFunderIndex = 2;

    for (uint160 i = startingFunderIndex; i < numOfFunders; i++) {
      hoax(address(i), AMOUNT_TO_FUND);
      fundMe.fund{value: AMOUNT_TO_FUND}();
    }

    address owner = fundMe.getOwner();
    address fundMeContract = address(fundMe);
    uint256 startingOwnerBalance = owner.balance;
    uint256 startingContractBalance = fundMeContract.balance;

    vm.prank(owner);
    fundMe.cheaperWithdraw();

    assertEq(fundMeContract.balance, 0);
    assertEq(startingContractBalance + startingOwnerBalance, owner.balance);
  }
}

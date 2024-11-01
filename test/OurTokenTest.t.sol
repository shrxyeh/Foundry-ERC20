//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {OurToken} from "../src/Token.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {Test, console2} from "forge-std/Test.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 1000 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 100;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransfer() public {
        uint256 transferAmount = 200 ether;

        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

    function testFailTransferInsufficientBalance() public {
        uint256 transferAmount = STARTING_BALANCE + 1;

        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);
    }

    function testApproveAndTransferFrom() public {
        uint256 approvalAmount = 500 ether;
        uint256 transferAmount = 300 ether;

        // Approve Alice to spend on behalf of Bob
        vm.prank(bob);
        ourToken.approve(alice, approvalAmount);

        // Check allowance
        assertEq(ourToken.allowance(bob, alice), approvalAmount);

        // Alice transfers tokens from Bob
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(
            ourToken.allowance(bob, alice),
            approvalAmount - transferAmount
        );
    }

    function testIncreaseAllowance() public {
        uint256 initialAllowance = 200 ether;
        uint256 increaseAmount = 100 ether;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.prank(bob);
        ourToken.increaseAllowance(alice, increaseAmount);

        assertEq(
            ourToken.allowance(bob, alice),
            initialAllowance + increaseAmount
        );
    }

    function testDecreaseAllowance() public {
        uint256 initialAllowance = 300 ether;
        uint256 decreaseAmount = 100 ether;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.prank(bob);
        ourToken.decreaseAllowance(alice, decreaseAmount);

        assertEq(
            ourToken.allowance(bob, alice),
            initialAllowance - decreaseAmount
        );
    }

    function testDecreaseAllowanceBelowZero() public {
        uint256 initialAllowance = 100 ether;
        uint256 decreaseAmount = 200 ether;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.expectRevert();
        ourToken.decreaseAllowance(alice, decreaseAmount);
    }
}

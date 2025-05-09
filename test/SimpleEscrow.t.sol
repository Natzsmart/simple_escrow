// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleEscrow.sol";

contract SimpleEscrowTest is Test {
    SimpleEscrow public escrow;
    address payer = address(0x1);
    address payee = address(0x2);
    address arbiter = address(0x3);

    function setUp() public {
        vm.deal(payer, 1 ether);
        vm.prank(payer);
        escrow = new SimpleEscrow{value: 1 ether}(payee, arbiter);
    }

    function testInitialValues() public view{
        assertEq(address(escrow).balance, 1 ether);
        assertEq(escrow.payer(), payer);
        assertEq(escrow.payee(), payee);
        assertEq(escrow.arbiter(), arbiter);
        assertEq(escrow.amount(), 1 ether);
        assertFalse(escrow.isApproved());
    }

    function testOnlyArbiterCanApprove() public {
        vm.prank(address(0x4)); // not arbiter
        vm.expectRevert("Only arbiter can approve");
        escrow.approve();
    }

    function testApproveTransfersFunds() public {
        vm.prank(arbiter);
        uint256 beforeBalance = payee.balance;
        escrow.approve();
        assertEq(payee.balance, beforeBalance + 1 ether);
        assertTrue(escrow.isApproved());
    }

    function testFuzz_OnlyArbiterCanApprove(address randomUser) public {
        vm.assume(randomUser != arbiter);
        vm.prank(randomUser);
        vm.expectRevert("Only arbiter can approve");
        escrow.approve();
    }

    function testApproveEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit SimpleEscrow.Approved(arbiter, 1 ether, payee);

        vm.prank(arbiter);
        escrow.approve();
    }
}
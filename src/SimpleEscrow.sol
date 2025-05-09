// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleEscrow {
    address public payer;
    address public payee;
    address public arbiter;
    uint256 public amount;
    bool public isApproved;

    event Approved(address indexed arbiter, uint256 amount, address indexed payee);

    constructor(address _payee, address _arbiter) payable {
        payer = msg.sender;
        payee = _payee;
        arbiter = _arbiter;
        amount = msg.value;
    }

    function approve() external {
        require(msg.sender == arbiter, "Only arbiter can approve");
        require(!isApproved, "Already approved");
        isApproved = true;
        (bool sent,) = payee.call{value: amount}("");
        require(sent, "Transfer failed");

        emit Approved(msg.sender, amount, payee);
    }
}

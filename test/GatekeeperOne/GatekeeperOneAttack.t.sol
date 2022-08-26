// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { GatekeeperOneFactory } from "src/GatekeeperOne/GatekeeperOneFactory.sol";

import { GatekeeperOne } from "src/GatekeeperOne/GatekeeperOne.sol";
import { GatekeeperOneAttack } from "src/GatekeeperOne/GatekeeperOneAttack.sol";

contract GatekeeperOneAttackTest is PRBTest {
    Ethernaut public ethernaut;
    GatekeeperOneFactory public factory;
    GatekeeperOneAttack public attacker;
    address gatekeeperOneInstance;
    address playerAddress = address(0x69);

    function setUp() public {
        vm.startPrank(playerAddress);
            ethernaut = new Ethernaut();
            factory = new GatekeeperOneFactory();
            attacker = new GatekeeperOneAttack();

            ethernaut.registerLevel(factory);
            gatekeeperOneInstance = ethernaut.createLevelInstance(factory);
        vm.stopPrank();
    }

    function testGatekeeperOneAttack() public {
        console.logString("stub");
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";

import { Motorbike, Engine } from "src/Motorbike/Motorbike.sol";
import { MotorbikeAttack } from "src/Motorbike/MotorbikeAttack.sol";
import { MotorbikeFactory } from "src/Motorbike/MotorbikeFactory.sol";

contract MotorbikeAttackTest is PRBTest {
    Ethernaut public ethernaut;
    MotorbikeFactory public factory;
    address public motorbikeInstance;
    MotorbikeAttack public attacker;
    address public playerAddress = address(0x696969);

    bytes[] public depositData;
    bytes[] public multicallData;

    function setUp() public {
        vm.startPrank(playerAddress);
        vm.deal(playerAddress, 69 ether);
        ethernaut = new Ethernaut();
        factory = new MotorbikeFactory();

        ethernaut.registerLevel(factory);
        motorbikeInstance = ethernaut.createLevelInstance(factory);
        vm.stopPrank();
    }

    function testMotorbikeAttack() public {
        Motorbike motorbike = Motorbike(payable(motorbikeInstance));
        vm.startPrank(playerAddress, playerAddress);
        motorbike.initialize();
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { ElevatorFactory } from "src/Elevator/ElevatorFactory.sol";
import { Elevator } from "src/Elevator/Elevator.sol";
import { ElevatorAttack } from "src/Elevator/ElevatorAttack.sol";

contract ElevatorAttackTest is PRBTest {
    Ethernaut public ethernaut;
    ElevatorFactory public factory;
    ElevatorAttack public attacker;
    address public playerAddress;
    address public elevatorInstance;

    function setUp() public {
        ethernaut = new Ethernaut();
        attacker = new ElevatorAttack();
        factory = new ElevatorFactory();
        ethernaut.registerLevel(factory);

        playerAddress = address(0x69);
        vm.deal(playerAddress, 169 ether);
        vm.startPrank(playerAddress);
        elevatorInstance = ethernaut.createLevelInstance{ value: 1 ether }(factory);
        vm.stopPrank();
    }

    function testElevatorAttack() public {
        console.logString("ELEVATOR BEFORE ATTACK");
        console.logBool(Elevator(elevatorInstance).top());
        console.log(Elevator(elevatorInstance).floor());

        attacker.attackElevator(elevatorInstance);

        console.logString("ELEVATOR AFTER ATTACK");
        console.logBool(Elevator(elevatorInstance).top());
        console.log(Elevator(elevatorInstance).floor());

        vm.startPrank(playerAddress);
        bool levelComplete = ethernaut.submitLevelInstance(payable(address(elevatorInstance)));
        assert(levelComplete);
        vm.stopPrank();
    }
}

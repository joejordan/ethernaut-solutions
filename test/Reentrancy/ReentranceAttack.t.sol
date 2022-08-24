// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { ReentranceFactory } from "src/Reentrancy/ReentranceFactory.sol";
import { Reentrance } from "src/Reentrancy/Reentrance.sol";
import { ReentranceAttack } from "src/Reentrancy/ReentranceAttack.sol";

contract ReentranceAttackTest is PRBTest {
    Ethernaut public ethernaut;
    ReentranceFactory public factory;
    ReentranceAttack public attacker;
    address public playerAddress;
    address public reentranceInstance;

    function setUp() public {
        ethernaut = new Ethernaut();
        attacker = new ReentranceAttack();
        factory = new ReentranceFactory();
        ethernaut.registerLevel(factory);
        
        playerAddress = address(0x69);
        vm.deal(playerAddress, 169 ether);
        vm.startPrank(playerAddress);
            reentranceInstance = ethernaut.createLevelInstance{value: 1 ether}(factory);
        vm.stopPrank();
    }

    // When target balance and attack msg.value are nice and round, things are easy...
    function testReentrancyAttackWithRoundedNumbers() public {
        vm.startPrank(address(0x691));
            vm.deal(address(0x691), 1 ether);
            Reentrance(payable(reentranceInstance)).donate{value: 0.003 ether}(reentranceInstance);
        vm.stopPrank();

        vm.startPrank(playerAddress);

            console.logString("TARGET INITIAL BALANCE:::");
            console.log(address(reentranceInstance).balance);

            attacker.attack{value: 0.001 ether}(reentranceInstance);

            // submit level to ensure completeness
            console.logString("TARGET FINAL BALANCE:::");
            console.log(address(reentranceInstance).balance);
            bool levelComplete = ethernaut.submitLevelInstance(payable(address(reentranceInstance)));
            assert(levelComplete);
        vm.stopPrank();
    }

    // but when things get funky, we have to handle some additional awkwardness toward the end
    // of the withdraw sequence so that we don't underflow. UPDATED NOTE: just fixed underflow in the target contract.
    // We handled it for the most part anyway by first taking a modulo withdraw before getting the rest.
    function testReentrancyAttackWithAwkwardNumbers() public {
        // add a random donation to make the total initial balance weird
        vm.startPrank(address(0x691));
            vm.deal(address(0x691), 4 ether);
            Reentrance(payable(reentranceInstance)).donate{value: 3.14159 ether}(reentranceInstance);
        vm.stopPrank();

        vm.startPrank(playerAddress);
            console.logString("TARGET INITIAL BALANCE:::");
            console.log(address(reentranceInstance).balance);

            attacker.attack{value: 0.69 ether}(reentranceInstance);
            
            console.logString("TARGET FINAL BALANCE:::");
            console.log(address(reentranceInstance).balance);

            // submit level to ensure completeness
            bool levelComplete = ethernaut.submitLevelInstance(payable(address(reentranceInstance)));
            assert(levelComplete);
        vm.stopPrank();
    }
}
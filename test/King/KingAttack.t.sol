// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { KingFactory } from "src/King/KingFactory.sol";
import { King } from "src/King/King.sol";
import { KingAttack } from "src/King/KingAttack.sol";
import { Ethernaut } from "src/Ethernaut.sol";

contract KingAttackTest is PRBTest {
    Ethernaut public ethernaut;
    KingFactory public factory;
    KingAttack public attacker;
    address public kingInstance;
    address payable public playerAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        factory = new KingFactory();
        attacker = new KingAttack();
        playerAddress = payable(address(0x69));
        // owner has to register the level, so keep this out of prank
        ethernaut.registerLevel(factory);
        vm.startPrank(playerAddress);
            vm.deal(playerAddress, 100 ether);
            kingInstance = ethernaut.createLevelInstance{value: 0.001 ether}(factory);
        vm.stopPrank();
    }

    function testKingAttack() public {
        vm.startPrank(playerAddress);
            assertEq(King(payable(kingInstance)).prize(), 0.001 ether);
            attacker.forwardFunds{value: 0.002 ether}(payable(address(kingInstance)));
            assertEq(King(payable(kingInstance)).prize(), 0.002 ether);
            console.logString("King Contract Owner:::");
            console.logAddress(King(payable(kingInstance)).owner());

            bool levelComplete = ethernaut.submitLevelInstance(payable(kingInstance));
            assert(levelComplete);
            // assert that we are still the king after level submission
            console.logString("CURRENT KING:::");
            console.logAddress(King(payable(kingInstance))._king());
            console.logString("CURRENT ATTACKER:::");
            console.logAddress(address(attacker));
            assertEq(King(payable(kingInstance))._king(), payable(attacker));

        vm.stopPrank();
    }
}

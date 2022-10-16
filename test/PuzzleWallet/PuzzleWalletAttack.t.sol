// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import { PRBTest } from "@prb/test/PRBTest.sol";

import { Ethernaut } from "src/Ethernaut.sol";

import { PuzzleWallet, PuzzleProxy } from "src/PuzzleWallet/PuzzleWallet.sol";
import { PuzzleWalletFactory } from "src/PuzzleWallet/PuzzleWalletFactory.sol";

contract PuzzleWalletAttackTest is PRBTest {
    Ethernaut public ethernaut;
    PuzzleWalletFactory public factory;
    address payable public puzzleWalletInstance;
    // PuzzleWalletAttack public attacker;
    address public playerAddress = address(0x696969);

    function setUp() public {
        vm.startPrank(playerAddress);
        vm.deal(playerAddress, 69 ether);
        ethernaut = new Ethernaut();
        factory = new PuzzleWalletFactory();

        ethernaut.registerLevel(factory);
        puzzleWalletInstance = ethernaut.createLevelInstance(factory);

        // create attacker
        // attacker = new PuzzleWalletAttack(puzzleWalletInstance, playerAddress);
        vm.stopPrank();
    }

    function testPuzzleWalletAttack() public {
        vm.startPrank(playerAddress);
        PuzzleProxy(puzzleWalletInstance).proposeNewAdmin(playerAddress);

    }
}
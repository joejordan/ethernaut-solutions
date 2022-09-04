// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { MagicNumFactory } from "src/MagicNumber/MagicNumFactory.sol";
import { MagicNum } from "src/MagicNumber/MagicNum.sol";
import { Solver } from "src/MagicNumber/Solver.sol";

import { addressFrom } from "src/utils/addressFrom.sol";

contract MagicNumAttackTest is PRBTest {
    Ethernaut public ethernaut;
    MagicNumFactory public factory;
    address public magicNumInstance;
    address public playerAddress = address(0x696969);

    function setUp() public {
        vm.startPrank(playerAddress);
        ethernaut = new Ethernaut();
        factory = new MagicNumFactory();

        ethernaut.registerLevel(factory);
        magicNumInstance = ethernaut.createLevelInstance(factory);
        vm.stopPrank();
    }

    function testMagicNumAttack() public {
        Solver solver = new Solver();
        MagicNum(magicNumInstance).setSolver(address(solver));

        vm.startPrank(playerAddress, playerAddress);
        // submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(magicNumInstance));
        assert(levelComplete);
        vm.stopPrank();
    }
}

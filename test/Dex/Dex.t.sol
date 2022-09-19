// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { Dex } from "src/Dex/Dex.sol";
import { SwappableToken } from "src/Dex/Dex.sol";
import { DexFactory } from "src/Dex/DexFactory.sol";
import { DexAttack } from "src/Dex/DexAttack.sol";

contract DexAttackTest is PRBTest {
    Ethernaut public ethernaut;
    DexFactory public factory;
    address public dexInstance;
    address public playerAddress = address(0x696969);

    address public token1;
    address public token2;

    DexAttack attacker = new DexAttack();

    function setUp() public {
        vm.startPrank(playerAddress);
        vm.deal(playerAddress, 69 ether);
        ethernaut = new Ethernaut();
        factory = new DexFactory();

        ethernaut.registerLevel(factory);
        dexInstance = ethernaut.createLevelInstance(factory);
        token1 = Dex(dexInstance).token1();
        token2 = Dex(dexInstance).token2();
        vm.stopPrank();
    }

    // test with withrawPartner set directly
    function testDexAttack() public {

        vm.startPrank(playerAddress, playerAddress);

        attacker.attack(dexInstance);
        uint myToken1Balance = SwappableToken(token1).balanceOf(playerAddress);
        SwappableToken(token1).approve(playerAddress, dexInstance, myToken1Balance);
        console.log("MY TOKEN1 BALANCE BEFORE:", myToken1Balance);
        Dex(dexInstance).swap(token1, token2, myToken1Balance);
        myToken1Balance = SwappableToken(token1).balanceOf(playerAddress);
        console.log("MY TOKEN1 BALANCE AFTER:", myToken1Balance);
        console.log("MY TOKEN1 PRICE AFTER:", Dex(dexInstance).getSwapPrice(token1, token2, 10));

        // // test to make sure we completed the level
        // vm.startPrank(playerAddress, playerAddress);
        // // submit level as player
        // bool levelComplete = ethernaut.submitLevelInstance(payable(dexInstance));
        // assert(levelComplete);
        // vm.stopPrank();
    }

}
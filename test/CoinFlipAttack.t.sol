// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

import { CoinFlip } from "src/CoinFlip/CoinFlip.sol";
import { CoinFlipAttack } from "src/CoinFlip/CoinFlipAttack.sol";
contract CoinFlipAttackTest is PRBTest, Cheats {
    uint256 public rinkeby;
    uint256 public local;
    CoinFlip public coinFlipTarget;
    CoinFlipAttack public coinFlipAttacker;

    function setUp() public {
        coinFlipTarget = new CoinFlip();
        coinFlipAttacker = new CoinFlipAttack();
        rinkeby = vm.createFork(vm.envString("ETH_RINKEBY_RPC_URL"));
        // local = vm.createFork(vm.envString("ETH_LOCAL_RPC_URL"));
    }

    function testCoinFlip() public {
        // vm.selectFork(rinkeby);
        uint blockNumber = block.number;
        // roll one block because the test reverts if we look for the 0th block in the coinFlip function
        vm.roll(blockNumber++);
        bool success;
        address coinFlipTargetAddress = address(coinFlipTarget);

        // loop through 10 blocks to meet the challenge requirement of 10 straight wins
        for (uint256 i = 0; i < 11; i++) {
            success = coinFlipAttacker.callCoinFlip(coinFlipTargetAddress);
            assert(success);
            assert(coinFlipTarget.consecutiveWins() == i + 1);
            vm.roll(blockNumber++);
        }

        assert(coinFlipTarget.consecutiveWins() >= 10);
    }
}

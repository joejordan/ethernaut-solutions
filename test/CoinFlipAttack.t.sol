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
        local = vm.createFork(vm.envString("ETH_LOCAL_RPC_URL"));
        
    }

    function testCoinFlip() public {
        vm.selectFork(rinkeby);
        // bool success = coinFlipAttacker.callCoinFlip();
        // console.log(success);
        uint blockNumber = block.number;
        console.logString("BLOCK NUMBER:::");
        console.log(block.number);
        vm.roll(++blockNumber);
        console.logString("BLOCK NUMBER:::");
        console.log(block.number);
    }
}

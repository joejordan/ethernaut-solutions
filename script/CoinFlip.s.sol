// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { CoinFlipAttack } from "../src/CoinFlip/CoinFlipAttack.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract CoinFlipScript is Script {
    CoinFlipAttack internal coinFlipAttacker;

    function run() public {
        vm.startBroadcast();
        coinFlipAttacker = new CoinFlipAttack();
        vm.stopBroadcast();
    }
}

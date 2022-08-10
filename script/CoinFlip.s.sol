// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { CoinFlip } from "../src/CoinFlip.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract CoinFlipScript is Script {
    CoinFlip internal coinFlip;

    function run() public {
        vm.startBroadcast();
        coinFlip = new CoinFlip();
        vm.stopBroadcast();
    }
}

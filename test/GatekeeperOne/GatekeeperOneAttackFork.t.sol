// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

import { GatekeeperOne } from "src/GatekeeperOne/GatekeeperOne.sol";

import { toBytes } from "src/utils/toBytes.sol";
import { bytes32ToString } from "src/utils/toString.sol";


contract PrivacyAttackForkTest is PRBTest {
    uint256 public rinkeby;
    address public gatekeeperInstance = address(0x536734cD63fb1E3b318eC09d7e0709737da436C0);

    function setUp() public {
        rinkeby = vm.createFork(vm.envString("ETH_RINKEBY_RPC_URL"));
    }

    function testForkGatekeeperOne() public {
        vm.selectFork(rinkeby);

        GatekeeperOne(gatekeeperInstance).enter(bytes8(toBytes(111)));
        // success = GatekeeperOne(gatekeeperInstance).locked() == false;
        // // assert that this is is the correct slot
        // assert(success);
    }

}
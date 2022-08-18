// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { Cheats } from "forge-std/cheats.sol";
import { console } from "forge-std/console.sol";

import { Vault } from "src/Vault/Vault.sol";
import { toBytes } from "src/utils/toBytes.sol";
import { bytes32ToString } from "src/utils/toString.sol";


contract VaultAttackTest is PRBTest, Cheats {
    Vault vault;
    string private secretPassword;

    function setUp() public {
        // just use the string literal twice so we can do a direct string comparison in the test
        secretPassword = "y0 dis is my pw";
        vault = new Vault(bytes32("y0 dis is my pw"));
    }

    function testGetPassword() public {
        bytes32 muhPasswordBytes = vm.load((address(vault)), bytes32(toBytes(1)));
        string memory muhPassword = bytes32ToString(muhPasswordBytes);
        console.logString(muhPassword);
        assertEq(secretPassword, muhPassword);
    }
}

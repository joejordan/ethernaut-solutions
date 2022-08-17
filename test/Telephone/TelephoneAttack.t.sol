// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";

import { Telephone } from "src/Telephone/Telephone.sol";
import { TelephoneAttack } from "src/Telephone/TelephoneAttack.sol";
contract TelephoneAttackTest is PRBTest, Cheats {
    Telephone telephoneTarget;
    TelephoneAttack telephoneAttack;

    function setUp() public {
        telephoneTarget = new Telephone();
        telephoneAttack = new TelephoneAttack();
    }

    function testTelephoneAttack() public {
        // stub
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";

import { Telephone } from "src/Telephone/Telephone.sol";
import { TelephoneAttack } from "src/Telephone/TelephoneAttack.sol";
import { TelephoneAttackLocal } from "src/Telephone/TelephoneAttackLocal.sol";

contract TelephoneAttackTest is PRBTest, Cheats {
    Telephone telephoneTarget;
    TelephoneAttack telephoneAttack;
    TelephoneAttackLocal telephoneAttackLocal;

    function setUp() public {
        telephoneTarget = new Telephone();
        telephoneAttack = new TelephoneAttack();
        telephoneAttackLocal = new TelephoneAttackLocal();
    }

    function testTelephoneAttack() public {
        console.logAddress(telephoneTarget.owner());
        telephoneAttack.telephonePwnd(address(0x69));
        console.logAddress(telephoneTarget.owner());
    }
    function testLocalTelephoneAttack() public {
        console.logAddress(telephoneTarget.owner());
        telephoneAttackLocal.telephonePwndLocal(telephoneTarget, address(0x69));
        console.logAddress(telephoneTarget.owner());
    }
}
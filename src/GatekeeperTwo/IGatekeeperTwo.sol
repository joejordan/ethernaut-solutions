// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}
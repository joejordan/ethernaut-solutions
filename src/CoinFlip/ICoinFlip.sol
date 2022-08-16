// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

contract CoinFlip {
    uint256 val;

    constructor() {
        val = 69;
    }

    function getVal() public view returns (uint256) {
        return val;
    }
}

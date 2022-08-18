// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;
    
// helper function to convert an uint to bytes
function toBytes(uint256 x) pure returns (bytes memory b) {
    b = new bytes(32);
    assembly {
        mstore(add(b, 32), x)
    }
}
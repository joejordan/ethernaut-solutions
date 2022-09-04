// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// 137 instructions(!)
contract Solver {
    function whatIsTheMeaningOfLife() external view returns (bytes32) {
        assembly {
            mstore(0, 42)
            return(0, 256)
        }
    }
}

// // 119 instructions
// contract Solver {
//     function whatIsTheMeaningOfLife() external view returns (bytes32) {
//         return bytes32(uint256(42));
//     }
// }

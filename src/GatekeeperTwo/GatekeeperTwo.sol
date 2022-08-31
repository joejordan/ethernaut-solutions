// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin, "FAILED GATE ONE");
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0, "FAILED GATE TWO");
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        unchecked {
            require(
                uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1,
                "FAILED GATE THREE"
            );
        }
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

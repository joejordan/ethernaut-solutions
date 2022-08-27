// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/utils/math/SafeMath.sol";
import { console } from "forge-std/console.sol";

contract GatekeeperOne {
    using SafeMath for uint256;
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin, "FAILED GATE ONE");
        _;
    }

    modifier gateTwo() {
        console.log(gasleft());
        require(gasleft().mod(8191) == 0, "FAILED GATE TWO");
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        console.logString("PART ONEEEEEEEEE");
        console.log(uint32(uint64(_gateKey)));
        console.log(uint16(uint64(_gateKey)));
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        console.log(gasleft());
        entrant = tx.origin;
        return true;
    }
}

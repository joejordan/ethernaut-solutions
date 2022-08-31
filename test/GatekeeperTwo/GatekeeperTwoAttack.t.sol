// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { GatekeeperTwo } from "src/GatekeeperTwo/GatekeeperTwo.sol";
import { GatekeeperTwoAttack } from "src/GatekeeperTwo/GatekeeperTwoAttack.sol";
import { GatekeeperTwoFactory } from "src/GatekeeperTwo/GatekeeperTwoFactory.sol";
contract GatekeeperTwoAttackTest is PRBTest {
    Ethernaut public ethernaut;
    GatekeeperTwoFactory public factory;
    GatekeeperTwoAttack public attacker;
    address public gatekeeperTwoInstance;
    address public playerAddress = address(0x696969);

    function setUp() public {
        vm.startPrank(playerAddress);
            ethernaut = new Ethernaut();
            factory = new GatekeeperTwoFactory();

            ethernaut.registerLevel(factory);
            gatekeeperTwoInstance = ethernaut.createLevelInstance(factory);
        vm.stopPrank();
    }

    function testGatekeeperTwoAttack() public {
        vm.startPrank(playerAddress);
            // constructor executes hack
            attacker = new GatekeeperTwoAttack(gatekeeperTwoInstance);
            // get entrant value
            address entrant = GatekeeperTwo(gatekeeperTwoInstance).entrant();
            // assert that entrant is not zero address
            console.logString("GATEKEEPERTWO ENTRANT:::");
            console.logAddress(entrant);
            assert(entrant != address(0));

            // submit level as player
            bool levelComplete = ethernaut.submitLevelInstance(payable(gatekeeperTwoInstance));
            // assert(levelComplete);
        vm.stopPrank();
    }

    // first attempt... can't pass gate 2 and gate 3 at the same time...
    // function testGatekeeperTwoAttack() public {
    //         // gateKey is defined as:
    //         bytes8 gateKey = bytes8(keccak256(abi.encodePacked(this))) ^ bytes8(type(uint64).max);

    //         uint64 result = uint64(bytes8(keccak256(abi.encodePacked(this)))) ^ uint64(gateKey);
    //         console.log(result);
    //         assert(result == type(uint64).max);

    //         GatekeeperTwo(gatekeeperTwoInstance).enter(gateKey);
    //         vm.startPrank(playerAddress);
    //             // get entrant value
    //             address entrant = GatekeeperTwo(gatekeeperTwoInstance).entrant();
    //             // assert that entrant is not zero address
    //             console.logString("GATEKEEPERTWO ENTRANT:::");
    //             console.logAddress(entrant);
    //             assert(entrant != address(0));

    //             // submit level as player
    //             bool levelComplete = ethernaut.submitLevelInstance(payable(gatekeeperTwoInstance));
    //             assert(levelComplete);
    //         vm.stopPrank();
    // }

    function testUnderflow() public {
        unchecked {
            console.log(uint64(0) - 1);
        }
    }

    function testGate3() public {

        bytes8 myAddressBytes = bytes8(keccak256(abi.encodePacked(this)));
        bytes8 gateKey = myAddressBytes ^ bytes8(0xffffffffffffffff);
        console.logBytes8(gateKey);

        uint64 myAddressUInt = uint64(bytes8(keccak256(abi.encodePacked(this))));
        gateKey = bytes8(myAddressUInt ^ uint64(0xffffffffffffffff));
        console.logBytes8(gateKey);

        gateKey = bytes8(keccak256(abi.encodePacked(this))) ^ bytes8(type(uint64).max);
        console.logBytes8(gateKey);

        uint64 result = uint64(bytes8(keccak256(abi.encodePacked(this)))) ^ uint64(gateKey);
        console.log(result);
        assert(result == type(uint64).max);

        

        // uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey)
        // console.logBytes(abi.encodePacked(msg.sender));
        // console.logBytes32(keccak256(abi.encodePacked(msg.sender)));
        // console.logUint(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))));

        // bytes8 myAddressBytes = bytes8(keccak256(abi.encodePacked(this)));
        // bytes8 gateKey = myAddressBytes ^ bytes8(0xffffffffffffffff);
        // console.log(gateKey);


        // for (uint256 i = 0; i < myAddressBytes.length; i++) {
        //     console.logBytes1(myAddressBytes[i] | bytes1(0xff));
        // }
        // bytes8 gateKey = bytes8(keccak256(abi.encodePacked(msg.sender))) ^

        // gate key applied to the uint64 conversion should result in the following number:
        // 18446744073709551615
        // console.log(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(0x0));

    }
}
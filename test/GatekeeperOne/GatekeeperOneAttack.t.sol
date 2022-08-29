// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { GatekeeperOneFactory } from "src/GatekeeperOne/GatekeeperOneFactory.sol";

import { GatekeeperOne } from "src/GatekeeperOne/GatekeeperOne.sol";
import { GatekeeperOneAttack } from "src/GatekeeperOne/GatekeeperOneAttack.sol";

import { bytes32ToString } from "src/utils/toString.sol";
import { toBytes } from "src/utils/toBytes.sol";

contract GatekeeperOneAttackTest is PRBTest {
    Ethernaut public ethernaut;
    GatekeeperOneFactory public factory;
    GatekeeperOneAttack public attacker;
    address gatekeeperOneInstance;
    address playerAddress = address(0x69);

    function setUp() public {
        vm.startPrank(playerAddress);
            ethernaut = new Ethernaut();
            factory = new GatekeeperOneFactory();
            attacker = new GatekeeperOneAttack();

            ethernaut.registerLevel(factory);
            gatekeeperOneInstance = ethernaut.createLevelInstance(factory);
        vm.stopPrank();
    }

    function testGatekeeperOneAttack() public {
        attacker.attack(gatekeeperOneInstance);
    }

    function testGatekeeperOneGasAttack() public {
        for (uint256 i = 90000; i < 100000; i++) {
            vm.expectRevert("FAILED GATE TWO");
            attacker.attack{gas: i}(gatekeeperOneInstance);
        }
    }

    function testByte() public {
        string memory a = "All About Solidityyyyyyyyyyyyyyy";
        bytes memory b = bytes(a);
        console.logString(a);
        console.logBytes(b);

        bytes memory c = new bytes(5);
        string memory d = string(c);
        console.logBytes(c);
        console.logString(d);

        // bytes memory data = new bytes(50);
        // bytes2 firstTwoBytes = bytes2(data);
        // console.logBytes(data);
        // console.logBytes2(firstTwoBytes);

        // bytes20 eff = 0xffffffffffffffffffffffeedddddeadfeedffff;
        // console.logBytes20(eff);

        // bytes4 a = 0xbeefbeef;
        // uint32 b = uint32(a);
        // console.logBytes4(a);
        // console.log(b);
        
        // bytes4 c = 0xbeefbeef;
        // uint32 d = c; // TypeError
        // console.logBytes4(c);
        // console.log(d);

        // bytes2 a = 0x1234;
        // bytes4 b = bytes4(a); // b = 0x12340000
        // console.logBytes2(a);
        // console.logBytes4(b);
        
        // uint32 a = 100000;
        // uint16 b = uint16(a); //b = a % 65536
        // uint8 c = uint8(a); //c = a % 256
        // console.log(a);
        // console.log(b);
        // console.log(c);

        // bytes memory gateKey = toBytes(uint160(address(0x536734cD63fb1E3b318eC09d7e0709737da436C0)));
        // // bytes8 gateKey = bytes8(toBytes(uint16(uint160(address(this)))));
        // console.logBytes8(gateKey);
        // console.log(uint32(uint64(gateKey)));
        // console.log(uint16(uint64(gateKey)));
        // address myaddr = address(0x0000000000000000dead);
        // console.log();
        // console.log(uint32(uint64(_gateKey)));
        // console.log(uint16(uint64(_gateKey)));
        // require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        // require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        // require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        
    }

}
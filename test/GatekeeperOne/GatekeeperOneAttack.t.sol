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
    address public gatekeeperOneInstance;
    address public playerAddress = address(0x696969);

    function setUp() public {
        vm.startPrank(playerAddress);
            ethernaut = new Ethernaut();
            factory = new GatekeeperOneFactory();
            attacker = new GatekeeperOneAttack();

            ethernaut.registerLevel(factory);
            gatekeeperOneInstance = ethernaut.createLevelInstance(factory);
            console.logAddress(gatekeeperOneInstance);
        vm.stopPrank();
    }

    function testGatekeeperOneAttack() public {
        vm.startPrank(playerAddress);
        console.logString("TEST TX ORIGIN");
        console.logAddress(tx.origin);
        // bytes8 gateKey = bytes8(uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF);

            // magic gas number discovered via brute force in fn below
            // GatekeeperOne(gatekeeperOneInstance).enter{gas: 24829}(gateKey);
            attacker.attack(gatekeeperOneInstance, 24829);
            // get entrant value
            address entrant = GatekeeperOne(gatekeeperOneInstance).entrant();
            // assert that entrant is not zero address
            console.logString("GATEKEEPERONE ENTRANT:::");
            console.logAddress(entrant);
            assert(entrant != address(0));

            // submit level as player
            bool levelComplete = ethernaut.submitLevelInstance(payable(gatekeeperOneInstance));
            // assert(levelComplete);
        vm.stopPrank();
    }

    function testGatekeeperOneGasAttack() public returns(uint) {
        vm.startPrank(playerAddress);
            (bool success, uint gasAmount) = attacker.gasAttack(gatekeeperOneInstance);
            assert(success);
            emit LogNamedUint256("GAS AMOUNT", gasAmount);
        vm.stopPrank();
        // uint gasBase = 8191 * 3; // gas needs to be a multiple of 8191. 3 is the lowest that will complete the tx
        // bytes8 gateKey = bytes8(uint64(uint160(msg.sender)) & 0xFFFFFFFF0000FFFF);

        // // Loop through a until correct gas is found, use try catch to get arounf the revert
        // for (uint muhgas = 0; muhgas <= 8191; muhgas++) {
        //     // try GatekeeperOne(gatekeeperOneInstance).enter{gas: gasBase + muhgas}(gateKey) {
        //     try attacker.gasAttack{gas: (muhgas + gasBase)}() {
        //         emit LogNamedUint256("Passed Gas", gasBase + muhgas);
        //         break;
        //     } catch {
        //         emit LogNamedUint256("Failed Gas", gasBase + muhgas);
        //     }
        // }
    }

    // re-familiarizing myself with casting and cropping of variables...
    // function testByte() public {
    //     // last two bytes of tx.origin
    //     // console.logAddress(tx.origin);
    //     // console.logBytes2(bytes2(uint16(uint160(tx.origin))));

    //     // bytes4 four = bytes4(uint32(0x12345678) & uint32(0x0000FFFF));
    //     // console.logBytes4(four);

    //     // string memory a = "All About Solidityyyyyyyyyyyyyyy";
    //     // bytes memory b = bytes(a);
    //     // console.logString(a);
    //     // console.logBytes(b);

    //     // bytes memory c = new bytes(5);
    //     // string memory d = string(c);
    //     // console.logBytes(c);
    //     // console.logString(d);

    //     // bytes memory data = new bytes(50);
    //     // bytes2 firstTwoBytes = bytes2(data);
    //     // console.logBytes(data);
    //     // console.logBytes2(firstTwoBytes);

    //     // bytes20 eff = 0xffffffffffffffffffffffeedddddeadfeedffff;
    //     // console.logBytes20(eff);

    //     // bytes4 a = 0xbeefbeef;
    //     // uint32 b = uint32(a);
    //     // console.logBytes4(a);
    //     // console.log(b);
        
    //     // bytes4 c = 0xbeefbeef;
    //     // uint32 d = c; // TypeError
    //     // console.logBytes4(c);
    //     // console.log(d);

    //     // bytes2 a = 0x1234;
    //     // bytes4 b = bytes4(a); // b = 0x12340000
    //     // console.logBytes2(a);
    //     // console.logBytes4(b);
        
    //     // uint32 a = 100000;
    //     // uint16 b = uint16(a); //b = a % 65536
    //     // uint8 c = uint8(a); //c = a % 256
    //     // console.log(a);
    //     // console.log(b);
    //     // console.log(c);

    //     // bytes memory gateKey = toBytes(uint160(address(0x536734cD63fb1E3b318eC09d7e0709737da436C0)));
    //     // // bytes8 gateKey = bytes8(toBytes(uint16(uint160(address(this)))));
    //     // console.logBytes8(gateKey);
    //     // console.log(uint32(uint64(gateKey)));
    //     // console.log(uint16(uint64(gateKey)));
    //     // address myaddr = address(0x0000000000000000dead);
    //     // console.log();
    //     // console.log(uint32(uint64(_gateKey)));
    //     // console.log(uint16(uint64(_gateKey)));        
    // }

}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

import { GatekeeperOne } from "src/GatekeeperOne/GatekeeperOne.sol";
import { GatekeeperOneAttack } from "src/GatekeeperOne/GatekeeperOneAttack.sol";

import { toBytes } from "src/utils/toBytes.sol";
import { bytes32ToString } from "src/utils/toString.sol";


contract GatekeeperOneAttackForkTest is PRBTest {
    uint256 public rinkeby;
    address public gatekeeperOneInstance = address(0x536734cD63fb1E3b318eC09d7e0709737da436C0);
    GatekeeperOneAttack attacker;
    address public playerAddress = address(0x696969696969);

    function setUp() public {
        rinkeby = vm.createSelectFork(vm.envString("ETH_RINKEBY_RPC_URL"), 11_289_580);
        attacker = new GatekeeperOneAttack();
    }

    function testForkAttack() public {
        vm.startPrank(playerAddress);
            bool success = attacker.attack(gatekeeperOneInstance, 24827);
            assert(success);
        vm.stopPrank();
        address entrant = GatekeeperOne(gatekeeperOneInstance).entrant();
        // assert that entrant is not zero address
        assert(entrant != address(0));
    }

    function testForkRealGasAttack() public {
        vm.startPrank(playerAddress);
            (bool success, uint gasAmount) = attacker.gasAttack(gatekeeperOneInstance);
            assert(success);
            emit LogNamedUint256("GAS AMOUNT", gasAmount);
        vm.stopPrank();
        address entrant = GatekeeperOne(gatekeeperOneInstance).entrant();
        // assert that entrant is not zero address
        assert(entrant != address(0));
    }

    function testForkGasAttack() public {
        uint gasBase = 8191 * 3; // gas needs to be a multiple of 8191. 3 is the lowest that will complete the tx
        bytes8 gateKey = bytes8(uint64(uint160(msg.sender)) & 0xFFFFFFFF0000FFFF);

        vm.startPrank(playerAddress);
        for (uint muhgas = 0; muhgas <= 8191; muhgas++) {
            try GatekeeperOne(gatekeeperOneInstance).enter{gas: gasBase + muhgas}(gateKey) {
                emit LogNamedUint256("Passed Gas", gasBase + muhgas);
                break;
            } catch {
                emit LogNamedUint256("Failed Gas", gasBase + muhgas);
            }
        }
    }

}
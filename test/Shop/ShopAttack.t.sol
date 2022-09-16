// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";
import { Shop } from "src/Shop/Shop.sol";
import { ShopFactory } from "src/Shop/ShopFactory.sol";
import { ShopAttack } from "src/Shop/ShopAttack.sol";

contract ShopAttackTest is PRBTest {
    Ethernaut public ethernaut;
    ShopFactory public factory;
    address public shopInstance;
    address public playerAddress = address(0x696969);

    ShopAttack attacker = new ShopAttack();

    function setUp() public {
        vm.startPrank(playerAddress);
        vm.deal(playerAddress, 69 ether);
        ethernaut = new Ethernaut();
        factory = new ShopFactory();

        ethernaut.registerLevel(factory);
        shopInstance = ethernaut.createLevelInstance(factory);
        vm.stopPrank();
    }

    // test with withrawPartner set directly
    function testShopAttack() public {

        attacker.attack(shopInstance);

        // test to make sure we completed the level
        vm.startPrank(playerAddress, playerAddress);
        // submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(shopInstance));
        assert(levelComplete);
        vm.stopPrank();
    }

}
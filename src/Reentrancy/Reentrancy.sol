// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/utils/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;
    mapping(address => uint256) public balances;

    event Donate(address indexed toAddress, uint indexed amount);
    event Withdraw(address indexed withdrawAddress, uint indexed amount);

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
        emit Donate(_to, msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{ value: _amount }("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
            emit Withdraw(msg.sender, _amount);
        }
    }

    receive() external payable {}
}

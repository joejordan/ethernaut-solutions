// SPDX-License-Identifier: MIT

// https://github.com/OpenZeppelin/ethernaut/blob/master/contracts/contracts/levels/base/Level.sol

pragma solidity ^0.8.15;

import { Ownable } from "@openzeppelin/access/Ownable.sol";

abstract contract Level is Ownable {
    function createInstance(address _player) public payable virtual returns (address);

    function validateInstance(address payable _instance, address _player) public virtual returns (bool);
}

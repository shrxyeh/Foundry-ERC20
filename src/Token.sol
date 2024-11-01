// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("SHRXYEH", "SH") {
        _mint(msg.sender, initialSupply);
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        uint256 currentAllowance = allowance(msg.sender, spender);
        _approve(msg.sender, spender, currentAllowance + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public returns (bool) {
        uint256 currentAllowance = allowance(msg.sender, spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );

        _approve(msg.sender, spender, currentAllowance - subtractedValue);
        return true;
    }
}

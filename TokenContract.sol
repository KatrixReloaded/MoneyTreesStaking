// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract POSToken is ERC20, Ownable {
    event Stake(address indexed staker, uint256 value); // Added the Stake event definition

    constructor(uint initialSupply) ERC20("MoneyTrees", "MTM") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10 ** uint256(decimals()));
    }

    function stake(uint256 value) public onlyOwner {
        require(value > 0, "Stake value must be greater than 0");
        _transfer(msg.sender, address(this), value);
        emit Stake(msg.sender, value);
    }

    function unstake(uint256 value) public onlyOwner {
        require(balanceOf(address(this)) >= value, "Insufficient staked tokens");
        _transfer(address(this), msg.sender, value);
    }
}

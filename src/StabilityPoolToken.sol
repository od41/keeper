// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract StabilityPoolToken {
    string public name;
    string public symbol;
    uint8 public decimals;

    mapping(address => uint256) public balanceOf;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        // Ensure sender has enough balance to transfer
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        // Transfer stablecoins from sender to recipient
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

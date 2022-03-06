// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

contract Token {
    string public name = "My Hardhat Token";
    string public symbol = "DL";
    uint256 public totalSupply = 52000000;

    address public owner;

    mapping(address => uint256) balance;

    // 构造函数
    constructor() {
        balance[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    // 代币转账
    function transfer(address to,uint256 amount) external{
        console.log("Sender balance is %s tokens", balance[msg.sender]);
        console.log("Trying to send %s tokens to %s", amount, to);

        require(balance[msg.sender] >= amount,"Not enough tokens");

        balance[msg.sender] -= amount;
        balance[to] +=amount;
    }

    // 获取代币余额
    function balanceOf(address account) external view returns (uint256) {
        return balance[account];
    }
}

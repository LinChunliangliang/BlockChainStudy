// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;


contract Bank {
    /*
    需求分析：
    银行角色（可存钱，也可取钱）
    用户角色（往银行里存入余额，也可以向银行里取出自己所存取的金额，查看余额）
    */


    // 用于保存当前合约接收到ETH
    address payable public selfContract;
    
    // 用于记录每个地址转账金额
    mapping (address => uint) public balances;

    // 表示可接收ETH的合约
    constructor () payable {
        selfContract = payable(msg.sender);
    }


    // 查看当前合约余额
    function getSelfConBalance() public view returns (uint){
        address solAddress = address (this);
        return solAddress.balance;
    }

    //每个地址向当前合约地址存入ETH
    receive()  external payable {
        // address solAddress = address (this);
        // 用户向当前Bank存入金额
        // solAddress.balance += msg.value;
        //selfContract.transfer(msg.value);
        // 记入当前存入金额到当前对应用户
        balances[msg.sender] += msg.value;

    }

    fallback() external payable {
      balances[msg.sender] += msg.value;
    }

    //每个地址都可以把自己存入的ETH从当前合约中取走
    function userWithdraw(address payable receiver, uint amount) public {
        require(amount <= balances[msg.sender],"false Withdraw");
        // 记录减去
        balances[msg.sender] -=amount;
        // 转到当前提取用户下
        (bool success, ) = receiver.call{value: amount}("");
        require(success, "Failed to send Ether");
        // receiver.transfer(amount);
    }

    //每个地址都可以查看，当前地址在此Bank中存的余额
    //function balances(address _account) public view returns (uint) {
      //  return balances[_account];
    //}

    // 提取地址所有的ETH到x地址
    function withdraw(address payable x) public{
        // 合约地址
        address solAddress = address (this);
        if(solAddress.balance >0){
            // 提取所有的金额
            x.transfer(solAddress.balance);
            //selfContract.call{value: solAddress.balance}(x);
        }

       
    }

    function withdrawAll() public{
        uint amount = address(this).balance;

        (bool success, ) = selfContract.call{value: amount}("");
        require(success, "Failed to send Ether");
    }


}

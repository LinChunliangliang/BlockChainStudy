//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// 学生成绩合约
contract Score{
    // 记录学生成绩
    address public teacher;
    mapping (address => uint) StudentScore;


    modifier onlyTeacher(){
        console.log(msg.sender);
        require(msg.sender == teacher,"Don't Change Score");
        _;
    }

    function addTeacher(address _address) public{
        teacher = _address;
    }

    // external只允许外部调用
    function IScore(address _account,uint _score) external onlyTeacher{
        console.log(msg.sender);
        require(_score <= 100,"Score more then 100");
        StudentScore[_account] = _score;
    }

    function getStudentScore(address _address) public view returns (uint){
        return StudentScore[_address];
    }
}

interface IScoreService{
    function IScore(address _account,uint _score) external;
    
}

// 老师合约
contract Teacher{
    // 定义老师地址
    address public selfAddress;

    // IScoreService score;

    constructor() payable{
        selfAddress = address(this);
    }
    
    function changeScore(address _address,uint _score) public {
        console.log(_address);
        // score.IScore(_address, _score);
        IScoreService(_address).IScore(_address, _score);
    }

}
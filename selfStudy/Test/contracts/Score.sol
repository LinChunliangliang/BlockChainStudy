//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Student
contract Score{
    address public teacher;
    mapping (address => uint) StudentScore;


    modifier onlyTeacher(){
        require(msg.sender == teacher,"Don't Change Score");
        _;
    }

    function addTeacher(address _address) public{
        teacher = _address;
    }

    // external
    function IScore(address _account,uint _score) public onlyTeacher{
        require(_score <= 100,"Score more then 100");
        StudentScore[_account] = _score;
    }

    function getStudentScore(address _address) public view returns (uint){
        return StudentScore[_address];
    }
}

interface IScoreService{
    function IScore(address _account, uint _score) external;
}

// Teacher 
contract Teacher{
    address public selfAddress;

    IScoreService public score;

    constructor(){
        selfAddress = address(this);
    }
    
    function changeScore(address _account, uint _score) public {
        score.IScore(_account, _score);
    }

}
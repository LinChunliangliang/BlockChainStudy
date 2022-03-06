// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// 委托投票
contract Ballot {
    // 声明了一个新的复合类型用于稍后的变量
    // 表示一个选民

    struct Voter {
        uint weight; // 计票的权重
        bool voted;  // 若为真，代表该人已投票
        address delegate; // 被委托人
        uint vote; // 投票提案的索引
    }

    // 提案的类型

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public chairperson;

    // 声明了一个状态变量，为每个可能的地址存储一个'Voter'
    mapping(address => Voter) public voters;

    // 一个'Proposal'结构类型的动态数组
    Proposal[] public proposals;

    // 为'proposalNames'中的每个提案，创建一个新的（投票）表决
    constructor(bytes32 memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight=1;
        // 对于提供的每个提案名称，
        //创建一个新的Proposal对象并把它添加到数组的末尾/
        for(uint i=0;i<proposalNames.length;i++){
            proposals.push(Proposal({
                name:proposalNames[i],
                voteCount:0
            }));
        }
    }

    // 授权`voter`对这个投票表决进行投票
    // 只有chairperson 可以调用该函数
    function giveRightToVote(address voter) public {
        /*
        若require的第一个参数的计算结果为false
        则终止执行，撤销所有对状态和以太余额的改动
        在旧版的EVM中这曾经会消耗所有gas，但现在不会了
        */

        require(
            msg.sender ==chairperson,
            "Only chairperson can give right to vote."
        );

        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;

    }

    // 把你的投票委托到投票者
    function delegate(address to) public{
        // 传引用
        Voter storage sender = voters[msg.sender];

        require(!sender.voted,"You already voted");
        require(to != msg.sender,"Self-delegation is disallowed");

        // 委托是可以传递，只有被委托者to也设置了委托
        // 一般来说，这种循环委托是危险的，因为，如果传递的链条太长，则可能需消耗的gas要多余区块中剩余的（大于区块设置的gasLimit）
        // 大于gasLimit，委托不会被执行
        // 而在另一些情况夏，如果形成闭环，则会让合约完全卡住

        while(voters[to].delegate != address[0]){
            to = voters[to].delegate;
            // 不允许闭环委托
            require(to != msg.sender,"Found loop in delegation");
        }

        // sender 是一个引用，相当于对voters[msg.sender].voted进行修改
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[0];

        if(delegate_.voted){
            // 若被委托这已经投过票了，直接增加得票数
            proposals[delegate_.voted].voteCount += sender.weight;
        }else{
            // 若被委托者还没投票，增加委托者的权重
            delegate_.weight += sender.weight;
        }
    }

    // 把你的投票（包括委托给你的票）
    // 投给提案`proposals[proposal].name`
    function vote(uint proposal) public{
        Voter storage sender = voters[msg.sender];
        require(!sender.voted,"Already voted");
        sender.voted = true;
        sender.vote = proposal;

        // 如果proposal 超过了数组的范围，则会自动抛出异常，并恢复所有的改动
        proposals[proposal].voteCount += sender.weight;
    }

    // @dev 结合之前所有的投票，计算出最终胜出的提案
    function winningProposal() public view returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // 调用winningProposal() 函数以获取提案数组中获胜者的索引，并以此返回获胜者的名称
    function winningName() public view returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;

    }
}
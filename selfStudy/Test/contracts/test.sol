// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract test {
    // 获取时间戳
    function getTime() public view returns (uint){
        return block.timestamp;
    }

    function getChainId() public view returns(uint){
        return block.chainid;
    }

}
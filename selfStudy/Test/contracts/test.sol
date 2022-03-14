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

contract createTest {
    function createContract3(uint _salt) public returns (address) {
        test t = new test{salt: keccak256(abi.encode(_salt))}();
        return address(t);
    }

    // 预测合约地址
    function getAddress(uint _salt) public view returns (address) {
        bytes memory bytecode = type(test).creationCode;
        //  if constructor
        // bytecode = abi.encodePacked(bytecode, abi.encode(x));

        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), keccak256(abi.encode(_salt)), keccak256(bytecode))
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }
}
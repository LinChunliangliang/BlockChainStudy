// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

contract Counter {

    uint public Number;

    constructor(uint num) {
        Number = num;
        console.log("Deploying Counter>>> action: constructor, Number:",Number);
    }

    // Add Number
    function add(uint num) public {

        Number = Number + num;
        console.log("Deploying Counter>>> action: add, Number:",Number);
    }

    //get Number
    function get() public view returns (uint) {
        console.log("Deploying Counter>>> action: get, Number:",Number);
        return Number;
    }


}

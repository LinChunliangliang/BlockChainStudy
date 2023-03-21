// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Counter {

    uint public Number;

    constructor() {
        Number = 0;
    }


    // Add
    function add(uint num) public {
        Number = Number + num;
    }
    //
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Counter {
    uint public Numebr;
    constructor(uint num) {
        Numebr = num;
    }

    function add(uint num) public {
        Numebr = Numebr + num;
    }

}
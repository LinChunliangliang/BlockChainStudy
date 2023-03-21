const { artifacts } = require("hardhat");

var Counter = artifacts.require("Counter");

module.exports = async function(callback){
    var counter =await Counter.deployed()

    console.log(counter)
}
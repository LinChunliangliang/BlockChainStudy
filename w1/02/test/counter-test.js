const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Counter", function () {
    it('Test Counter ', async function () {

        const Counter = await ethers.getContractFactory("Counter");

        const counter = await Counter.deploy(10);

        await counter.deployed();

        expect(await counter.get()).to.equal(10);

        const addCounterNum = await counter.add(11);

        await addCounterNum.wait();

        expect(await counter.get()).to.equal(21);

    });
})
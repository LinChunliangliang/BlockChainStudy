const { expect } = require("chai")

const { ethers } = require("hardhat");

describe("Token contract",function () {
    it('Deployment should assign the total supply of tokens to owner', async function () {
        // 获取账号
        const [owner, second, three] = await ethers.getSigners();
        // 获取合约
        const Token = await ethers.getContractFactory("Token");

        const token = await Token.deploy();

        await token.transfer(second.address,10);
        expect(await token.balanceOf(second.address)).to.equal(10);



        await token.connect(second).transfer(three.address,5);
        expect(await token.balanceOf(three.address)).to.equal(5);

       /* const ownerBalance = await token.balanceOf(owner.address);

        expect(await token.totalSupply()).to.equal(ownerBalance)*/

    });
})


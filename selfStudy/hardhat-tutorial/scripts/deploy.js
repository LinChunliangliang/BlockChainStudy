
const { expect } = require("chai")

const { ethers } = require("hardhat");

async function main() {
    console.log(21)
    const [deployer] =await ethers.getSigners();


    console.log("Deployed contracts with the account:",deployer.address);

    console.log("Account balance:",(await deployer.getBalance()).toString());

    const Token =await ethers.getContractFactory("Token");

    const token = await Token.deploy();

    console.log("Token address",token.address);

}

main()
    .then(()=>process.exit(0))
    .catch(error=>{
    console.log(error)
    process.exit(1);
})
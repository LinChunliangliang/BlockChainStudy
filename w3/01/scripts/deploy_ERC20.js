const {hre, network} = require("hardhat");
const {witeAddr} = require('./artifact_log');

/**
 * It deploys a new ERC20 token contract.
 */
async function main(){
    const MyERC20 = await hre.ethers.getContractFactory("MYERC20");
    const token = await MyERC20.deploy();

    await token.deployed();

    console.log("ERC20 Token deployed to:",token.address);
    await witeAddr(token.address,"MyERC20",network.name)

}

main()
.then(()=>process(0))
.catch(error=>{
    console.log(error);
    process.exit(1);
})
const { task } = require("hardhat/config");

require("@nomicfoundation/hardhat-toolbox");

task("accounts","Prints the list of accounts",async() => {
  const accounts = await ethers.getSigners();

  for(const account of accounts){
    console.log(account.address);
  }
});


const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  // solodity 版本
  solidity: "0.8.9",
  // 默认网络
  defaultNetwork:"hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      gas:"auto",
      gasPrice:"auto",
      gasMultiplier:1,


    },
    oktest: {
      url:'https://exchaintestrpc.okex.org',
      accounts: [mnemonic],
      gas:"auto",
      gasPrice:"auto",
      timeout:2000
    }
  }
};

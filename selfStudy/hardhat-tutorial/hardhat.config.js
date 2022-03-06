/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require("@nomiclabs/hardhat-waffle")

const ALCHEMY_API_KEY = "";

const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  solidity: "0.7.3",
  networks: {
    oktest: {
      url:'https://exchaintestrpc.okex.org',
      accounts: [mnemonic]
      // chainId:10,
      // gas:9500000,
      // gasPrice:8000000000

    }
  }
};

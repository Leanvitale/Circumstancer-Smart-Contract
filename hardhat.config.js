require('dotenv').config();
require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');
require('hardhat-contract-sizer');

const { ACCOUNT, INFURA_URL_RINKEBY, INFURA_URL_MAINNET, ETHERSCAN_API_KEY } = process.env;

module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: INFURA_URL_RINKEBY,
      accounts: [ ACCOUNT ]
    },
    mainnet: {
      url: INFURA_URL_MAINNET,
      accounts: [ ACCOUNT ]
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY
  }
};

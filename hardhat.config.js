require('dotenv').config()
require('@nomiclabs/hardhat-waffle')
require('@nomiclabs/hardhat-etherscan')
require('hardhat-contract-sizer')

const { ACCOUNT, ALCHEMY_URL_SEPOLIA, ALCHEMY_URL_MAINNET, ETHERSCAN_API_KEY } = process.env

module.exports = {
    solidity: '0.8.4',
    networks: {
        sepolia: {
            url: ALCHEMY_URL_SEPOLIA,
            accounts: [ACCOUNT],
        },
        mainnet: {
            url: ALCHEMY_URL_MAINNET,
            accounts: [ACCOUNT],
        },
    },
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
}

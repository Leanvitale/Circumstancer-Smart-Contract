require("@nomiclabs/hardhat-waffle");


module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: 'https://rinkeby.infura.io/v3/04c5f668df7042389f13c050fce1852f',
      accounts: [
        process.env.OWNER_ACCOUNT
      ]
    }
  }
};

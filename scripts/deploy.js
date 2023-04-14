const { ethers } = require('hardhat')

const deploy = async () => {
    const [deployer] = await ethers.getSigners()
    const baseURI = 'https://color-sale.s3.amazonaws.com/'

    console.log('Deploying contract with the account: ', deployer.address)

    const ColorSale = await ethers.getContractFactory('ColorSale')
    const deployed = await ColorSale.deploy(baseURI)

    console.log('ColorSale is deployed at: ', deployed.address)
}

deploy()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error)
        process.exit(1)
    })

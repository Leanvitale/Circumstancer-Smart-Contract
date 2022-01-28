const { ethers } = require("hardhat");

const deploy = async () => {
    const [deployer] = await ethers.getSigners();
    const mainAddress = '0x21D964B8d17fd2cD8B610469E8B569337746dCfB';
    const baseURI = 'ipfs://QmVC35ENKbwA2DiQLeKcbcivVebGmh8MnQPj2EJF3WtKYM/';

    console.log("Deploying contract with the account: ", deployer.address);

    const Circumstancer = await ethers.getContractFactory("Circumstancer")
    const deployed = await Circumstancer.deploy(mainAddress, baseURI);

    console.log("Circumstancer is deployed at: ", deployed.address);
}

deploy().then(() => process.exit(0)).catch(error => {
    console.log(error);
    process.exit(1);
})
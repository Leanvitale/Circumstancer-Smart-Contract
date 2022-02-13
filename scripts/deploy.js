const { ethers } = require("hardhat");

const deploy = async () => {
    const [deployer] = await ethers.getSigners();
    const baseURI = 'ipfs://QmdPoPzj1kZfVT2hQj8G2NNPKDsWpUZvefAfazGcnBfd4Y/';

    console.log("Deploying contract with the account: ", deployer.address);

    const Circumstancer = await ethers.getContractFactory("Circumstancer")
    const deployed = await Circumstancer.deploy(baseURI);

    console.log("Circumstancer is deployed at: ", deployed.address);
}

deploy().then(() => process.exit(0)).catch(error => {
    console.log(error);
    process.exit(1);
})
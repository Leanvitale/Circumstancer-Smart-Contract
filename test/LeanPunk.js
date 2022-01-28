const { expect } = require('chai');
const { ethers } = require("hardhat");

describe('Lean Punk Contract', () => {
    const setup = async ({ maxSupply = 10000 }) => {
        const [owner] = await ethers.getSigners();
        const LeanPunks = await ethers.getContractFactory("LeanPunks")
        const deployed = await LeanPunks.deploy(maxSupply);

        return {
            owner,
            deployed
        }
    }
    
    describe('Deployment', () => {
        it('Set Max Supply to passed param', async () => {
            const maxSupply = 4000;

            const { deployed } = await setup({maxSupply});

            const returnedMaxSupply = await deployed.maxSupply();
            expect(maxSupply).to.equal(returnedMaxSupply);
        })
    });

    describe('Minting', () => {
        it('Mints a new token and assign it to owner', async () => {
            const { owner, deployed } = await setup({});
            
            await deployed.mint();

            const ownerOfMinted = await deployed.ownerOf(0);
            expect(ownerOfMinted).to.equal(owner.address);
        })

        it('Has a minting limit', async () => {
            const maxSupply = 30;

            const { deployed } = await setup({ maxSupply });

            deployed.mint()

            await expect(deployed.mint()).to.be.revertedWith("Not LeanPunk left :(");
        })
    })

    describe("TokenURI", () => {
        it('return valid metadata', async () => {
            const { deployed } = await setup({});

            await deployed.mint();
            const tokenURI = await  deployed.tokenURI(0);
            const stringifiedTokenURI = await tokenURI.toString();
            const [, base64JSON] = stringifiedTokenURI.split(
                "data:application/json;base64,"
            )
            const stringifiedMetadata = await Buffer.from(base64JSON, "base64").toString("ascii");

            const metadata = JSON.parse(stringifiedMetadata);
            expect(metadata).to.have.all.keys("name", "description", "image");
        })
    })
})
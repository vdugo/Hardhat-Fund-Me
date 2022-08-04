const { deployments, ethers } = require('hardhat')
const { assert, expect } = require('chai')

describe("FundMe", async () =>
{
    let fundMe
    let deployer
    let MockV3Aggregator
    const sendValue = ethers.utils.parseEther("1") // 1 ETH
    beforeEach(async () =>
    {
        deployer = (await ethers.getSigners())[0].address
        await deployments.fixture(["all"])
        fundMe = await ethers.getContract("FundMe", deployer)
        mockV3Aggregator = await ethers.getContract("MockV3Aggregator", deployer)
    })

    describe("Constructor", async () => 
    {
        it("sets the aggregator address correctly", async () =>
        {
            const response = await fundMe.priceFeed()
            assert.equal(response, mockV3Aggregator.address)
        })
    })

    describe("fund", async () =>
    {
        it("Fails if you don't send enough ETH", async () =>
        {
            await expect(fundMe.fund()).to.be.reverted
        })
        it("Updates the amount funded data structure", async () =>
        {
            await fundMe.fund({ value: sendValue })
            const response = await fundMe.addressToAmountFunded(deployer)
            assert.equal(response.toString(), sendValue.toString())
        })
    })
})
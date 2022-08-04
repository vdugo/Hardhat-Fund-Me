const { networkConfig, developmentChains } = require('../helper-hardhat-config')
const { network } = require('hardhat')
const { verify } = require('../utils/verify')
require('dotenv').config()

module.exports = async ({ getNamedAccounts, deployments }) =>
{
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let ethUsdPriceFeedAddress

    if (developmentChains.includes(network.name))
    {
        const ethUsdAggregator = await get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    }
    else
    {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }

    const args = [ethUsdPriceFeedAddress]
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args,
        log: true
    })
    log("FundMe deployed")
    // if we're not on development chains, then automatically verify the code on Etherscan
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY)
    {
        await verify(fundMe.address, args)
    }
    log("---------------------------------------------------")
}

module.exports.tags = ["all", "fundme"]

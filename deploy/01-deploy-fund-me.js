const { networkConfig, developmentChains } = require('../helper-hardhat-config')
const { network } = require('hardhat')

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

    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [ethUsdPriceFeedAddress],
        log: true
    })
    log("FundMe deployed")
    log("---------------------------------------------------")
}

module.exports.tags = ["all", "fundme"]

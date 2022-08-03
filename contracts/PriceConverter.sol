// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter
{
    function getPrice() internal view returns (uint256)
    {
        // instance of us interacting with a contract outside of our contract
        // ABI
        // address of contract
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        (, int price, , , ) = priceFeed.latestRoundData();
        // 1700.00000000 (8 decimal places)
        // convert to 18 decimal places and to a uint256
        return uint256(price * 1e10); // 1 * 10^10
    }

    function getVersion() internal view returns(uint256)
    {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256)
    {
        uint256 ethPrice = getPrice();
        // Always multiply before you divide
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
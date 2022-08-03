// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter
{
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256)
    {
        (, int price, , , ) = priceFeed.latestRoundData();
        // 1700.00000000 (8 decimal places)
        // convert to 18 decimal places and to a uint256
        return uint256(price * 1e10); // 1 * 10^10
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns(uint256)
    {
        uint256 ethPrice = getPrice(priceFeed);
        // Always multiply before you divide
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
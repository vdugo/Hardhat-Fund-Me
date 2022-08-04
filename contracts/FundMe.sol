// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe
{
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    AggregatorV3Interface public priceFeed;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable owner;

    constructor(address priceFeedAddress)
    {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable
    {
        // We want to be able to set a minimum fund amount in USD
        // how do we send ETH to this contract?
        // 1e18 is 1 * 10^18 wei
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "Didn't send enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner
    {

        for (uint funderIndex = 0; funderIndex < funders.length; ++funderIndex)
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // reset the array
        funders = new address[](0);

        // withdraw the funds
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner
    {
        // require(msg.sender == owner, "Sender is not owner!");
        // more gas efficient
        if (msg.sender != owner)
        {
            revert FundMe__NotOwner();
        }
        _;
    }
}
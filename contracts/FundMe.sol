// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe
{
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable owner;

    constructor()
    {
        owner = msg.sender;
    }

    function fund() public payable
    {
        // We want to be able to set a minimum fund amount in USD
        // how do we send ETH to this contract?
        // 1e18 is 1 * 10^18 wei
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough");
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
            revert NotOwner();
        }
        _;
    }

    receive() external payable
    {
        fund();
    }
    fallback() external payable
    {
        fund();
    }
}
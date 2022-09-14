// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./IVault.sol";
import "./Shirtless.sol";
import "@openzeppelin/interfaces/IERC1155.sol";
import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/finance/PaymentSplitter.sol";
import "@openzeppelin/utils/Counters.sol";
import "@openzeppelin/utils/Address.sol";
import "@forge-std/console.sol";

contract Dao is Ownable {
    using Address for address;
    using Counters for Counters.Counter;

    Shirtless collection;
    IVault[] vaults;
    PaymentSplitter mintSplitter;
    uint256 price = 1 ether;
    uint256 totalSupply = 100; // TODO Should total supply be mutable ?
    Counters.Counter mintId;


    //TODO: Antoine. constructor with address for mintSplitter and check other things
    function setCollection(address collectionAddress) public onlyOwner {
        collection = Shirtless(collectionAddress);
    }

		//TODO contract type vs address ?
    function setMintSplitter(PaymentSplitter splitter) public onlyOwner {
			// TODO require nonZero ? It would break the tests
        mintSplitter = PaymentSplitter(splitter);
    }

    function setPrice(uint256 newPrice) public onlyOwner {
        require(newPrice > 0);
        price = newPrice;
    }

    function claimAllRewards() public {
        for (uint256 index = 0; index < vaults.length; index++) {
            vaults[index].claim(address(this));
        }
    }

    function mint() public payable {
        //TODO replace with revert and custom error
        require(address(mintSplitter).isContract(), "Splitter is not set correctly"); // TODO is it safe to use isContract? Check openzeppeliln
        require(mintId.current() < totalSupply, "Can't mint more NFTs than max supply");
        require(msg.value == price, "Value sent in tx does not match mint price");

        collection.mint(msg.sender, mintId.current(), 1, "");
        mintId.increment();
    }

    function burn(uint id) public {
    }

    // TODO find a way to distrubte the revenues owned by this address:
    // Check on the group for a possible example of an implementation
}

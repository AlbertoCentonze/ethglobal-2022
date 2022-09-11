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

error SetUpError();

contract Dao is Ownable {
	using Address for address;
	using Counters for Counters.Counter;

	Shirtless collection;
	IVault[] vaults;
	PaymentSplitter mintSplitter;
	uint256 price = 1 ether;
	Counters.Counter mintId;

	function setCollection(address collectionAddress) onlyOwner public {
		collection = Shirtless(collectionAddress);
	}

	function setMintSplitter(address payable splitter) onlyOwner public { //TODO payable? why?
		mintSplitter = PaymentSplitter(splitter);
	}

	function setPrice(uint256 newPrice) onlyOwner public {
		require(newPrice > 0); // TODO require or revert ? that is the question
		price = newPrice;
	}

	function claimAllRewards() public {
		for (uint256 index = 0; index < vaults.length; index++) {
			vaults[index].claim();
		}
	}

	function mint() public payable {
		console.log("HERE");
		if (!address(mintSplitter).isContract())  // TODO is it safe to use isContract? Check openzeppeliln
			revert SetUpError();

		require(msg.value == price);

		collection.mint(msg.sender, mintId.current(), 1, "");
		mintId.increment();
	}
	
	// TODO find a way to distrubte the revenues owned by this address:
	// - currently discussing on the superfluid discord to find a way to 
	// do this with IDAs
}
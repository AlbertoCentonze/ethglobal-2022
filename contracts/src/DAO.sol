// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./IVault.sol";
import "@openzeppelin/interfaces/IERC1155.sol";
import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/finance/PaymentSplitter.sol";

contract Dao is Ownable {
	IERC1155 collection;
	IVault[] public vaults;
	PaymentSplitter public mintSplitter;

	function setCollection(address collectionAddress) onlyOwner public {
		collection = IERC1155(collectionAddress);
	}

	function setMintSplitter(address payable splitter) onlyOwner public { //TODO payable? what?
		mintSplitter = PaymentSplitter(splitter);
	}

	function claimAllRewards() public {
		for (uint256 index = 0; index < vaults.length; index++) {
			vaults[index].claim();
		}
	}

	function mint() public payable {

	}
	
	// TODO find a way to distrubte the revenues owned by this address:
	// - currently discussing on the superfluid discord to find a way to 
	// do this with IDAs
}
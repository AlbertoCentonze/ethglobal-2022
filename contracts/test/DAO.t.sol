// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import "../src/Shirtless.sol";
import "../src/DAO.sol";
import "@openzeppelin/finance/PaymentSplitter.sol";

contract DaoTest is Test {
	address DEV_FUND = address(42);
	address[] payees = [DEV_FUND];
	uint256[] shares = [9, 1];

	Dao dao;
	Shirtless collection;

	function setUp() public {
		// Deploy the DAO contract
		dao = new Dao();
		// Deploy the NFT collection
		collection = new Shirtless();

		collection.transferOwnership(address(dao));
		dao.setCollection(address(collection));

		setUpSplitter();
	}

	function setUpSplitter() public {
		payees = [DEV_FUND, address(dao)]; // Solidity sucks
		dao.setMintSplitter(payable(address(new PaymentSplitter(payees, shares))));
	}

	function testFailMintWithoutSplitter() public {
		dao.mint();
	}

	function testFailMintWithNotEnoughMoney() public {
		dao.mint{value: 0.5 ether}();
	}

	function testFailMintWithTooMuchMoney() public {
		dao.mint{value: 1.5 ether}();
	}

	function testMintWithIncreasingId() public {
		address RANDOM = address(43);
		vm.startPrank(RANDOM);
		dao.mint{value: 1 ether}();
		console.log(collection.balanceOf(RANDOM, 0));
		console.log(collection.balanceOf(RANDOM, 1));
		dao.mint{value: 1 ether}();
		console.log(collection.balanceOf(RANDOM, 0));
		console.log(collection.balanceOf(RANDOM, 1));
		vm.stopPrank();
	}
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import "../src/Shirtless.sol";
import "../src/DAO.sol";

contract DaoTest is Test {
	Dao dao;
	Shirtless collection;

	function setUp() public {
		dao = new Dao();
		collection = new Shirtless();
		collection.transferOwnership(address(dao));
		dao.setCollection(address(dao));
		console.log(address(dao.mintSplitter()));
	}

	function test() public {
		console.log("test");
	}
}

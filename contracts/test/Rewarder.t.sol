// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import "@solmate/tokens/ERC20.sol";

import "./helpers/TestWithHelpers.sol";
import "./helpers/MaticTest.sol";

import "../src/Rewarder.sol";
import "../src/Shirtless.sol";

import {ISuperToken} from "@superfluid-finance/interfaces/superfluid/ISuperToken.sol";

contract RewarderTest is TestWithHelpers, MaticTest {
	Rewarder rewarder;
	Shirtless collection;
	address polMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
	address polMATICx = 0x3aD736904E9e65189c3000c7DD2c8AC8bB7cD4e3;
	address RICH_GUY = 0x86f1d8390222A3691C28938eC7404A1661E618e0;

	function setUp() public {
    activateFork(33558328);
		collection = new Shirtless();
		rewarder = new Rewarder(address(collection), polMATICx, 0, 0x3E14dC1b13c488a8d5D310918780c983bD5982E7);
		hoax(msg.sender);
		console.log(address(msg.sender).balance);
		ISuperToken(polMATICx).upgrade(50000);
	}

	function testSendMoney() public {
	}
}
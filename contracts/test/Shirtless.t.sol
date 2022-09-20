// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./SuperfluidTester.sol";
import "./TestWithHelpers.sol";

contract ShirtlessTest is SuperfluidTester, TestWithHelpers {
    IDAv1Library.InitData internal _idaLib;

    ISuperfluidToken ETHx;

    constructor() SuperfluidTester(address(1)) {}

		/*
    function setUp() public {
    }
		*/

		function testSomething() public {
			sf.ida.createIndex(ETHx, 0, "");
			sf.ida.updateSubscription(ETHx, 0, RANDOM, 10, "");
			sf.ida.listSubscriptions(ETHx, RANDOM);
		}
}

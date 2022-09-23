// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./MaticTest.sol";
import "./TestWithHelpers.sol";

contract ShirtlessTest is MaticSuperfluidTest, TestWithHelpers {

    ISuperToken ETHx = ISuperToken(polETHx);
		uint32 INDEX_ID = 0;

    function setUp() public {
        activateFork();
				getIdaLibrary();
				console.log(ETHx.getHost());
    }

    function testSomething() public {
			idaLib.createIndex(ETHx, INDEX_ID);
    }
}

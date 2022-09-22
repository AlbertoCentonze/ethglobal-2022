// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./MaticTest.sol";
import "./TestWithHelpers.sol";

contract ShirtlessTest is MaticSuperfluidTest, TestWithHelpers {
    IDAv1Library.InitData internal _idaLiba = IDAv1Library.InitData(maticIdaAddress);

    ISuperfluidToken ETHx = ISuperfluidToken(polETHx);

    function setUp() public {
				activateFork();
    }

    function testSomething() public {
        //sf.ida.createIndex(ETHx, 0, "");
        //sf.ida.updateSubscription(ETHx, 0, RANDOM, 10, "");
        //sf.ida.listSubscriptions(ETHx, RANDOM);
    }
}

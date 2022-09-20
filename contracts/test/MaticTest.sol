// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";

abstract contract MaticTest is Test {
    function setUp() public {
        string MATIC_RPC_URL = vm.envString("MATIC_RPC_URL");
        uint256 maticFork = vm.createFork(MATIC_RPC_URL);
        assertEq(vm.activeFork(), maticFork);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";

abstract contract MaticTest is Test {
    uint256 maticFork;

    function activateFork() public {
        string memory MATIC_RPC_URL = vm.envString("MATIC_RPC_URL");
        maticFork = vm.createSelectFork(MATIC_RPC_URL);
    }
}

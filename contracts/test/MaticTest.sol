// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";

abstract contract MaticTest is Test {
    uint256 maticFork;

    function activateFork(uint256 block_number) public {
        string memory MATIC_RPC_URL = vm.rpcUrl("matic");
        maticFork = vm.createSelectFork(MATIC_RPC_URL, block_number);
    }
}

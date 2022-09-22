// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";

abstract contract MaticTest is Test {
    uint256 maticFork;
    address maticSuperfluidHost = 0x3E14dC1b13c488a8d5D310918780c983bD5982E7;
    address maticIda = 0xB0aABBA4B2783A72C52956CDEF62d438ecA2d7a1;

    function activateFork() public {
        string memory MATIC_RPC_URL = vm.envString("MATIC_RPC_URL");
        maticFork = vm.createSelectFork(MATIC_RPC_URL);
    }
}

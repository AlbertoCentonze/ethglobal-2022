// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";

abstract contract MaticTest is Test {
    uint256 maticFork;
    address polUsdc = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address aPolUsdc = 0x625E7708f30cA75bfd92586e17077590C60eb4cD;

    function activateFork(uint256 block_number) public {
        string memory MATIC_RPC_URL = vm.rpcUrl("matic");
        maticFork = vm.createSelectFork(MATIC_RPC_URL, block_number);
    }
}

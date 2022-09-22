// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";

abstract contract MaticTest is Test {
    uint256 maticFork;

    address polUsdc = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address aPolUsdc = 0x625E7708f30cA75bfd92586e17077590C60eb4cD;

    address polWeth = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
    address aPolWeth = 0xe50fA9b3c56FfB159cB0FCA61F5c9D750e8128c8;
    address aPolWethV2 = 0x28424507fefb6f7f8E9D3860F56504E4e5f5f390;

    address polPool = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;
    // polygon adress for Weth and aWeth

    function activateFork(uint256 block_number) public {
        string memory MATIC_RPC_URL = vm.rpcUrl("matic");
        maticFork = vm.createSelectFork(MATIC_RPC_URL, block_number);
    }
}

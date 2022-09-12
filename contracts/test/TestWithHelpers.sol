// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@openzeppelin/utils/Counters.sol";

/**
Helper class with some functions to simplify tests
 */
abstract contract TestWithHelpers is Test {
    address internal DEV_FUND = address(657489);

    using Counters for Counters.Counter;
    Counters.Counter counter;

    function getRandomAddress() public returns (address randomAddress) {
        randomAddress = address(uint160(counter.current()));
        counter.increment();
        vm.deal(randomAddress, 100000 ether);
    }
}
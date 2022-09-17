// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * Helper class with some functions and variables to simplify tests
 */
abstract contract TestWithHelpers is Test {
    address internal DEV_FUND = address(657489);
    address internal RANDOM = address(34987);
}

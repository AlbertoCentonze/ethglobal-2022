// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@forge-std/Test.sol";

/**
 * Helper class with some functions and variables to simplify tests
 */
abstract contract TestWithHelpers is Test {
    address internal DEV_FUND = makeAddr('DEV_FUND');
    address internal RANDOM = makeAddr('RANDOM');
    address internal DEPLOYER = makeAddr('DEPLOYER');
}

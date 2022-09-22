// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVault {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function claim(address receiver) external;
}

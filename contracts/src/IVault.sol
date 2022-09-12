// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVault {
    function deposit(uint256 amount) external; //TODO nonReentrant
    function withdraw(uint256 amount) external; //TODO nonReentrant
    function claim() external;
}

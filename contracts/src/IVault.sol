// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IVault {
    function deposit(uint256 amount) external; //TODO nonReentrant (not usefull if we don't handle ETH or ERC-1155)
    function withdraw(uint256 amount) external; //TODO nonReentrant (not usefull if we don't handle ETH or ERC-1155)
    function claimInterest(address recipient) external;
    function totalAssets() external;
    function asset() external;
    // function withdrawBurnerValue(address recipient) external;//TODO nonReentrant (not usefull if we don't handle ETH or ERC-1155)
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IVault {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount, address recipient) external;
    function claimInterest(address recipient) external;

    /**
     * Inspired from ERC-4626
     */
    function asset() external view returns (address);
    function totalAssets() external view returns (uint256);

    function withdrawBurnerValue(address recipient) external;
}

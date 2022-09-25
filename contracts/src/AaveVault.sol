// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IVault.sol";
import "./NftManager.sol";
import "./IAaveProtocolDataProvider.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@aave/interfaces/IPool.sol";
import "@forge-std/console.sol";

contract AaveVault is IVault, Ownable {
    //constant addresses
    address public aavePoolAddressProvider; //Polygon Mainnet: 0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb

    address public underlyingToken; //0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174 = Polygon USDC
    address public aavePool;
    address public aToken; 

    uint256 public totalUnderlyingDeposited;

    uint8 public slashingPercentange;

    constructor(address _underlyingToken, uint8 _slashingPercentange, address _aavePoolAddressProvider) {
        underlyingToken = _underlyingToken;
        aavePoolAddressProvider = _aavePoolAddressProvider;
        aavePool = IPoolAddressesProvider(aavePoolAddressProvider).getPool();
        address poolDataProvider = IPoolAddressesProvider(aavePoolAddressProvider).getPoolDataProvider();
        (aToken,,) = IAaveProtocolDataProvider(poolDataProvider).getReserveTokensAddresses(underlyingToken);
        slashingPercentange = _slashingPercentange;
    }

    function getPendingRewards() public view returns(uint256){
        return IERC20(aToken).balanceOf(address(this)) - totalUnderlyingDeposited;
    }

    function deposit(uint256 amount) external {
        IERC20(underlyingToken).transferFrom(msg.sender, address(this), amount);
        totalUnderlyingDeposited += amount;
        IERC20(underlyingToken).approve(address(aavePool), amount);

        IPool(aavePool).supply(underlyingToken, amount, address(this), 0);
        console.log("Balance of the aaveVault in aToken after depositing is ", IERC20(aToken).balanceOf(address(this)));
    }

    function withdraw(uint256 amount, address recepient) public onlyOwner {
        totalUnderlyingDeposited -= amount;
        // approve aToken for aavePool?
        console.log("I'm trying to withdraw");
        //TODO: IERC20(aToken).approve(aavePool, amount);
        IPool(aavePool).withdraw(underlyingToken, amount, recepient);
        console.log("Balance of the aaveVault in aToken after withdrawing is", IERC20(aToken).balanceOf(address(this)));
        console.log("Someone is withdrawing ", amount, "of underlyingToken");
    }

    function claimInterest(address recepient) public onlyOwner {
        uint256 aTokenBalance = IERC20(aToken).balanceOf(address(this));
        require(aTokenBalance > totalUnderlyingDeposited);
        uint256 amount = aTokenBalance - totalUnderlyingDeposited;
        console.log("amount of interest = ", amount);
        IERC20(aToken).approve(aavePool, amount);
        IPool(aavePool).withdraw(underlyingToken, amount, recepient);
    }

    //function that let you withdraw (half of an NFT value)
    function withdrawBurnerValue(address recipient) public onlyOwner {
        //since it is the DAO that is the owner of the vault
        withdraw(burnerValue(), recipient);
    }

    function burnerValue() public returns (uint256 withdrawAmount) {
        uint256 circulatingSupply = NftManager(owner()).circulatingSupply();
        withdrawAmount = totalUnderlyingDeposited / (circulatingSupply * 100) * slashingPercentange;
    }

    function asset() public view returns (address) {
        return underlyingToken;
    }

    function totalAssets() public view returns (uint256) {
        return totalUnderlyingDeposited;
    }
}

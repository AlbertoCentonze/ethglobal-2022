// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IVault.sol";
import "./DAO.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; //TODO Use solmate Owner
import "@openzeppelin/contracts/utils/Counters.sol";
import "@aave/interfaces/IPool.sol";
import "@forge-std/console.sol";
import "./IWETHGateway.sol";

contract AaveVault is IVault, Ownable {
    //constant addresses
    address public underlyingToken; //0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174 = Polygon USDC
    //Aave contract address
    address public aavePool = 0x794a61358D6845594F94dc1DB02A252b5b4814aD; //0x794a61358D6845594F94dc1DB02A252b5b4814aD = Polygon Aave Pool
    address public aToken; //0x625E7708f30cA75bfd92586e17077590C60eb4cD = aPolUSDC
    address public wethGateway;
    //address public L2EncoderAdd; // helper contract
    //TODO: add Shirtless contract address
    address public collection;

    // uint256 public underlyingAsset = 0;

    uint256 public totalUnderlyingDeposited = 0;

    uint8 public slashingPercentange;

    constructor(address _underlyingToken, address _aToken, uint8 _slashingPercentange, address _collection, address _wethGateway) {
        underlyingToken = _underlyingToken;
        aToken = _aToken;
        slashingPercentange = _slashingPercentange;
        collection = _collection;
        wethGateway = _wethGateway;
    }

    function deposit() external payable {
        // msg.value,
        //IERC20(underlyingToken).transferFrom(msg.sender, address(this), amount);
        totalUnderlyingDeposited += msg.value;
        //IERC20(underlyingToken).approve(address(aavePool), amount);

        //IPool(aavePool).supply(underlyingToken, amount, address(this), 0);
        WETHGateway(wethGateway).depositETH{value : msg.value}(aavePool, address(this), 0);
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

    function burnerValue() public view returns (uint256 withdrawAmount) {
        uint256 circulatingSupply = Dao(owner()).circulatingSupply();
        withdrawAmount = totalUnderlyingDeposited / (circulatingSupply * 100) * slashingPercentange;
    }

    function asset() public view returns (address) {
        return underlyingToken;
    }

    function totalAssets() public view returns (uint256) {
        // return underlyingToken.balanceOf(address(this));
    }

    //TODO: rebalance function depending on the health factor (cross-chain)

    //TODO: share per NFT ?

    //TODO: claimable total yield / claimable yield per NFT ?
}

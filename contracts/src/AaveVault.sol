// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IVault.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; //TODO Use solmate Owner
import "@aave/interfaces/IPool.sol";
import "@forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract AaveVault is IVault, Ownable {
    //constant addresses
    address public underlyingToken; //0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174 = Polygon USDC
    //Aave contract address
    address public aavePool; //0x794a61358D6845594F94dc1DB02A252b5b4814aD = Polygon Aave Pool
    address public aToken; //0x625E7708f30cA75bfd92586e17077590C60eb4cD = aPolUSDC
    //address public L2EncoderAdd; // helper contract
    //TODO: add Shirtless contract address
    address public collection;

    // uint256 public underlyingAsset = 0;

    uint256 public totalUnderlyingDeposited = 0;

    uint8 public slashingPercentange;

    constructor(address _underlyingToken, address _aToken, uint8 _slashingPercentange) {
        underlyingToken = _underlyingToken;
        aToken = _aToken;
        slashingPercentange = _slashingPercentange;
    }

    function withdraw(uint256 amount) public {}

    function deposit(uint256 amount) external {
        console.log("RANDOM inside deposit = ");
        console.log(IERC20(underlyingToken).balanceOf(msg.sender));

        console.log("msg sender =");
        console.log(msg.sender);

        console.log("approve = ");
        console.log(IERC20(underlyingToken).approve(address(this), amount));

        console.log("RANDOM inside deposit after approve = ");
        console.log(IERC20(underlyingToken).allowance(msg.sender, address(this)));


        IERC20(underlyingToken).transferFrom(msg.sender, address(this), amount);
        // // totalDeposited += amount;
        IPool(aavePool).supply(underlyingToken, amount, address(this), 0);

        totalUnderlyingDeposited += amount;
    }

    function withdraw(uint256 amount, address recepient) public onlyOwner {
        totalUnderlyingDeposited -= amount;
        // approve aToken for aavePool?
        IPool(aavePool).withdraw(underlyingToken, amount, recepient);
    }

    function claimInterest(address recepient) public onlyOwner {
        // amount = IERC20(aToken).balanceOf(address(this)) - totalUnderlyingDeposited;
        // IPool(aavePool).withdraw(underlyingToken, amount, recepient);
    }

    //function that let you withdraw (half of an NFT value)
    function withdrawBurnerValue(address recipient) public onlyOwner {
        //since it is the DAO that is the owner of the vault
        withdraw(burnerValue(), recipient);
    }

    function burnerValue() public view returns (uint256 withdrawAmount) {
        // WTF uint256 circulatingSupply = Counters.current(owner.circulatingSupply());
        // uint256 withdrawAmount = totalUnderlyingDeposited / (circulatingSupply * 100) * slashingPercentange;
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

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./AaveVault.sol";
import "./Shirtless.sol";
import "./IWMatic.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@forge-std/console.sol";

contract NftManager is Ownable {
    using Counters for Counters.Counter;

    Shirtless collection;
    uint256 mintPrice = 1 ether;

    uint256 maxSupply;

    address wMatic; // 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    AaveVault aaveVault;
    address rewarder;

    constructor (uint256 _mintPrice, uint256 _maxSupply ,address _wMatic, address _rewarder /*, address _ensCrossChain*/) {
        mintPrice = _mintPrice;
        maxSupply = _maxSupply;
        wMatic = _wMatic;
        rewarder = _rewarder;
        aaveVault = new AaveVault(_wMatic, 50);
        collection = new Shirtless();
        // ensCrossChain = _ensCrossChain;
    }

    function circulatingSupply() public view returns(uint256) {
        return collection.circulatingSupply();
    }

    function setWMaticAdd(address _wMatic) public onlyOwner {
        wMatic = _wMatic;
    }

    function setRewarder(address _rewarder) public onlyOwner {
        rewarder = _rewarder;
    }

    function setAaveVault(AaveVault _aaveVault) public onlyOwner {
        aaveVault = _aaveVault;
    }

    function setCollection(address collectionAddress) public onlyOwner {
        collection = Shirtless(collectionAddress);
    }

    function setPrice(uint256 newPrice) public onlyOwner {
        require(newPrice > 0);
        mintPrice = newPrice;
    }

    function claimInterests() public {
        aaveVault.claimInterest(rewarder);
    }

    // function mint() public {
    function mint() public payable {
        require(collection.mintId() < maxSupply, "Can't mint more NFTs than max supply");
        require(msg.value == mintPrice, "Value sent in tx does not match mint price");
        IWMATIC(wMatic).deposit{value : msg.value}();
        IWMATIC(wMatic).approve(address(aaveVault), msg.value);
        aaveVault.deposit(msg.value);
        collection.mint(msg.sender, collection.mintId(), "");
        // ensCrossChain.xMintSubDomain(msg.sender, collection.mintId());
    
    }

    function burn(uint256 id) public {
        require(collection.ownerOf(id) == msg.sender, "NOT_OWNER");
        collection.burn(id);
        aaveVault.withdrawBurnerValue(msg.sender);
    }
}

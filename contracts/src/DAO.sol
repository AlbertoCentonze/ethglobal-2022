// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./IVault.sol";
import "./Shirtless.sol";
import "@openzeppelin/contracts/interfaces/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@forge-std/console.sol";

contract Dao is Ownable {
    using Address for address;
    using Counters for Counters.Counter;

    Shirtless collection;
    IVault[] vaults;
    PaymentSplitter mintSplitter;
    uint256 mintPrice = 1 ether;

    uint256 maxSupply = 100; // TODO Should max supply be mutable ?

    Counters.Counter public circulatingSupply;
    Counters.Counter mintId;

    //TODO: make a constructor with address for mintSplitter ecc and deploy an AaveVault

    function setCollection(address collectionAddress) public onlyOwner {
        collection = Shirtless(collectionAddress);
    }

    //TODO contract type vs address ?
    function setMintSplitter(PaymentSplitter splitter) public onlyOwner {
        // TODO require nonZero ? It would break the tests tho
        mintSplitter = PaymentSplitter(splitter);
    }

    function setPrice(uint256 newPrice) public onlyOwner {
        require(newPrice > 0);
        mintPrice = newPrice;
    }

    function claimAllRewards() public {
        // TODO this is totally a placeholder
        for (uint256 index = 0; index < vaults.length; index++) {
            // vaults[index].claim(address(this));
        }
    }

    function mint() public payable {
        require(address(mintSplitter).isContract(), "Splitter is not set correctly");
        require(mintId.current() < maxSupply, "Can't mint more NFTs than max supply");
        require(msg.value == mintPrice, "Value sent in tx does not match mint price");

        collection.mint(msg.sender, mintId.current(), "");
        mintId.increment();
        circulatingSupply.increment();
        
    }

    function burn(uint256 id) public {
        require(collection.ownerOf(id) == msg.sender, "NOT_OWNER");
        collection.burn(id);
        circulatingSupply.decrement();
        // withdrawBurnerValue(msg.sender);
    }

    // TODO find a way to distrubte the revenues owned by this address:
    // Check on the group for a possible example of an implementation
}

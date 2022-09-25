// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Script.sol";
import "../src/NftManager.sol";
import "../src/Shirtless.sol";
import "../src/EnsCrossChain.sol";
import "../src/Rewarder.sol";

import {IConnextHandler} from "@connext/interfaces/IConnextHandler.sol";
import "@solmate/auth/Owned.sol";



contract MumbaiContractsDeployer is Script {
    address MumbaiWMatic = 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889;
    address MumbaiPoolAddressesProvider = 0x5343b5bA672Ae99d627A1C87866b8E53F47Db2E6;
    address rewardSuperToken = 0x3aD736904E9e65189c3000c7DD2c8AC8bB7cD4e3;
    address superfluidHost = 0xEB796bdb90fFA0f28255275e16936D25d3418603;
    uint32 superfluidIndexId = 69; //arbitrarily chosen
    IConnextHandler MumbaiConnext = IConnextHandler(0xD9e8b18Db316d7736A3d0386C59CA3332810df3B);
    uint32 MumbaiDomain = 9991; 
    uint32 GoerlyDomain = 1735353714;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.broadcast(deployerPrivateKey);
        
        //start on Mumbai
        //deploy EnsCrossChain
        address ensCrossChain = new EnsCrossChain(MumbaiConnext, MumbaiDomain, GoerlyDomain);
        //deploy the NFT collection
        address collection = new Shirtless();
        //deploy NftManager
        address nftManager = new NftManager(collection, 1, 1000, MumbaiWMatic, MumbaiPoolAddressesProvider, ensCrossChain);
        //transferOwnership of ensCrossChain from deployer to nftManager
        Owned(ensCrossChain).setOwner(nftManager);
        //deploy rewarder or deploy internally in nftMnager constructor
        address rewarder = new Rewarder(collection, rewardSuperToken, superfluidIndexId, superfluidHost);
        //set rewarder in nftManager
        NftManager(nftManager).setRewarder(rewarder);
        vm.stopBroadcast();
    }
}

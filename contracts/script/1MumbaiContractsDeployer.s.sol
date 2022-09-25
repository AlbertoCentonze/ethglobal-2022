// SPDX-License-Identifier: UNLICENSED
/* pragma solidity ^0.8.13;

import "@forge-std/Script.sol";
import "../src/NftManager.sol";
import "../src/Shirtless.sol";
import "../src/EnsCrossChain.sol";

// import {IConnextHandler} from "@connext/interfaces/IConnextHandler.sol";
import "@solmate/auth/Owned.sol";



contract MumbaiContractsDeployer is Script {
    address MumbaiWMatic = 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889;
    address MumbaiPoolAddressesProvider = 0x5343b5bA672Ae99d627A1C87866b8E53F47Db2E6;
    // IConnextHandler MumbaiConnext = IConnextHandler(0xD9e8b18Db316d7736A3d0386C59CA3332810df3B); //TODO
    uint32 MumbaiDomain = 9991; //TODO
    uint32 GoerlyDomain = 1735353714;//TODO

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.broadcast(deployerPrivateKey);
        
        //start on Mumbai
        //deploy EnsCrossChain
        // address ensCrossChain = new EnsCrossChain(MumbaiConnext, MumbaiDomain, GoerlyDomain);
        //deploy the NFT collection
        address collection = new Shirtless();
        //deploy NftManager
        address nftManager = new NftManager(collection, 1, 1000, MumbaiWMatic, MumbaiPoolAddressesProvider, ensCrossChain);
        //transferOwnership of ensCrossChain from deployer to nftManager
        Owned(ensCrossChain).setOwner(nftManager);
        //deploy rewarder or deploy internally in nftMnager constructor

        //set rewarder in nftManager

        vm.stopBroadcast();
        

    }

    //TODO deploy NftManager on Mumbai
    //TODO: can the NftManager constructor deploy the 
    function NftManagerDeploy() public returns (address nftManager) {
        //TODO: deploy the NftManager args: (1, 1000, MumbaiWMatic, MumbaiPoolAddressesProvider)
    }

    function EnsCrossChainDeploy() public returns (address ensCrossChain){
        //TODO: ensCrossChain = new EnsCrossChain(IConnextHandler _connext ,uint32 _originDomain, uint32 _destinationDomain)
    }

    //TODO: deploy the EnsManager on Goerly
    //this contract should be deployed first
    function EnsManagerDeploy(address nftManager) public {

    }

    //TODO: set the EnsCrossChain in the NftManager
    function setEnsCrossChain() public {

    }
}
*/
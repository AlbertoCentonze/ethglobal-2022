// SPDX-License-Identifier: UNLICENSED
/*pragma solidity ^0.8.13;

import "@forge-std/Script.sol";
import "../src/EnsManager.sol";
// import {IConnextHandler} from "@connext/interfaces/IConnextHandler.sol";

contract GoerlyContractsDeployer is Script {
    address ensCrossChain;//TODO
    uint32 shirtlessEns; //TODO
    uint32 MumbaiDomain = 9991;
    IConnextHandler GoerlyConnext = IConnextHandler(0xD9e8b18Db316d7736A3d0386C59CA3332810df3B);
    address GoerlyEnsContractAddress = 0x112234455C3a32FD11230C42E7Bccd4A84e02010;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        address ensManager = new EnsManager(ensCrossChain, MumbaiDomain, GoerlyConnext, GoerlyEnsContractAddress, shirtlessEns);
        vm.stopBroadcast();
    }
}
*/
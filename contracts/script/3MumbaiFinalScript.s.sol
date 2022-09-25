// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Script.sol";
import "../src/NftManager.sol";

contract MumbaiEnsManagerSetter is Script {
    address nftManager; //TODO: get from past deployment
    address ensManagerAddress; //TODO: get from past deployment

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        NftManager(nftManager).setEnsManager(ensManagerAddress);
        vm.stopBroadcast();
    }
}
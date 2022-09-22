// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IConnextHandler} from "nxtp/core/connext/interfaces/IConnextHandler.sol";
import {IExecutor} from "nxtp/core/connext/interfaces/IExecutor.sol";
import {LibCrossDomainProperty} from "nxtp/core/connext/libraries/LibCrossDomainProperty.sol";

contract FIFSRegistrar {

    // The address of Source.sol
    address public originContract;

    // The origin Domain ID
    uint32 public originDomain;

    // The address of the Connext Executor contract
    IExecutor public executor;

    // A modifier for authenticated function calls.
    // Note: This is an important security consideration. If your target
    //       contract function is meant to be authenticated, it must check
    //       that the originating call is from the correct domain and contract.
    //       Also, it must be coming from the Connext Executor address.
    modifier onlyExecutor() {
        require(
        LibCrossDomainProperty.originSender(msg.data) == originContract &&
            LibCrossDomainProperty.origin(msg.data) == originDomain &&
            msg.sender == address(executor),
        "Expected origin contract on origin domain called by Executor"
        );
        _;
    }

    constructor(
        address _originContract,
        uint32 _originDomain,
        IConnextHandler _connext
    ) {
        originContract = _originContract;
        originDomain = _originDomain;
        executor = _connext.executor();
    }

  // Authenticated mint function
  //TODO: change name and args
    function updateValueAuthenticated(uint256 newValue) 
        external onlyExecutor   {
    //TODO: mint the subdomain linked to the NFT
    }

    // Authenticated burn function
    //TODO: change name and args
    function updateValueAuthenticated(uint256 newValue) 
        external onlyExecutor 
    {
        //TODO: burn the subdomain linked to the NFT
    }

    //TODO: add the possibility to associate an ardress to the ENS + twitter for example
/*
    ENS ens;
    bytes32 rootNode;

    function FIFSRegistrar(address ensAddr, bytes32 node) {
        ens = ENS(ensAddr);
        rootNode = node;
    }
    function register(bytes32 subnode, address owner) {
        //var node = sha3(rootNode, subnode);
        //var currentOwner = ens.owner(node);

        if (currentOwner != 0 && currentOwner != msg.sender) throw;

        ens.setSubnodeOwner(rootNode, subnode, owner);
    }
    function mintSubDomain()
		*/
}

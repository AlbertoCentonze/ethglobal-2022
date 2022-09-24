// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//import {IConnextHandler} from "nxtp/core/connext/interfaces/IConnextHandler.sol";
//import {IExecutor} from "nxtp/core/connext/interfaces/IExecutor.sol";
//import {LibCrossDomainProperty} from "nxtp/core/connext/libraries/LibCrossDomainProperty.sol";
//import "@ens/ENS.sol";
//TODO: anowble

contract EnsManager {
/*
    address ensAddress;

    // The address of Source.sol
    address public originContract;

    // The origin Domain ID
    uint32 public originDomain; // e.g. from Mumbai (Polygon testnet) (9991)

    // The address of the Connext Executor contract
    IExecutor public executor;

    uint32 selfNode;

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
        IConnextHandler _connext,
        address _ensAddress //https://docs.ens.domains/ens-deployments
    ) {
        originContract = _originContract;
        originDomain = _originDomain;
        executor = _connext.executor();
        ensAddress = _ensAddress;
    }

    function setSelfNode(uint32 _selfNode) public onlyOwner {

    }

  // Authenticated mint function
  //TODO: change name and args
    function mintSubDomain(address recipient, uint32 nftId) 
        external onlyExecutor   {
        //TODO: mint the subdomain linked to the NFT
        ENS(ensAddress).setSubnodeRecord(selfNode, nftId, recipient);
    }

    // Authenticated burn function
    //TODO: change name and args
    function burnSubDomain(uint32 newValue) 
        external onlyExecutor 
    {
        //TODO: burn the subdomain linked to the NFT
    }

    //TODO: add the possibility to associate an ardress to the ENS + twitter for example
		*/
}

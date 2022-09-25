// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@solmate/auth/Owned.sol";
import {IConnextHandler} from "@connext/interfaces/IConnextHandler.sol";
import {IExecutor} from "@connext/interfaces/IExecutor.sol";
import {LibCrossDomainProperty} from "@connext/libraries/LibCrossDomainProperty.sol";
import "@ens/ENS.sol";

contract EnsManager is Owned {
    address ensAddress;

    // The address of Source.sol
    address public originContract;

    // The origin Domain ID
    uint32 public originDomain; // e.g. from Mumbai (Polygon testnet) (9991)

    // The address of the Connext Executor contract
    IExecutor public executor;

    bytes32 selfNode;

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
        IConnextHandler _connext, //https://docs.connext.network/resources/testnet
        address _ensAddress, //https://docs.ens.domains/ens-deployments
        bytes32 _selfNode
    ) Owned(msg.sender) {
        originContract = _originContract;
        originDomain = _originDomain;
        executor = _connext.executor();
        ensAddress = _ensAddress;
        selfNode = _selfNode;
    }

    function setSelfNode(bytes32 _selfNode) public onlyOwner {
        selfNode = _selfNode;
    }

  // Authenticated mint function
    function mintSubDomain(address recipient, uint256 nftId) 
        external onlyExecutor   {
        //mint the subdomain linked to the NFT
        ENS(ensAddress).setSubnodeOwner(selfNode, bytes32(nftId), recipient);
    }

    // Authenticated burn function
    function burnSubDomain(uint256 nftId) 
        external onlyExecutor 
    {
        //burn the subdomain linked to the NFT
        ENS(ensAddress).setSubnodeOwner(selfNode, bytes32(nftId), address(this));
    }
<<<<<<< HEAD
=======

    //TODO: add the possibility to associate an ardress to the ENS + twitter for example
		*/
>>>>>>> aave-superfluid
}

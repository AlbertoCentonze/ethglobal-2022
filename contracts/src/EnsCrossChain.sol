// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@solmate/auth/Owned.sol";

contract EnsCrossChain is owned{
    address public ensRegistrar;
    //the ensRegistrar's functions' selectors
    bytes4 internal mintSelector = bytes4(keccak256("mintSubDomain(uint256)"));
    bytes4 internal burnSelector = bytes4(keccak256("burnSubDomain(uint256)"));

    uint32 originDomain; //e.g. from Goerli (1735353714) TDO: trouver le originDomain pour Polygon

    IConnextHandler public immutable connext;

    constructor(IConnextHandler _connext, uint32 _originDomain) {
        connext = _connext;
        originDomain = _originDomain;
    }

    //setter for the ensRegistrar address
    function setEnsRegistrar(address newEnsRegistrar) public onlyOwner {
        ensRegistrar = newEnsRegistrar;
    }

    // This function will call the Registrar to mint the ENS-subdomain.
    function xMintSubDomain(
        address to, // the address of the target contract
        uint32 destinationDomain, //TODO: have it in the constructor, to Optimism-Goerli (1735356532)
        address subDomainRecepient, // the address receiving the subdomain
        uint32 nftId //the NFT ID
        //TODO: add an argument of a name (packedString maybe)
    ) external payable {
        // the selector of this function is "mintSelector"
        //TODO: add the 3rd (name)
        bytes memory callData = abi.encodeWithSelector(mintSlector, subDomainRecepient, nftId);

        CallParams memory callParams = CallParams({
        to: ensRegistrar,
        callData: callData,
        originDomain: originDomain,
        destinationDomain: destinationDomain,
        agent: msg.sender, // address allowed to execute transaction on destination side in addition to relayers
        recovery: msg.sender, // fallback address to send funds to if execution fails on destination side
        forceSlow: true, // this must be true for authenticated calls
        receiveLocal: false, // option to receive the local bridge-flavored asset instead of the adopted asset
        callback: address(0), // zero address because we don't expect a callback
        callbackFee: 0, // fee paid to relayers for the callback; no fees on testnet
        relayerFee: 0, // fee paid to relayers for the forward call; no fees on testnet
        destinationMinOut: 0 // not sending funds so minimum can be 0
        });

        XCallArgs memory xcallArgs = XCallArgs({
        params: callParams,
        transactingAsset: address(0), // 0 address is the native gas token
        transactingAmount: 0, // not sending funds with this calldata-only xcall
        originMinOut: 0 // not sending funds so minimum can be 0
        });

        connext.xcall(xcallArgs);
    }


    //TODO: do xBurnSubdomain:
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@solmate/auth/Owned.sol";
import "@solmate/tokens/ERC721.sol";

import {Superfluid, InstantDistributionAgreementV1} from "@superfluid-finance/utils/SuperfluidFrameworkDeployer.sol";
import {IDAv1Library} from "@superfluid-finance/apps/IDAv1Library.sol";
import {ISuperToken} from "@superfluid-finance/interfaces/superfluid/ISuperToken.sol";

//TODO make it compliant with safeTransfer
contract Rewarder is Owned {
    //NFTs
    address collection;

    //Superfluid
    using IDAv1Library for IDAv1Library.InitData;

    IDAv1Library.InitData internal ida;
    Superfluid host;
    address public rewardSuperToken;
    uint32 indexId;

    constructor(address _collection, address _rewardSuperToken, uint32 _indexId) Owned(_collection) {
        collection = _collection;
        rewardSuperToken = _rewardSuperToken;
        indexId = _indexId;
    }

    function setIdaId(uint32 id) public onlyOwner {
        indexId = id;
    }

    function setRewardToken(address token) public onlyOwner {
        rewardSuperToken = token;
    }

    function updateUnitsFromBalanceOf(address owner) public onlyOwner {
        uint128 ownerBalance = uint128(ERC721(collection).balanceOf(owner));
        ida.updateSubscriptionUnits(ISuperToken(rewardSuperToken), indexId, owner, ownerBalance);
    }
}

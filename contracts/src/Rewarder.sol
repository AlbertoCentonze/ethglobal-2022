// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@solmate/auth/Owned.sol";
import "@solmate/tokens/ERC721.sol";

import {Superfluid, InstantDistributionAgreementV1} from "@superfluid-finance/utils/SuperfluidFrameworkDeployer.sol";
import {IDAv1Library} from "@superfluid-finance/apps/IDAv1Library.sol";
import {ISuperToken} from "@superfluid-finance/interfaces/superfluid/ISuperToken.sol";

// PUSH Comm Contract Interface
interface IPUSHCommInterface {
    function sendNotification(address _channel, address _recipient, bytes calldata _identity) external;
}

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

    constructor(address _collection, address _rewardSuperToken, uint32 _indexId, address _host) Owned(_collection) {
        // Superfluid setup
        host = Superfluid(_host);
        bytes32 classKeccak = keccak256("org.superfluid-finance.agreements.InstantDistributionAgreement.v1");
        address idaAddress = address(host.getAgreementClass(classKeccak));
        ida = IDAv1Library.InitData(host, InstantDistributionAgreementV1(idaAddress));

        // Contract setup
        collection = _collection;
        rewardSuperToken = _rewardSuperToken;
        indexId = _indexId;

        // Creates a new ida index
        ida.createIndex(ISuperToken(_rewardSuperToken), _indexId);
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

    // Permissionless, anyone can send the rewards at any time if he's willing to pay for gas fees
    function sendRewards(address EPNS_COMM_ADDRESS, address channelAddress) public {
        uint256 distributionAmount = ISuperToken(rewardSuperToken).balanceOf(address(this));
        ida.distribute(ISuperToken(rewardSuperToken), indexId, distributionAmount);
        IPUSHCommInterface(EPNS_COMM_ADDRESS).sendNotification(
            channelAddress, // from channel - recommended to set channel via dApp and put it's value -> then once contract is deployed, go back and add the contract address as delegate for your channel
            address(this), // to recipient, put address(this) in case you want Broadcast or Subset. For Targetted put the address to which you want to send
            bytes(
                string(
                    // We are passing identity here: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                    abi.encodePacked(
                        "0", // this is notification identity: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                        "+", // segregator
                        "3", // this is payload type: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/payload (1, 3 or 4) = (Broadcast, targetted or subset)
                        "+", // segregator
                        "Sending Rewards Alert", // this is notificaiton title
                        "+", // segregator
                        "Rewards are beeing sent through superfluid! ", // notification body
                        " PUSH to you!" // notification body
                    )
                )
            )
        );
    }
}

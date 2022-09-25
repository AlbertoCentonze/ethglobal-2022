// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@solmate/tokens/ERC721.sol";
import "@solmate/auth/Owned.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Superfluid, InstantDistributionAgreementV1} from "@superfluid-finance/utils/SuperfluidFrameworkDeployer.sol";
import {IDAv1Library} from "@superfluid-finance/apps/IDAv1Library.sol";
import {ISuperToken} from "@superfluid-finance/interfaces/superfluid/ISuperToken.sol";

// Shirtless is just a placeholder name
/**
 * ERC721
 */
contract Shirtless is ERC721, Owned {
    using Counters for Counters.Counter;
    using IDAv1Library for IDAv1Library.InitData;

    IDAv1Library.InitData internal ida;
    Superfluid host;

    Counters.Counter public circulatingSupply;
    Counters.Counter public mintId;

    address rewardToken; //TODO Make setter ?
    uint32 indexId; //TODO

    constructor(address superfluidHost, address _rewardToken, uint32 _indexId)
        ERC721("Shirtless", "STL")
        Owned(msg.sender)
    {
        host = Superfluid(superfluidHost);
        ida = IDAv1Library.InitData(
            host,
            InstantDistributionAgreementV1(
                address(
                    host.getAgreementClass(
                        keccak256("org.superfluid-finance.agreements.InstantDistributionAgreement.v1")
                    )
                )
            )
        );

        ida.createIndex(ISuperToken(address(this)), 0);
        rewardToken = _rewardToken;
        indexId = _indexId;
    }

    function transferFrom(address from, address to, uint256 id) public override (ERC721) {
        ERC721.transferFrom(from, to, id);
        // updateUnitsAccordingToBalance(from);
        // updateUnitsAccordingToBalance(to);
    }

    function tokenURI(uint256 id) public pure override returns (string memory) {
        return "we don't have a url yet"; //TODO
    }

    function mint(address to, uint256 id, bytes memory data) public onlyOwner {
        mintId.increment();
        circulatingSupply.increment();
        _safeMint(to, id, data);
        // updateUnitsAccordingToBalance(to);
    }

    function burn(uint256 id) public onlyOwner {
        circulatingSupply.decrement();
        _burn(id);
        // updateUnitsAccordingToBalance(ownerOf(id));
    }
}

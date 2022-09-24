// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@solmate/tokens/ERC721.sol";
import "@solmate/auth/Owned.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Superfluid, InstantDistributionAgreementV1} from "@superfluid-finance/utils/SuperfluidFrameworkDeployer.sol";
import {IDAv1Library} from "@superfluid-finance/apps/IDAv1Library.sol";

// Shirtless is just a placeholder name
/**
 * ERC721
 */
contract Shirtless is ERC721, Owned {
    using Counters for Counters.Counter;
    using IDAv1Library for IDAv1Library.InitData;

    IDAv1Library.InitData internal idaLib;
    Superfluid host;

    Counters.Counter public circulatingSupply;
    Counters.Counter public mintId;

    constructor(address superfluidHost) ERC721("Shirtless", "STL") Owned(msg.sender) {
        host = Superfluid(superfluidHost);
        idaLib = IDAv1Library.InitData(
            host,
            InstantDistributionAgreementV1(
                address(
                    host.getAgreementClass(
                        keccak256("org.superfluid-finance.agreements.InstantDistributionAgreement.v1")
                    )
                )
            )
        );
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "we don't have a url yet"; //TODO
    }

    function mint(address to, uint256 id, bytes memory data) public onlyOwner {
        mintId.increment();
        circulatingSupply.increment();
        _safeMint(to, id, data);
    }

    function burn(uint256 id) public onlyOwner {
        circulatingSupply.decrement();
        _burn(id);
    }
}

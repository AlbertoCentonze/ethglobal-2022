// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Rewarder.sol";

import "@solmate/tokens/ERC721.sol";
import "@solmate/auth/Owned.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Superfluid, InstantDistributionAgreementV1} from "@superfluid-finance/utils/SuperfluidFrameworkDeployer.sol";
import {IDAv1Library} from "@superfluid-finance/apps/IDAv1Library.sol";
import {ISuperToken} from "@superfluid-finance/interfaces/superfluid/ISuperToken.sol";

contract Shirtless is ERC721, Owned {
    using Counters for Counters.Counter;

    Counters.Counter public circulatingSupply;
    Counters.Counter public mintId;

    address rewarder;

    constructor(address _rewarder) ERC721("Shirtless", "STL") Owned(msg.sender) {
        rewarder = _rewarder;
    }

    function transferFrom(address from, address to, uint256 id) public override (ERC721) {
        ERC721.transferFrom(from, to, id);
        Rewarder(rewarder).updateUnitsFromBalanceOf(from);
        Rewarder(rewarder).updateUnitsFromBalanceOf(to);
    }

    function tokenURI(uint256 id) public pure override returns (string memory) {
        return "we don't have a url yet"; //TODO
    }

    function mint(address to, uint256 id, bytes memory data) public onlyOwner {
        mintId.increment();
        circulatingSupply.increment();
        _safeMint(to, id, data);
        Rewarder(rewarder).updateUnitsFromBalanceOf(to);
    }

    function burn(uint256 id) public onlyOwner {
        circulatingSupply.decrement();
        _burn(id);
        Rewarder(rewarder).updateUnitsFromBalanceOf(ownerOf(id));
    }
}

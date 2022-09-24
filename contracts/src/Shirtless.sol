// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@solmate/tokens/ERC721.sol";
import "@solmate/auth/Owned.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


// Shirtless is just a placeholder name
/**
 * ERC721
 */
contract Shirtless is ERC721, Owned {
    using Counters for Counters.Counter;

    Counters.Counter public circulatingSupply;
    Counters.Counter public mintId;

    constructor() ERC721("Shirtless", "STL") Owned(msg.sender) {
        //TODO should we batchmint a certain amount to ourselves?
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

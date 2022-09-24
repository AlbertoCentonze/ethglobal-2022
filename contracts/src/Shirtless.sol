// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@solmate/tokens/ERC721.sol";
import "@solmate/auth/Owned.sol";

// TODO Yes, shirtless is just a placeholder name
/**
 * ERC721
 */
contract Shirtless is ERC721, Owned {
    constructor() ERC721("Shirtless", "STL") Owned(msg.sender) {
        //TODO should we batchmint a certain amount to ourselves?
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "https://c.tenor.com/x8v1oNUOmg4AAAAC/rickroll-roll.gif"; //TODO
    }

    function mint(address to, uint256 id, bytes memory data) public onlyOwner {
        _safeMint(to, id, data);
    }

    function burn(uint256 id) public onlyOwner {
        _burn(id);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/token/ERC1155/ERC1155.sol"; //TODO: use solmate's implementation
import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/security/Pausable.sol";
import "@openzeppelin/token/ERC1155/extensions/ERC1155Burnable.sol"; //I don't know if this is already included in solmate's implementation
import "@openzeppelin/token/ERC1155/extensions/ERC1155Supply.sol"; //I don't know if this is already included in solmate's implementation

// TODO Yes, shirtless is just a placeholder name
contract Shirtless is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {
    constructor() ERC1155("https://donthaveoneyet.com") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        internal
        override (ERC1155, ERC1155Supply)
        whenNotPaused
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function burn(address account, uint256 id, uint256 amount) public override onlyOwner {
        _burn(account, id, amount);
    }
}

// call the burn function and in the shirtless nft contract
// Test if burner is the owner
// Test if the balance for the burner is reduced

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../receivers/CCIPReceiver.sol";

contract ERC721CCIP is ERC721, CCIPReceiver {
    string public baseURI;

    constructor(address owner, address minter, address router, string memory symbol, string memory name, string memory bURI) 
        ERC721(name, symbol) 
        CCIPReceiver(router) 
    {
        baseURI = bURI;
    }

    function _mintFromMessage(address to, uint amount, uint[] memory tokenIds) internal override{
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _safeMint(to, tokenIds[i]);
        }
    }

    function changeBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return "";
    }

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override(ERC721, CCIPReceiver)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
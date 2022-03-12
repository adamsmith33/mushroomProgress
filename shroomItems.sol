pragma solidity ^0.8.4;
// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; //For handling strings

contract shroomItems is ERC1155, Ownable{
    string public name = "Shroom Items";
    string public symbol = "SHRMI";

    uint256 itemCount = 2;
    
    uint256 public constant STICK = 1;
    uint256 public constant TATTOO = 2;

    string[] public accessories = ["NONE", "STICK", "TATTOO"];

    mapping(address => bool) public isApproved;

    constructor () ERC1155("https://gateway.pinata.cloud/ipfs/QmVBQCT8G5FBPMhcYGQ6qr9jhCLbvWdhWo283PrPS3AGCt/{id}.json") {
        _mint(msg.sender, STICK, 3, "");
    }

    function rand(string memory input) pure internal returns(uint256){
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function mintRandomItem() public{
        uint256 itemIndex = (rand(string(abi.encodePacked(block.timestamp))) % (itemCount)) + 1;
        _mint(msg.sender, itemIndex, 1, "");
    }

    function setApproval(bool approval) public {
        isApproved[msg.sender] = approval;
    }

    function checkApproval(address addr) public view returns(bool) {
        return isApproved[addr];
    }

    function uri(uint256 tokenId) override public pure returns(string memory){
        return(
            string(abi.encodePacked(
                "https://gateway.pinata.cloud/ipfs/QmVBQCT8G5FBPMhcYGQ6qr9jhCLbvWdhWo283PrPS3AGCt/",
                Strings.toString(tokenId),
                ".json"
            ))
        );
    }
}


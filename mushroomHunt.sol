pragma solidity ^0.8.4;
// SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/utils/Counters.sol"; //For token IDs
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol"; //Console

contract mushroomHunt is Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private locationIds;

    struct mycolocation {
        string title;
        string description;
        string imageURI;
        uint256 locationNo;
        uint256 xCoord;
        uint256 yCoord;
        uint256[] requiredAccessories;
        uint256 xpValue;
    }

    struct truffleEntry {
        address visitor;
        uint256 shroomId;
        uint256 timestamp;
        string message;
    }

    mycolocation[] public mycolocations;

    mapping(uint256 => truffleEntry[]) public truffleBoxes;

    mapping(address => mapping(uint256 => bool)) public hasVisited;

    mapping(address => uint256[]) public userVisited;

    constructor() {

    }

    function addLocation(string memory title, string memory description, string memory imageURI, uint256 xCoord, uint256 yCoord, uint256[] memory requiredAccessories, uint256 xpValue) public onlyOwner {     
        mycolocations.push(mycolocation({
            title: title,
            description: description,
            imageURI: imageURI,
            locationNo: locationIds.current(),
            xCoord: xCoord,
            yCoord: yCoord,
            requiredAccessories: requiredAccessories,
            xpValue: xpValue
        }));
        locationIds.increment();
    }

    function getMycolocation(uint256 locationId) public view returns(mycolocation memory) {
        return mycolocations[locationId];
    }

    function getAllLocations() public view returns(mycolocation[] memory) {
        return mycolocations;
    }

    function getTruffleBox(uint256 LocationId) public view returns(truffleEntry[] memory){
        return truffleBoxes[LocationId];
    }

    function addToTruffleBox(uint256 locationId, uint256 shroomId, string memory message) public {
        truffleBoxes[locationId].push(truffleEntry({
            visitor: msg.sender,
            shroomId: shroomId,
            timestamp: block.timestamp,
            message: message
        }));
    }

}
pragma solidity ^0.8.4;
// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts/utils/Strings.sol"; //For handling strings
import { Base64 } from "./libraries/Base64.sol";

contract ShroomiesHelper {
        function bytesToUint(bytes memory data) external pure returns (uint256) {
        require(data.length == 32, "slicing out of range");
        uint x;
        assembly {
            x := mload(add(data, 0x20))
        }
        return x;
    }

    function rand(string memory input) external pure returns(uint256){
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function selectImage(uint256 _species, uint256 _age, uint256 _accessory) external pure returns(string memory){
        string memory baseImgURI = '"https://gateway.pinata.cloud/ipfs/QmQFw5mbBevmKb8SwZWXC5Dw7iNQMqZT7rXARY1RD5kXE8/';
        string memory speciesId = Strings.toString(_species);
        string memory ageId = Strings.toString(_age);
        string memory accessoryId = Strings.toString(_accessory);
        string memory endImgURI = '.png"';
        
        string memory imgURI = string(abi.encodePacked(baseImgURI, speciesId,"_",ageId,"_", accessoryId, endImgURI));

        return imgURI;
    }

    function createTokenURI(string memory _name, uint256 ID, string memory _species, string memory _imgURI) external pure returns(string memory) {

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                '{"name": "', _name,'", "description": "A cute mushroom.", "image": ', _imgURI,', "attributes": [{"trait_type": "Mushroom No.", "value": "', Strings.toString(ID),'"}, {"trait_type": "Species", "value": "', _species,'"}, {"trait_type": "Accessory", "value": "none"}, {"trait_type": "Age", "value": "0"}, {"trait_type": "Experience", "value": "0"}]}'
                    )
                )
            )
        );

        string memory finalOutput = string(abi.encodePacked("data:application/json;base64,", json));

        return finalOutput;
    }
}

interface IShroomiesHelper{
        function species(uint256) external view returns(string memory);

        function rand(string memory input) external returns(uint256);

        function selectImage(uint256 _species, uint256 _age, uint256 _accessory) external pure returns(string memory);

        function createTokenURI(string memory _name, uint256 ID, string memory _species, string memory _imgURI) external view returns(string memory);

        function bytesToUint(bytes memory data) external pure returns (uint256);

    }
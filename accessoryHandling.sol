pragma solidity ^0.8.4;
// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts/utils/Strings.sol"; //For handling strings
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./shroomies.sol";

import { Base64 } from "./libraries/Base64.sol";

contract accessoryHandling is Ownable{
    address shroomiesContract;
    address helperContract;
    address itemsContract;

    constructor(address sContract, address hContract, address iContract){
        setShroomiesContract(sContract);
        setHelperContract(hContract);
        setItemsContract(iContract);
    }

    function setShroomiesContract(address addr) public onlyOwner{
        shroomiesContract = addr;
    }

    function setHelperContract(address addr) public onlyOwner{
        helperContract = addr;
    }

    function setItemsContract(address addr) public onlyOwner{
        itemsContract = addr;
    }

    function updateURI(string memory _name, string memory _description, string memory _img, uint256 _mushNo, string memory _species, string memory _accessory, uint256 _age, uint256 _experience) public pure returns(string memory) {
            string memory json = Base64.encode(
            bytes(
                string(
            abi.encodePacked(
                '{"name": "', _name,'", "description": "', _description,'", "image": ', _img,', "attributes": [{"trait_type": "Mushroom No.", "value": "', Strings.toString(_mushNo),'"}, {"trait_type": "Species", "value": "', _species,'"}, {"trait_type": "Accessory", "value": "', _accessory,'"}, {"trait_type": "Age", "value": "', Strings.toString(_age),'"}, {"trait_type": "Experience", "value": "', Strings.toString(_experience),'"}]}'
                    )
                )
            )
        );

        string memory finalOutput = string(abi.encodePacked("data:application/json;base64,", json));
        return finalOutput;
    }


    function AccessoryChange(uint256 ID, uint256 accessoryID, address userAddr) external {
        uint256 currentAccessory = Ishroomies(shroomiesContract).currentAccessory(ID);

        IERC1155 accessoriesContract = IERC1155(itemsContract);
        require(accessoriesContract.balanceOf(userAddr, accessoryID) > 0 || accessoryID == 0, "You don't have any of that accessory.");
        require(currentAccessory != accessoryID, "That's already equipped.");

        if(accessoryID != 0){
            accessoriesContract.safeTransferFrom(userAddr, shroomiesContract, accessoryID, 1, abi.encodePacked(ID));
        }

        if(currentAccessory != 0){
            accessoriesContract.safeTransferFrom(shroomiesContract, userAddr, currentAccessory, 1, "");

            Ishroomies(shroomiesContract).removeAccessory(ID, currentAccessory);
        }
    }

}

interface IaccessoryHandling {
    function updateURI(string memory _name, string memory _description, string memory _img, uint256 _mushNo, string memory _species, string memory _accessory, uint256 _age, uint256 _experience) external pure returns(string memory);

    function AccessoryChange(uint256 ID, uint256 accessoryID, address addr) external;
}
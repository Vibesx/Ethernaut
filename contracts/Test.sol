// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "hardhat/console.sol";

contract Test {
    uint256[] public myArray;
    bytes32[] public bytesArray;

    function addElementToArray(uint256 el) public {
        myArray.push(el);
    }

    function addElementToBytes(uint256 el) public {
        bytesArray.push(keccak256(abi.encodePacked(el)));
    }
}

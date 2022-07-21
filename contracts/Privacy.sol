// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    
    function bytes32ToBytes16(bytes32 input) public pure returns (bytes16) {
        return bytes16(input);
    }
}
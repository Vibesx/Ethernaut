// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Force {

    address emptyForceAddress;
    address fundingAddress;

    function setForceAddress(address payable addr) public {
        emptyForceAddress = addr;
    }

    function setFundingAddress(address payable addr) public {
        fundingAddress = addr;
    }

    function byebye(address payable recipient) public {
        selfdestruct(recipient);
    }

    function fundMe() public payable {
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

interface IForce {
    fallback() external;
}

contract EmptyForce {
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
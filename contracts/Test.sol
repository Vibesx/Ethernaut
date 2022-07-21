// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import '@openzeppelin/contracts/utils/math/SafeMath.sol';

contract Test {
    //using SafeMath for uint256;
    uint a = 20;

    function testSomething(uint256 b) public view returns (uint256) {
        return a - b;
    }
}

contract Tester {
    Test test;

    constructor(address testAddress) public {
        test = Test(testAddress);
    }

    function testSomething() public view returns (uint256) {
        uint256 result = 0;
        try test.testSomething(25) {

        } catch {

        }
        return result;
    }
}
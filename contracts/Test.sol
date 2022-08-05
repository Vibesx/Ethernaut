// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "hardhat/console.sol";

contract TestSelfdestruct {
	function seldDest() public {
		selfdestruct(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
	}

	function doSomething() public pure returns (uint8) {
		return 24;
	}

	fallback() external {}
}

contract Victim {
	function delegateSelfdestruct(address addr) public {
		(bool success, ) = addr.delegatecall(abi.encodeWithSignature("selfDest()"));
		require(success);
	}

	function doSomethingElse() public pure returns (uint8) {
		return 42;
	}
}

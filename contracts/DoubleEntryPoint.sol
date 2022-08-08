// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IDetectionBot {
	function handleTransaction(address user, bytes calldata msgData) external;
}

interface IForta {
	function setDetectionBot(address detectionBotAddress) external;

	function notify(address user, bytes calldata msgData) external;

	function raiseAlert(address user) external;
}

contract MyDetectionBot is IDetectionBot {
	address constant VAULT = 0x50336F3d586CDf9b510875e3d4De633aE92D480b;

	function handleTransaction(address user, bytes calldata msgData) external override {
		(, , address origSender) = abi.decode(msgData[4:], (address, uint256, address));
		if (origSender == VAULT) {
			IForta(msg.sender).raiseAlert(user);
		}
	}
}

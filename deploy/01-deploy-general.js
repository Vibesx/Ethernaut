const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config.js");
const { verify } = require("../utils/verify.js");

module.exports = async function ({ getNamedAccounts, deployments }) {
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();
	const testContractName = "TestSelfdestruct";
	const victimContractName = "Victim";

	log("----------------------------");
	const args = [];
	await deploy(testContractName, {
		from: deployer,
		args: args,
		log: true,
		waitConfirmations: network.config.blockConfirmations,
	});

	await deploy(victimContractName, {
		from: deployer,
		args: args,
		log: true,
		waitConfirmations: network.config.blockConfirmations,
	});

	log("----------------------------");
};

module.exports.tags = ["all", "testStuff", "main"];

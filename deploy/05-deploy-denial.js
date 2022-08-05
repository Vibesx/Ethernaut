const { network, ethers } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config.js");
const { verify } = require("../utils/verify.js");

module.exports = async function ({ getNamedAccounts, deployments }) {
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();
	const denialContract = "Denial";
	const hackContract = "HackDenial";

	log("----------------------------");
	const denialArgs = [];
	const deployedDenialContract = await deploy(denialContract, {
		from: deployer,
		args: denialArgs,
		value: 1000000000000000,
		log: true,
		waitConfirmations: network.config.blockConfirmations,
	});

	const hackArgs = [deployedDenialContract.address];
	const deployedHackContract = await deploy(hackContract, {
		from: deployer,
		args: hackArgs,
		log: true,
		waitConfirmations: network.config.blockConfirmations,
	});

	log("----------------------------");
};

module.exports.tags = ["all", "denial", "main"];

const { network, ethers } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config.js");
const { verify } = require("../utils/verify.js");

module.exports = async function ({ getNamedAccounts, deployments }) {
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();
	const contractName = "AlienCodex";

	log("----------------------------");
	const args = [];
	const deployedContract = await deploy(contractName, {
		from: deployer,
		args: args,
		log: true,
		waitConfirmations: network.config.blockConfirmations,
	});

	if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
		log("Verifying...");
		await verify(deployedContract.address, args);
	}
	log("----------------------------");
};

module.exports.tags = ["all", "gatekeeperHack", "main"];

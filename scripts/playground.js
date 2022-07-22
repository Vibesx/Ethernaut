const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
	const { deployer } = await getNamedAccounts();
	const gk = await ethers.getContract("GatekeeperOne", deployer);
	const hack = await ethers.getContract("GatekeeperHack", deployer);
	//await hack.testSomething();
	const tx = await hack.hack();
	await tx.wait(1);
	console.log(`Entrant address: ${await gk.entrant()}`);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});

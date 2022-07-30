const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
	const { deployer } = await getNamedAccounts();
	const alienCodex = await ethers.getContract("AlienCodex", deployer);
	const tx = await alienCodex.hack();
	await tx.wait(1);
	console.log(`Entrant address: ${await gk.entrant()}`);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});

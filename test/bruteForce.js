const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");

!developmentChains.includes(network.name)
	? describe.skip
	: describe("GatekeeperBruteforce", async function () {
			let deployer, gk, hack, key;
			beforeEach(async () => {
				deployer = (await getNamedAccounts()).deployer;
				await deployments.fixture("all");
				gk = await ethers.getContract("GatekeeperOne", deployer);
				hack = await ethers.getContract("GatekeeperHack", deployer);
			});
			it("brute force", async () => {
				const gas = 30000;
				let i = 0;
				// generate key
				const txOrigin = hre.ethers.utils.hexZeroPad(deployer, 32);
				const part1 = "0x10000000";
				const part2 = "0x0000";
				// only leave last 2 bytes, which are equivalent to a uint16
				const part3 = hre.ethers.utils.hexDataSlice(txOrigin, 30);
				const key = hre.ethers.utils.hexConcat([part1, part2, part3]);
				console.log(key);
				await hack.checkGate3(key);
				for (; i < 8191; i++) {
					try {
						await hack.hack(gas + i, key, { gasLimit: 1120000 });
						break;
					} catch (error) {}
				}
				console.log(`${i} success`);
			});
			// it("test brute force", async () => {
			// 	await hack.hack(82164, key, { gasLimit: 1120000 });
			// });
	  });

// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
	/*
			Deploy receipt token
			*/
	const ReceiptToken = await ethers.getContractFactory("receiptToken");
	const receiptToken = await ReceiptToken.deploy();
	await receiptToken.deployed();
	/*
			Deploy predefined toke which is used for test purpose or to use instead of Real one.
			*/
	const DAI = await ethers.getContractFactory("DAIToken")
	const dai = await DAI.deploy();
	await dai.deployed();

	/*
			Deploy Pool contract
			*/
	const Pool = await ethers.getContractFactory("Pool");
	const pool = await Pool.deploy(dai.address, receiptToken.address);
	await pool.deployed();
	console.log("pool deployed to -->", pool.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});

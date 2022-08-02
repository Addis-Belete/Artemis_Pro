const { expect } = require("chai");
const { ethers } = require("hardhat");
const Web3 = require("web3");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers")

describe("Pool", () => {


	async function deployContractFixture() {
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

		/*
		Mint some tokens for the contract to pay as interest and for an account to deposit
		
		const amount = Web3.utils(10, "ethers");
		console.log("amount-->", amount);
*/
		return { receiptToken, dai, pool };
	}
	it("shoudl logs address of contracts", async () => {
		const { receiptToken, pool, dai } = await loadFixture(deployContractFixture);
		console.log("receipt Token deployed to -->", receiptToken.address);
		console.log("DAI predefined token deployed to -->", dai.address);
		console.log("pool contract deployed to -->", pool.address);

	})


})

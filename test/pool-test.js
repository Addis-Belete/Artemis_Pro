const { expect } = require("chai");
const { ethers } = require("hardhat");
const Web3 = require("web3");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

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
		const DAI = await ethers.getContractFactory("DAIToken");
		const dai = await DAI.deploy();
		await dai.deployed();

		/*
			Deploy Pool contract
			*/
		const Pool = await ethers.getContractFactory("Pool");
		const pool = await Pool.deploy(dai.address, receiptToken.address);
		await pool.deployed();
		const [owner, addr1, addr2] = await ethers.getSigners();

		/*
			Deploy controller
			*/
		const Controller = await ethers.getContractFactory("Controller");
		const controller = await Controller.deploy(pool.address, dai.address);
		await controller.deployed();
		/*
			Mint some tokens for the contract to pay as interest and for an account to deposit
			*/
		const amount = Web3.utils.toWei("100", "ether");
		await dai.connect(owner).mint(amount, addr1.address);
		await dai.connect(owner).mint(amount, pool.address);
		return { receiptToken, dai, pool, owner, addr1, addr2, controller };
	}
	it("shoudl logs address of contracts", async () => {
		const { receiptToken, pool, dai } = await loadFixture(
			deployContractFixture
		);
		console.log("receipt Token deployed to -->", receiptToken.address);
		console.log("DAI predefined token deployed to -->", dai.address);
		console.log("pool contract deployed to -->", pool.address);
	});
	it("Should return the balance of Dai(predefined token) of Pool and the address1", async () => {
		const { pool, dai, addr1 } = await loadFixture(deployContractFixture);
		const addr1Balance = await dai.balanceOf(addr1.address);
		const poolBalance = await dai.balanceOf(pool.address);
		console.log("balance of pool is -->", poolBalance.toString());
		console.log("balance of addr1 is -->", addr1Balance.toString());
	});

	it("should deposit and withdraw predefined token and transfer to the owner initialAmount + interest", async () => {
		const { receiptToken, pool, dai, owner, addr1, addr2, controller } =
			await loadFixture(deployContractFixture);
		const amount = Web3.utils.toWei("2", "ether");
		await dai.connect(addr1).approve(controller.address, amount);
		await controller.connect(addr1)._deposit(amount);
		const userInfo = await pool.userData(addr1.address);
		expect(userInfo.amount.toString()).equal(amount);
		const addr1ReceiptBalance = await receiptToken.balanceOf(addr1.address)
		const addr1DaiBalance = await dai.balanceOf(addr1.address);
		expect(addr1ReceiptBalance.toString()).equal(amount)
		await controller.connect(addr1)._withdraw(amount, addr1.address);
		const addr1DaiBalance1 = await dai.balanceOf(addr1.address);
		expect(addr1DaiBalance1).above(addr1DaiBalance);
		const userInfo1 = await pool.userData(addr1.address);
		expect(userInfo1.amount.toString()).equal("0");
	});
});

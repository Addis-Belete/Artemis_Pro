require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
/** @type import('hardhat/config').HardhatUserConfig */
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY;
module.exports = {
	solidity: {
		compilers: [
			{
				version: "0.8.0",
			},
			{
				version: "0.8.1",
				settings: {},
			},
		],
	},
	networks: {
		goerli: {
			url: "https://eth-goerli.g.alchemy.com/v2/w4C79D6T9rlYgl6YyMsYJ8Whmi4bHMYy",
			accounts: [`0x${GOERLI_PRIVATE_KEY}`]
		}
	}
};

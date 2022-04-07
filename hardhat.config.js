require("@nomiclabs/hardhat-waffle");
require('dotenv').config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

let mnemonic = process.env.MNEMONIC;
let privateKey = process.env.PRIVATE_KEY;

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.10",
  networks: {
		harmony_testnet: {
      url: 'https://api.s0.b.hmny.io',
      accounts: [privateKey],
      gas: 2100000,
      gasPrice: 80000000000
		},
    mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/mXAvyOt4sk9WFfxNSph1aODQu_P0LpVE",
      accounts: [privateKey],
      gas: 2100000,
      gasPrice: 80000000000
    }
  }
};

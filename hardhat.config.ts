import {HardhatUserConfig} from 'hardhat/types';

import 'hardhat-deploy';
import '@nomiclabs/hardhat-ethers';
import 'hardhat-deploy-ethers';
import '@typechain/hardhat';
import 'solidity-coverage';
import {task} from "hardhat/config";
import "hardhat-contract-sizer";
import 'solidity-docgen';

import "./tasks/setups";
import "./tasks/setRemote";

const secret = require("./secret.json");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners()

    for (const account of accounts) {
        console.log(account.address);
    }
});

const config: HardhatUserConfig = {
    solidity: {
        compilers: [
            {
                version: '0.8.17',
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 2000,
                    },
                },
            },
        ],
    },
    namedAccounts: {
        owner: 0,
        user1: 1,
        user2: 2
    },
    networks: {
        goerli: {
            url: secret.url_goerli,
            accounts: [secret.key_dev]
        },
    },
    contractSizer: {
        runOnCompile: false
    },
    docgen: {
        pages: 'files',
        exclude: [],
        templates: 'docgen'
    }
}
export default config;


const path = require("path")
const fs = require("fs")

let lzChainIds: { [key: string]: number } = {
    "ethereum": 101,
    "bsc": 102,
    "avalanche": 106,
    "polygon": 109,
    "arbitrum": 110,
    "optimism": 111,
    "fantom": 112,
    "linea_mainnet": 183,
    "base_mainnet": 184,

    "goerli": 10121,
    "bsc_testnet": 10102,
    "fuji": 10106,
    "mumbai": 10109,
    "arbitrum_goerli": 10143,
    "optimism_goerli": 10132,
    "fantom_testnet": 10112,
    "meter_testnet": 10156,
    "linea_testnet": 10157,
    "zksync_testnet": 10165,

    "local_chain1": 31337,
    "local_chain2": 31338,
}

export function getLzChainIdByNetworkName(networkName: string) {
    let id = lzChainIds[networkName];
    if (id == null || id == 0)
        throw new Error("chainId not found on chain " + networkName);
    return id;
}

export function getDeploymentAddresses(networkName) {
    const PROJECT_ROOT = path.resolve(__dirname, "..")
    const DEPLOYMENT_PATH = path.resolve(PROJECT_ROOT, "deployments")

    let folderName = networkName
    if (networkName === "hardhat") {
        folderName = "localhost"
    }

    const networkFolderName = fs.readdirSync(DEPLOYMENT_PATH).filter((f) => f === folderName)[0]
    if (networkFolderName === undefined) {
        throw new Error("missing deployment files for endpoint " + folderName)
    }

    let rtnAddresses = {}
    const networkFolderPath = path.resolve(DEPLOYMENT_PATH, folderName)
    const files = fs.readdirSync(networkFolderPath).filter((f) => f.includes(".json"))
    files.forEach((file) => {
        const filepath = path.resolve(networkFolderPath, file)
        const data = JSON.parse(fs.readFileSync(filepath))
        const contractName = file.split(".")[0]
        rtnAddresses[contractName] = data.address
    })

    return rtnAddresses
}
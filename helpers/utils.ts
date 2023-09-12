import {deployments, ethers, run} from "hardhat";
import {CHAIN_ID_LOCAL} from "./constants";

export async function deployFixture() {

    await deployments.fixture();

    const users = {
        owner: await ethers.getNamedSigner("owner"),
        user1: await ethers.getNamedSigner("user1"),
        user2: await ethers.getNamedSigner("user2")
    }

    const contracts = {
        factory: await ethers.getContract("OCPFactory"),
        factory2: await ethers.getContract("OCPFactory2"),
        router: await ethers.getContract("OCPRouter")
    }

    return {...users, ...contracts};
}

export async function deployNew(name: any, args: any) {
    const contractFactory = await ethers.getContractFactory(name)
    return await contractFactory.deploy(...args);
}

export async function getLzEndPointByChainId(chainId: any) {
    let endpoint: any;
    if (chainId == CHAIN_ID_LOCAL) {
        endpoint = await deployNew("LZEndpoint", [chainId]);
    }
    if (!endpoint)
        throw new Error("lzEndpoint not found on network " + chainId);
    return endpoint.address;
}

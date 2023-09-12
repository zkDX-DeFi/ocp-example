import {DeployFunction} from 'hardhat-deploy/types';
import {getLzEndPointByChainId} from "../helpers/utils";

const func: DeployFunction = async function ({deployments, getNamedAccounts, network, getChainId}) {

    const {deploy, get} = deployments;
    const {owner} = await getNamedAccounts();
    let chainId = await getChainId();

    console.log(`>> deploying OCPBridge...`);

    let OCPRouter = await get("OCPRouter");
    let lzEndpoint = await getLzEndPointByChainId(chainId);
    await deploy('OCPBridge', {
        from: owner,
        args: [OCPRouter.address, lzEndpoint],
        log: true
    });

};
export default func;
func.dependencies = ['router'];
func.tags = ['bridge'];

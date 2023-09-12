import {DeployFunction} from 'hardhat-deploy/types';
import {CHAIN_ID_LOCAL2} from "../../helpers/constants";
import {deployNew} from "../../helpers/utils";
import {run} from "hardhat";


const func: DeployFunction = async function ({deployments, getNamedAccounts, network, getChainId}) {

    const {deploy, execute} = deployments;
    const {owner} = await getNamedAccounts();

    console.log(`>> deploying same on local chain 2 (test only) ...`);

    let OCPFactory2 = await deploy('OCPFactory2', {
        contract: 'OCPFactory',
        from: owner,
        args: [],
        log: true
    });

    const OCPRouter2 = await deploy('OCPRouter2', {
        contract: 'OCPRouter',
        from: owner,
        args: [OCPFactory2.address],
        log: true
    });

    await execute('OCPFactory2', {from: owner, log: true}, "updateRouter", OCPRouter2.address);

    let lzEndpoint = await deployNew("LZEndpoint", [CHAIN_ID_LOCAL2]);
    await deploy('OCPBridge2', {
        contract: 'OCPBridge',
        from: owner,
        args: [OCPRouter2.address, lzEndpoint.address],
        log: true
    });

    await run("setup-local");
};
export default func;
func.tags = ['localChain2'];

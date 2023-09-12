import {DeployFunction} from 'hardhat-deploy/types';


const func: DeployFunction = async function ({deployments, getNamedAccounts, network, getChainId}) {

    const {deploy, get, execute} = deployments;
    const {owner} = await getNamedAccounts();

    console.log(`>> deploying OCPRouter...`);

    const OCPFactory = await get("OCPFactory");

    const OCPRouter = await deploy('OCPRouter', {
        from: owner,
        args: [OCPFactory.address],
        log: true
    });

    await execute('OCPFactory', {from: owner, log: true}, "updateRouter", OCPRouter.address);
};
export default func;
func.dependencies = ['factory'];
func.tags = ['router'];

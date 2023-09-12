import {DeployFunction} from 'hardhat-deploy/types';


const func: DeployFunction = async function ({deployments, getNamedAccounts, network, getChainId}) {

    const {deploy} = deployments;
    const {owner} = await getNamedAccounts();

    console.log(`>> deploying OCPFactory...`);
    await deploy('OCPFactory', {
        from: owner,
        args: [],
        log: true
    });

};
export default func;
func.tags = ['factory'];

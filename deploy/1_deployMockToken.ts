import {DeployFunction} from 'hardhat-deploy/types';
import {AddressZero} from "../helpers/constants";


const func: DeployFunction = async function ({deployments, getNamedAccounts, network, getChainId}) {

    const {deploy} = deployments;
    const {owner} = await getNamedAccounts();

    console.log(`>> deploying MockToken...`);
    await deploy('MTA', {
        from: owner,
        args: [],
        log: true,
        contract: 'MockToken'
    });

    await deploy('MTB', {
        from: owner,
        args: [],
        log: true,
        contract: 'MockToken'
    });

};
export default func;
func.tags = ['factory'];

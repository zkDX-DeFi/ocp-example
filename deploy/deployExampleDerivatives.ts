import {DeployFunction} from 'hardhat-deploy/types';
import {AddressZero} from "../helpers/constants";


const func: DeployFunction = async function ({deployments, getNamedAccounts, network, getChainId}) {

    const {deploy} = deployments;
    const {owner} = await getNamedAccounts();

    console.log(`>> deploying ExampleDerivatives...`);
    await deploy('ExampleDerivatives', {
        from: owner,
        args: [AddressZero,0,AddressZero],
        log: true
    });

};
export default func;
func.tags = ['factory'];

import {task} from "hardhat/config";
import {getDeploymentAddresses, getLzChainIdByNetworkName} from "../helpers/lzUtils";

task("setRemote").addParam("targetContract").addParam("targetNetwork").setAction(async function (taskArgs, hre) {

    let targetContract = taskArgs.targetContract;
    let targetNetwork = taskArgs.targetNetwork;

    // get local and remote
    let localContract, remoteAddress;
    if (targetNetwork == "local_chain1") {
        localContract = await hre.ethers.getContract(targetContract);
        remoteAddress = (await hre.ethers.getContract(targetContract + "2")).address;
    } else if (targetNetwork == "local_chain2") {
        localContract = await hre.ethers.getContract(targetContract + "2");
        remoteAddress = (await hre.ethers.getContract(targetContract)).address;
    } else {
        localContract = await hre.ethers.getContract(targetContract);
        remoteAddress = getDeploymentAddresses(targetNetwork)[targetContract]
    }

    // set trusted remote
    let remoteChainId = getLzChainIdByNetworkName(targetNetwork);
    let remoteAndLocal = hre.ethers.utils.solidityPack(['address', 'address'], [remoteAddress, localContract.address])
    let isTrustedRemoteSet = await localContract.isTrustedRemote(remoteChainId, remoteAndLocal);
    if (!isTrustedRemoteSet) {
        try {
            await (await localContract.setTrustedRemote(remoteChainId, remoteAndLocal)).wait()
            console.log(`✅ [${hre.network.name}] setTrustedRemote(${remoteChainId}, ${remoteAndLocal})`)
        } catch (e) {
            if (e.error.message.includes("The chainId + address is already trusted")) {
                console.log("*source already set*")
            } else {
                console.log(`❌ [${hre.network.name}] setTrustedRemote(${remoteChainId}, ${remoteAndLocal})`)
            }
        }
    } else {
        console.log("*source already set*")
    }

});

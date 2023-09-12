import {task} from "hardhat/config";

task("setup-local",).setAction(async function (taskArgs, hre) {
    await hre.run("setRemote", {targetContract: "OCPBridge", targetNetwork: "local_chain1"});
    await hre.run("setRemote", {targetContract: "OCPBridge", targetNetwork: "local_chain2"});
});


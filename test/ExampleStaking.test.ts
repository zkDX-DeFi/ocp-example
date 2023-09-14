import {deployFixture, deployNew} from "../helpers/utils";
import {expect} from "chai";
import {ethers} from "hardhat";
import {AddressZero} from "../helpers/constants";
import {OCP_FACTORY_ROUTER_INVALID, OWNABLE_CALLER_IS_NOT_THE_OWNER} from "../helpers/errors";

describe("OCPFactory", async () => {

    let owner: any,
        user1: any,
        usdc: any,
        exampleStaking: any,
        exampleOUSD: any,
        exampleDerivatives: any,
        exampleDEX: any;

    beforeEach(async () => {
        ({owner, user1, exampleStaking, exampleOUSD, exampleDerivatives, exampleDEX} = await deployFixture());
        usdc = await deployNew("Token", ["USDC", 18, 0, 0, 0]);
    });

    it("ExampleStaking", async () => {
        const e = exampleStaking;
        expect(e.address).not.eq(AddressZero);
        console.log(`oStaking: ${e.address}`);
    });

    it("ExampleOUSD", async () => {
        const e = exampleOUSD;
        expect(e.address).not.eq(AddressZero);
        console.log(`oUSD: ${e.address}`);
    });

    it("ExampleDerivatives", async () => {
        const e = exampleDerivatives;
        expect(e.address).not.eq(AddressZero);
        console.log(`oDerivatives: ${e.address}`);
    });

    it("ExampleDEX", async () => {
        const e = exampleDEX;
        expect(e.address).not.eq(AddressZero);

        expect(await e.uniswapRouter()).eq(AddressZero);
        expect(await e.router()).eq(AddressZero);
        expect(await e.remoteChainId()).eq(0);
    });
});

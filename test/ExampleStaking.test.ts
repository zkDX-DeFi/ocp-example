import {deployFixture, deployNew} from "../helpers/utils";
import {expect} from "chai";
import {ethers} from "hardhat";
import {AddressZero} from "../helpers/constants";
import {OCP_FACTORY_ROUTER_INVALID, OWNABLE_CALLER_IS_NOT_THE_OWNER} from "../helpers/errors";
import {formatEther, parseEther} from "ethers/lib/utils";

describe("OCPFactory", async () => {

    let owner: any,
        user1: any,
        usdc: any,
        mta: any,
        mtb: any,
        exampleStaking: any,
        exampleOUSD: any,
        exampleDerivatives: any,
        exampleDEX: any,
        mockFactory: any;

    beforeEach(async () => {
        ({owner, user1, exampleStaking, exampleOUSD, exampleDerivatives, exampleDEX,mta,mtb, mockFactory} = await deployFixture());
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

    it("MockToken", async () => {
        const t = mta;
        console.log(`${await t.name()}`);
        console.log(`${await t.symbol()}`);
        console.log(`${formatEther(await t.totalSupply())}`);

        expect(await t.name()).eq("MockToken");
        expect(await t.symbol()).eq("MT");
        expect(await t.decimals()).eq(18);
        expect(await t.totalSupply()).eq(parseEther("10000"));


        await t.transfer(user1.address, parseEther("1000"));
        expect(await t.balanceOf(user1.address)).eq(parseEther("1000"));
        expect(await t.totalSupply()).eq(parseEther("10000"));
    });

    it("MTA+MTB", async () => {
        const t = mta;
        const t2 = mtb;

        await t.transfer(user1.address, parseEther("1000"));
        await t2.transfer(user1.address, parseEther("1000"));

        expect(await t.balanceOf(user1.address)).eq(parseEther("1000"));
        expect(await t2.balanceOf(user1.address)).eq(parseEther("1000"));
    });

    it("exampleFactory", async () => {
        const f = mockFactory;
        const t0 = mta;
        const t1 = mtb;
        expect(await f.feeTo()).eq(AddressZero);
        expect(await f.allPairsLength()).eq(0);
        await f.setFeeTo(user1.address);
        expect(await f.feeTo()).eq(user1.address);

        await f.createPair(t0.address,t1.address);
    });
});

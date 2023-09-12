import {deployFixture, deployNew} from "../helpers/utils";
import {expect} from "chai";
import {ethers} from "hardhat";
import {AddressZero} from "../helpers/constants";
import {OCP_FACTORY_ROUTER_INVALID, OWNABLE_CALLER_IS_NOT_THE_OWNER} from "../helpers/errors";

describe("OCPFactory", async () => {

    let owner: any,
        user1: any,
        usdc: any,
        factory: any,
        router: any;

    beforeEach(async () => {
        ({owner, user1, factory, router} = await deployFixture());
        usdc = await deployNew("Token", ["USDC", 18, 0, 0, 0]);
    });

    it("create pool suc", async () => {
        expect(await factory.getPool(usdc.address)).to.equal(AddressZero);
        await factory.connect(user1).createPool(usdc.address, 6);
        let poolAddr = await factory.getPool(usdc.address);
        expect(poolAddr).to.not.equal(AddressZero);
        let pool = await ethers.getContractAt("OCPPool", poolAddr);
        expect(await pool.token()).to.equal(usdc.address);
        expect(await pool.sharedDecimals()).to.eq(6);
        expect(await pool.convertRate()).to.equal(10 ** 12);
    });

    it("test Factory.func => VARIABLES", async () => {
        const f = factory;
        const r = router;
        expect(f.address).not.eq(AddressZero);
        expect(await f.getPool(usdc.address)).to.equal(AddressZero);
        expect(await f.getPool(AddressZero)).to.equal(AddressZero);
        expect(await f.router()).not.eq(AddressZero);
        expect(await f.router()).eq(r.address);

        let token = usdc;
        const user = user1;

        expect(await f.getPool(token.address)).to.equal(AddressZero);
        await f.connect(user).createPool(token.address, 6);
        expect(await f.getPool(token.address)).to.not.equal(AddressZero);

        const dai = await deployNew("Token", ["DAI", 18, 0, 0, 0]);
        token = dai;

        expect(await f.getPool(token.address)).to.equal(AddressZero);
        await f.connect(user).createPool(token.address, 6);
        expect(await f.getPool(token.address)).to.not.equal(AddressZero);
        expect(await f.getPool(token.address)).to.not.equal(await f.getPool(usdc.address));
    });

    it("test Factory.func => updateRouter   ", async () => {
        const f = factory;
        const r = router;
        const targetAddress = user1.address;
        const targetOP = user1;

        expect(await f.router()).eq(r.address);
        await f.updateRouter(targetAddress);
        expect(await f.router()).eq(targetAddress);

        await expect(f.updateRouter(AddressZero)).to.be.revertedWith(OCP_FACTORY_ROUTER_INVALID);
        await expect(f.connect(targetOP).updateRouter(targetAddress)).to.be.revertedWith(OWNABLE_CALLER_IS_NOT_THE_OWNER);
    });

    it("test Router.func => VARIABLES", async () => {
        const r = router;
        const f = factory;

        expect(r.address).not.eq(AddressZero);
        expect(await r.factory()).eq(f.address);
        expect(await r.defaultSharedDecimals()).eq(8);

        const targetOP = user1;
        expect(await r.mintFeeBasisPoint()).eq(3);
        await expect(r.connect(targetOP).updateMintFeeBasisPoint(5)).to.be.revertedWith(OWNABLE_CALLER_IS_NOT_THE_OWNER);
        await r.updateMintFeeBasisPoint(5);
        expect(await r.mintFeeBasisPoint()).eq(5);
    });


    it("test OCPPool.func => VARIABLES", async () => {
        const f = factory;
        const token = usdc;
        const targetOP = user1;
        const targetDecimals = 6;
        const targetConvertRate = 10 ** 12;

        await f.connect(targetOP).createPool(token.address, targetDecimals);
        const usdcPool = await f.getPool(token.address);

        // @ts-ignore
        const pool = await ethers.getContractAt<OCPPool>("OCPPool", usdcPool);
        expect(await pool.token()).eq(token.address);
        expect(await pool.sharedDecimals()).eq(targetDecimals);
        expect(await pool.convertRate()).eq(targetConvertRate);
    });
});

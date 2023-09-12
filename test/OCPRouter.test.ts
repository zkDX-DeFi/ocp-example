import {deployFixture, deployNew} from "../helpers/utils";
import {expect} from "chai";
import {ethers} from "hardhat";
import {AddressZero} from "../helpers/constants";
import {parseEther} from "ethers/lib/utils";

describe("OCPRouter", async () => {

    let owner: any,
        user1: any,
        user2: any,
        usdc: any,
        factory: any,
        router: any;

    beforeEach(async () => {
        ({owner, user1, user2, factory, router} = await deployFixture());
        usdc = await deployNew("Token", ["USDC", 18, 0, 0, 0]);
    });

    it("omniMint create pool", async () => {
        expect(await factory.getPool(usdc.address)).to.equal(AddressZero);
        let amountIn = parseEther("1000");
        await usdc.mint(user1.address, amountIn);
        await usdc.connect(user1).approve(router.address, amountIn);

        // omni mint
        await router.connect(user1).omniMint(1, usdc.address, amountIn, user2.address, "0x");

        // check pool
        let poolAddr = await factory.getPool(usdc.address);
        expect(poolAddr).to.not.equal(AddressZero);
        let pool = await ethers.getContractAt("OCPPool", poolAddr);
        expect(await pool.token()).to.equal(usdc.address);
        expect(await pool.sharedDecimals()).to.eq(8);
        expect(await pool.convertRate()).to.equal(10 ** 10);
    });
});

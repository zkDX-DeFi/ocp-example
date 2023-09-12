import {deployFixture, deployNew} from "../helpers/utils";
import {expect} from "chai";
import {ethers} from "hardhat";
import {AddressZero} from "../helpers/constants";
import {OCP_FACTORY_ROUTER_INVALID, OWNABLE_CALLER_IS_NOT_THE_OWNER} from "../helpers/errors";

describe("OCPFactory", async () => {

    let owner: any,
        user1: any,
        usdc: any,
        exampleStaking: any;

    beforeEach(async () => {
        ({owner, user1, exampleStaking} = await deployFixture());
        usdc = await deployNew("Token", ["USDC", 18, 0, 0, 0]);
    });

    it("ExampleStaking", async () => {
        const e = exampleStaking;
        expect(e.address).not.eq(AddressZero);
        console.log(`${e.address}`);
    });
});

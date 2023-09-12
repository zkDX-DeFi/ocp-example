// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@ocplabs/contracts/interfaces/IOCPRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
    * @title ExampleStaking
    * @author Muller
    * @dev ExampleStaking is used to show how to use the IOCPRouter.

    * ExampleStaking will set the `router`, `remoteChainId`, and `depositToken` variables in the constructor.
    * And these variables will be immutable.
    * Staking will use the `router` to mint and redeem OmniTokens for the `depositToken`.
    * Staking will use the `remoteChainId` to mint and redeem OmniTokens on the remote chain.

    * The `stakingDepositCall` function is used to deposit tokens into the pool.
    * The `stakingDepositCall` function will call the `omniMint` function on the router.

    * The `withdraw` function is used to withdraw tokens from the pool.
    * The `withdraw` function will call the `omniRedeem` function on the router.

    * The `claimRewards` function is used to claim rewards from the pool.
    * The `claimRewards` function will call the `omniRedeem` function on the router.
    * The `claimRewards` function will call the `omniMint` function on the router for the rewards.

    * The IOCPRouter is used to mint and redeem OmniTokens.
    * OmniTokens are minted when tokens are deposited into the pool.
    * OmniTokens are redeemed when tokens are withdrawn from the pool.
*/
contract ExampleStaking {
    IOCPRouter public immutable router;
    IERC20 public immutable depositToken;
    uint16 public immutable remoteChainId;

    /**
        * @dev constructor is used to set the `router`, `remoteChainId`, and `depositToken` variables.

        * The `router` variable is the address of the OCP Router.
        * The `remoteChainId` variable is the chainId of the remote chain.
        * The `depositToken` variable is the address of the token to deposit.
        * The `router`, `remoteChainId`, and `depositToken` variables are immutable.

        * @param _router The address of the OCP Router.
        * @param _remoteChainId The chainId of the remote chain.
        * @param _depositToken The address of the token to deposit.
    */
    constructor (
        address _router,
        uint16 _remoteChainId,
        address _depositToken
    ) {
        router = IOCPRouter(_router);
        remoteChainId = _remoteChainId;
        depositToken = IERC20(_depositToken);
    }

    /**
        * @dev stakingDepositCall is used to deposit tokens into the pool.
        * The `stakingDepositCall` function will call the `omniMint` function on the router.
        * The `omniMint` function will mint OmniTokens for the `depositToken` to the address specified in the `omniMint` function.
        * The `omniMint` function will mint OmniTokens for the `depositToken` using the `convertRate` function.

        * @param _amountIn The amount of tokens to deposit.
    */
    function stakingDepositCall(uint256 _amountIn) external {
        router.omniMint(
            remoteChainId,
            address(depositToken),
            _amountIn,
            address(this),
            abi.encodeWithSelector(this.stakingDepositCall.selector, _amountIn)
        );
    }

    function withdraw(uint256 _amountIn) external {
        // todo: add code
    }

    function claimRewards() external {
        // todo: add code
    }
}

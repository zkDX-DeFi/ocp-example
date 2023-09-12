// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
/**
    * @title IOCPRouter
    * @author Muller
    * @dev Interface of the OCP Router.

    * IOCPRouter is used to mint and redeem OmniTokens.
    * OmniTokens are minted when tokens are deposited into the pool.
    * OmniTokens are redeemed when tokens are withdrawn from the pool.
    * The OmniTokens are minted and redeemed at a 1:1 ratio with the underlying tokens.
    * The OmniTokens are minted and redeemed using the `omniMint` and `omniRedeem` functions.

    * omniMint is called when tokens are deposited into the pool.
    * omniRedeem is called when tokens are withdrawn from the pool.
    * The `omniMint` and `omniRedeem` functions are called by the router.
    * The router will call `omniMint` and `omniRedeem` when tokens are deposited/withdrawn.
    * The `omniMint` and `omniRedeem` functions will call the `convertRate` function to get the conversion rate.

    * The `omniMintCall` and `omniRedeemCall` functions are called by the router.
    * The router will call `omniMintCall` and `omniRedeemCall` when tokens are deposited/withdrawn.
    * The `omniMintCall` and `omniRedeemCall` functions will call the `convertRate` function to get the conversion rate.

    * The `convertRate` function is used to convert the amount of tokens to mint/redeem to the correct amount of OmniTokens.
    * The `convertRate` function is implemented in the OCP Pool to allow for different conversion rates.
    * The `convertRate` function is used in the `omniMint` and `omniRedeem` functions.
    * The `convertRate` function is used in the `omniMintCall` and `omniRedeemCall` functions.

    * The `updateMintFeeBasisPoint` function is used to update the mint fee basis point.
    * The `mintFeeBasisPoint` is used to calculate the mint fee.
    * The mint fee is calculated as `amountIn * mintFeeBasisPoint / 10000`.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniMint` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniMintCall` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniRedeem` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniRedeemCall` function.
*/
interface IOCPRouter {
    /**
        * @dev omniMint is called when tokens are deposited into the pool.
        * The OmniTokens are minted at a 1:1 ratio with the underlying tokens.
        * The OmniTokens are minted using the `omniMint` function.
        * The OmniTokens are minted using the `convertRate` function.
        * The OmniTokens are minted to the address specified in the `omniMint` function.
        * The `omniMint` function is called by the router.
        * The router will call `omniMint` when tokens are deposited.

        * @param _remoteChainId The chainId of the remote chain.
        * @param _token The address of the token to mint OmniTokens for.
        * @param _amountIn The amount of tokens to mint OmniTokens for.
        * @param _to The address to mint the OmniTokens to.
        * @param payload The payload to send to the remote chain.
    */
    function omniMint(
        uint16 _remoteChainId,
        address _token,
        uint256 _amountIn,
        address _to,
        bytes memory payload
    ) external;

    /**
        * @dev omniRedeem is called when tokens are withdrawn from the pool.
        * The OmniTokens are redeemed at a 1:1 ratio with the underlying tokens.
        * The OmniTokens are redeemed using the `omniRedeem` function.
        * The OmniTokens are redeemed using the `convertRate` function.
        * The OmniTokens are redeemed to the address specified in the `omniRedeem` function.
        * The `omniRedeem` function is called by the router.
        * The router will call `omniRedeem` when tokens are withdrawn.

        * @param _remoteChainId The chainId of the remote chain.
        * @param _token The address of the token to redeem OmniTokens for.
        * @param _amountIn The amount of tokens to redeem OmniTokens for.
        * @param _to The address to redeem the OmniTokens to.
        * @param payload The payload to send to the remote chain.
    */
    function omniRedeem(
        uint16 _remoteChainId,
        address _token,
        uint256 _amountIn,
        address _to,
        bytes memory payload
    ) external;
}

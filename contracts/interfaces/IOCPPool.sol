// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
/**
    * @title IOCPPool
    * @author Muller
    * @dev Interface of the OCP Pool.


    * IOCPPool is used to mint and redeem OmniTokens.
    * OmniTokens are minted when tokens are deposited into the pool.
    * OmniTokens are redeemed when tokens are withdrawn from the pool.
    * The OmniTokens are minted and redeemed at a 1:1 ratio with the underlying tokens.
    * The OmniTokens are minted and redeemed using the `omniMint` and `omniRedeem` functions.

    * The `convertRate` function is used to convert the amount of tokens to mint/redeem to the correct amount of OmniTokens.
    * The `convertRate` function is implemented in the OCP Pool to allow for different conversion rates.

    * The `omniMint` and `omniRedeem` functions are called by the router.
    * The router will call `omniMint` and `omniRedeem` when tokens are deposited/withdrawn.
    * The `omniMint` and `omniRedeem` functions will call the `convertRate` function to get the conversion rate.

    * The `omniMintCall` and `omniRedeemCall` functions are called by the router.
    * The router will call `omniMintCall` and `omniRedeemCall` when tokens are deposited/withdrawn.
    * The `omniMintCall` and `omniRedeemCall` functions will call the `convertRate` function to get the conversion rate.
*/
interface IOCPPool {
    /**
        * @dev Returns the conversion rate for the pool.
        * The conversion rate is used to convert the amount of tokens to mint/redeem to the correct amount of OmniTokens.
        * The conversion rate is implemented in the OCP Pool to allow for different conversion rates.
        * The conversion rate is used in the `omniMint` and `omniRedeem` functions.
        * The conversion rate is used in the `omniMintCall` and `omniRedeemCall` functions.
        * The conversion rate is used in the `convertRate` function.

        * @return convertRate The conversion rate for the pool.

    */
    function convertRate() external view returns (uint256);
    /**
        * @dev Mints OmniTokens for the given amount of tokens.
        * The OmniTokens are minted at a 1:1 ratio with the underlying tokens.
        * The OmniTokens are minted using the `omniMint` function.
        * The OmniTokens are minted using the `convertRate` function.
        * The OmniTokens are minted to the address specified in the `omniMint` function.

        * @param _remoteChainId The chainId of the remote chain.
        * @param _amountIn The amount of tokens to mint OmniTokens for.
        * @param _to The address to mint the OmniTokens to.
    */
    function omniMint(
        uint256 _remoteChainId,
        uint256 _amountIn,
        address _to
    ) external;

    /**
        * @dev Mints OmniTokens for the given amount of tokens.
        * The OmniTokens are minted at a 1:1 ratio with the underlying tokens.
        * The OmniTokens are minted using the `omniMintCall` function.
        * The OmniTokens are minted using the `convertRate` function.
        * The OmniTokens are minted to the address specified in the `omniMintCall` function.
        * The `omniMintCall` function will call the `omniMint` function.

        * @param _remoteChainId The chainId of the remote chain.
        * @param _amountIn The amount of tokens to mint OmniTokens for.
        * @param _to The address to mint the OmniTokens to.
        * @param payload The payload to pass to the `omniMint` function.
    */
    function omniMintCall(
        uint256 _remoteChainId,
        uint256 _amountIn,
        address _to,
        bytes memory payload
    ) external;

    /**
        * @dev Redeems OmniTokens for the given amount of tokens.
        * The OmniTokens are redeemed at a 1:1 ratio with the underlying tokens.
        * The OmniTokens are redeemed using the `omniRedeem` function.
        * The OmniTokens are redeemed using the `convertRate` function.
        * The OmniTokens are redeemed to the address specified in the `omniRedeem` function.

        * @param _remoteChainId The chainId of the remote chain.
        * @param _amountIn The amount of tokens to redeem OmniTokens for.
        * @param _to The address to redeem the tokens to.
    */
    function omniRedeem(
        uint256 _remoteChainId,
        uint256 _amountIn,
        address _to
    ) external;

    /**
        * @dev Redeems OmniTokens for the given amount of tokens.
        * The OmniTokens are redeemed at a 1:1 ratio with the underlying tokens.
        * The OmniTokens are redeemed using the `omniRedeemCall` function.
        * The OmniTokens are redeemed using the `convertRate` function.
        * The OmniTokens are redeemed to the address specified in the `omniRedeemCall` function.
        * The `omniRedeemCall` function will call the `omniRedeem` function.

        * @param _remoteChainId The chainId of the remote chain.
        * @param _amountIn The amount of tokens to redeem OmniTokens for.
        * @param _to The address to redeem the tokens to.
        * @param payload The payload to pass to the `omniRedeem` function.
    */
    function omniRedeemCall(
        uint256 _remoteChainId,
        uint256 _amountIn,
        address _to,
        bytes memory payload
    ) external;

}

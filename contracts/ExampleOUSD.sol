// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@ocplabs/contracts/interfaces/IOCPRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
    @title ExampleOUSD
    @author Muller
    @dev ExampleOUSD is used to show how to use the IOCPRouter.

    * ExampleOUSD will set the `router`, `remoteChainId`, and `swapToken` variables in the constructor.
    * And these variables will be immutable.
    * ExampleOUSD will use the `router` to mint and redeem OmniTokens for the `swapToken`.
    * ExampleOUSD will use the `remoteChainId` to mint and redeem OmniTokens on the remote chain.

    * The `swapTokenToOUSD` function is used to swap tokens for OUSD.
    * The `swapTokenToOUSD` function will call the `omniMint` function on the router.

    * The `swapOUSDToToken` function is used to swap OUSD for tokens.
    * The `swapOUSDToToken` function will call the `omniRedeem` function on the router.
*/

contract ExampleOUSD {
    IOCPRouter public immutable router;
    IERC20 public immutable swapToken;
    uint16 public immutable remoteChainId;

    /**
        @dev constructor is used to set the `router`, `remoteChainId`, and `swapToken` variables.
        * The `router` variable is the address of the OCP Router.
        * The `remoteChainId` variable is the chainId of the remote chain.
        * The `swapToken` variable is the address of the token to swap.
        * The `router`, `remoteChainId`, and `swapToken` variables are immutable.

        @param _router The address of the OCP Router.
        @param _remoteChainId The chainId of the remote chain.
        @param _swapToken The address of the token to swap.
    */
    constructor (
        address _router,
        uint16 _remoteChainId,
        address _swapToken
    ) {
        router = IOCPRouter(_router);
        remoteChainId = _remoteChainId;
        swapToken = IERC20(_swapToken);
    }

    /**
        @dev swapTokenToOUSD is used to swap tokens for OUSD.

        @param from The address to swap tokens from.
        @param to The address to mint OUSD to.
        @param amountIn The amount of tokens to swap.
        @param payload The payload to send to the remote chain.
    */
    event SwapTokenToOUSD(address indexed from, address indexed to, uint256 amountIn, bytes payload);
    event SwapOUSDToToken(address indexed from, address indexed to, uint256 amountIn, bytes payload);

    /**
        @dev swapTokenToOUSD is used to swap tokens for OUSD.

        * The `swapTokenToOUSD` function will call the `omniMint` function on the router.
        * The `omniMint` function will mint OUSD for the `swapToken` to the address specified in the `omniMint` function.
        * The `omniMint` function will mint OUSD for the `swapToken` using the `convertRate` function.
        * Will emit a `SwapTokenToOUSD` event.

        * @param _amountIn The amount of tokens to swap.
        * @param _to The address to mint OUSD to.
    */
    function swapTokenToOUSD(uint256 _amountIn, address _to) external {
        swapToken.transferFrom(msg.sender, address(this), _amountIn);
        swapToken.approve(address(router), _amountIn);

        bytes memory _payload;
        _payload = abi.encodePacked(_amountIn, abi.encode(_to));
        router.omniMint(remoteChainId, address(swapToken), _amountIn, _to, _payload);

        emit SwapTokenToOUSD(msg.sender, _to, _amountIn, _payload);
    }

    /**
        @dev swapOUSDToToken is used to swap OUSD for tokens.

        * The `swapOUSDToToken` function will call the `omniRedeem` function on the router.
        * The `omniRedeem` function will redeem OUSD for the `swapToken` to the address specified in the `omniRedeem` function.
        * The `omniRedeem` function will redeem OUSD for the `swapToken` using the `convertRate` function.
        * Will emit a `SwapOUSDToToken` event.

        * @param _amountIn The amount of OUSD to swap.
        * @param _to The address to redeem the `swapToken` to.
    */
    function swapOUSDToToken(uint256 _amountIn, address _to) external {
        swapToken.transferFrom(msg.sender, address(this), _amountIn);
        swapToken.approve(address(router), _amountIn);

        bytes memory _payload;
        _payload = abi.encodePacked(_amountIn, abi.encode(_to));
        router.omniRedeem(remoteChainId, address(swapToken), _amountIn, _to, _payload);
    }
}

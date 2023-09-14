// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@ocplabs/contracts/interfaces/IOCPRouter.sol";

contract ExampleDEX {
    IUniswapV2Router02 public immutable uniswapRouter;
    IOCPRouter public immutable router;
    uint16 public immutable remoteChainId;

    constructor (address _uniswapRouter, address _router, uint16 _remoteChainId) {
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
        router = IOCPRouter(_router);
        remoteChainId   = _remoteChainId;
    }

    function omniAddLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external {
        router.omniMint(
            remoteChainId,
            tokenA,
            amountADesired,
            address(this),
            abi.encodeWithSelector(this.omniAddLiquidity.selector, tokenA, amountADesired)
        );

        router.omniMint(
            remoteChainId,
            tokenB,
            amountBDesired,
            address(this),
            abi.encodeWithSelector(this.omniAddLiquidity.selector, tokenB, amountBDesired)
        );

        uniswapRouter.addLiquidity(
            tokenA,
            tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            to,
            deadline);
    }

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external {

        router.omniRedeem(
            remoteChainId,
            tokenA,
            liquidity,
            address(this),
            abi.encodeWithSelector(this.removeLiquidity.selector, tokenA, liquidity)
        );

        router.omniRedeem(
            remoteChainId,
            tokenB,
            liquidity,
            address(this),
            abi.encodeWithSelector(this.removeLiquidity.selector, tokenB, liquidity)
        );

        uniswapRouter.removeLiquidity(
            tokenA,
            tokenB,
            liquidity,
            amountAMin,
            amountBMin,
            address(this),
            deadline);
    }
}

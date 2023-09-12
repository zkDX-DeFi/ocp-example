// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IOCPRouter.sol";
import "./interfaces/IOCPFactory.sol";
import "./interfaces/IOCPPool.sol";
import "./interfaces/IOCPBridge.sol";

/**
    * @title OCPRouter
    * @author Muller
    * @dev OCPRouter is the contract that allows users to mint and redeem OmniTokens.
    * @dev Implementation of the {IOCPRouter} interface.

    * The default value of `defaultSharedDecimals` is 8.
    * The default value of `mintFeeBasisPoint` is 3.
    * The `factory` is the address of the OCP Factory and is of type `IOCPFactory`.
    * The `factory` is set in the constructor and is immutable.

    * OmniTokens are minted when tokens are deposited into the pool.
    * OmniTokens are redeemed when tokens are withdrawn from the pool.
    * The OmniTokens are minted and redeemed at a 1:1 ratio with the underlying tokens.
    * The OmniTokens are minted and redeemed using the `omniMint` and `omniRedeem` functions.

    * omniMint is called when tokens are deposited into the pool.
    * omniRedeem is called when tokens are withdrawn from the pool.
    * The `omniMint` and `omniRedeem` functions are called by the router.
    * The router will call `omniMint` and `omniRedeem` when tokens are deposited/withdrawn.
    * The `omniMint` and `omniRedeem` functions will call the `convertRate` function to get the conversion rate.

    * The `omniMintRemote` function is called when tokens are deposited into the pool on a remote chain.
    * The `omniRedeemRemote` function is called when tokens are withdrawn from the pool on a remote chain.
    * The `omniMintRemote` and `omniRedeemRemote` functions are called by the router.
    * The router will call `omniMintRemote` and `omniRedeemRemote` when tokens are deposited/withdrawn on a remote chain.

    * The `updateMintFeeBasisPoint` function is used to update the mint fee basis point.
    * The `mintFeeBasisPoint` is used to calculate the mint fee.
    * The mint fee is calculated as `amountIn * mintFeeBasisPoint / 10000`.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniMint` ** `omniMintCall` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniRedeem` ** `omniRedeemCall` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniMintRemote` ** `omniMintRemoteCall` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniRedeemRemote` ** `omniRedeemRemoteCall` function.
*/

contract OCPRouter is IOCPRouter, Ownable, Pausable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    IOCPFactory public factory;
    uint256 public mintFeeBasisPoint;
    uint8 public defaultSharedDecimals;

    /**
        * @dev Sets the values for {factory}.
        Sets the values for {mintFeeBasisPoint}.
        Sets the values for {defaultSharedDecimals}.

        * @param _factory The address of the OCP Factory.
        * The mint fee basis point is `3`.
        * The default shared decimals is `8`.
    */
    constructor(address _factory) {
        factory = IOCPFactory(_factory);
        mintFeeBasisPoint = 3;
        defaultSharedDecimals = 8;
    }

    /**
        * @dev `omniMint` is called when tokens are deposited into the pool.
        * The implementation of interface {IOCPRouter.omniMint} is in the {OCPRouter} contract.
        * For example, if a user deposits 100 USDT into the pool, the user will receive 100 USDT OmniTokens.
        * The OmniTokens are minted at a 1:1 ratio with the underlying tokens.

        * {_remoteChainId} must be a valid chainId.
        * {_token} must be a valid ERC20 token and must not be the zero address.
        * {_amountIn} must be greater than 0. If {_amountIn} is 100, the user will receive 100 OmniTokens.
        * {_to} must not be the zero address.
        * {payload} can be any data that the user wants to send to the remote chain.

        * {_pool} is the pool for the token. The pool is of type {IOCPPool}.
        * {_token} will be transferred from the user to the {_pool}.
        * {_omniToken} is the OmniToken for the token on the remote chain and it will be minted to the user.

        * {_needDeploy} is a boolean that indicates if the OmniToken needs to be deployed on the remote chain.
        * If {_needDeploy} is true, the OmniToken will be deployed on the remote chain.
        * If {_needDeploy} is false, the OmniToken will not be deployed on the remote chain.

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
    ) external override {
        require(_token != address(0), "OCPRouter: token invalid");
        require(_to != address(0), "OCPRouter: receiver invalid");
        require(_amountIn > 0, "OCPRouter: amountIn must be greater than 0");

        IOCPPool _pool = _getPool(_token);
        uint256 convertRate = _pool.convertRate();
        _amountIn = _amountIn * convertRate / convertRate; // to shared decimals

        IERC20(_token).safeTransferFrom(msg.sender, address(_pool), _amountIn);
        address _omniToken = factory.getOmniToken(_token, _remoteChainId);
        bool _needDeploy = _omniToken == address(0);

        // todo: make the bridge



        if (_needDeploy)
            factory.optimisticDeployed(_token, _remoteChainId);
    }

    /**
        * @dev `omniRedeem` is called when tokens are withdrawn from the pool.
        * The implementation of interface {IOCPRouter.omniRedeem} is in the {OCPRouter} contract.
        * For example, if a user withdraws 100 USDT from the pool, the user will receive 100 USDT OmniTokens.
        * The OmniTokens are redeemed at a 1:1 ratio with the underlying tokens.

        * {_remoteChainId} must be a valid chainId.
        * {_token} must be a valid ERC20 token and must not be the zero address.
        * {_amountIn} must be greater than 0. If {_amountIn} is 100, the user will receive 100 OmniTokens.
        * {_to} must not be the zero address.
        * {payload} can be any data that the user wants to send to the remote chain.

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
    ) external override {

    }

    /**
        * @dev `omniMintRemote` is called when tokens are deposited into the pool on a remote chain.
        * The implementation of interface {IOCPRouter.omniMintRemote} is in the {OCPRouter} contract.
        * For example, if a user deposits 100 USDT into the pool on a remote chain, the user will receive 100 USDT OmniTokens.
        * The OmniTokens are minted at a 1:1 ratio with the underlying tokens.

        * {_srcChainId} must be a valid chainId.
        * {_remoteChainId} must be a valid chainId.
        * {_token} must be a valid ERC20 token and must not be the zero address.
        * {_amountIn} must be greater than 0. If {_amountIn} is 100, the user will receive 100 OmniTokens.
        * {_to} must not be the zero address.
        * {payload} can be any data that the user wants to send to the remote chain.

        * @param _srcChainId The chainId of the source chain.
        * @param _remoteChainId The chainId of the remote chain.
        * @param _token The address of the token to mint OmniTokens for.
        * @param _amountIn The amount of tokens to mint OmniTokens for.
        * @param _to The address to mint the OmniTokens to.
        * @param payload The payload to send to the remote chain.
    */
    function omniMintRemote(
        uint16 _srcChainId,
        uint16 _remoteChainId,
        address _token,
        uint256 _amountIn,
        address _to,
        bytes memory payload
    ) external {

    }

    /**
    * @dev `_getPool` is an internal function that returns the pool for the token.
    * If the pool does not exist, the pool will be created.
    * The pool is of type {IOCPPool}.
    * The pool is created using the `createPool` function in the {OCPFactory} contract.
    * The pool is created using the `defaultSharedDecimals` value.
    * The pool is created using the `factory` address and is of type {IOCPFactory}.
    * The pool is created using the `_token` address and is of type {IERC20Metadata}.

    * @param _token The address of the token to get the pool for.
    * @return pool The pool for the token.
    * The pool is of type {IOCPPool}.
    */
    function _getPool(address _token) internal returns (IOCPPool pool){
        address _poolAddr = factory.getPool(_token);
        uint8 _localDecimals = IERC20Metadata(_token).decimals();
        uint8 _sharedDecimals = defaultSharedDecimals > _localDecimals ? _localDecimals : defaultSharedDecimals;
        if (_poolAddr == address(0))
            _poolAddr = factory.createPool(_token, defaultSharedDecimals);
        pool = IOCPPool(_poolAddr);
    }

    /**
    * @dev `updateMintFeeBasisPoint` is called to update the mint fee basis point.
    * The mint fee basis point is used to calculate the mint fee.
    * The mint fee is calculated as `amountIn * mintFeeBasisPoint / 10000`.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniMint` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniMintCall` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniRedeem` function.
    * The mint fee is deducted from the amount of tokens to mint OmniTokens for in the `omniRedeemCall` function.

    * {_mintFeeBasisPoint} must be less than or equal to 10000.
    * {_mintFeeBasisPoint} is the new mint fee basis point.
    * For example, {_mintFeeBasisPoint} is 3, the mint fee is 3/10000. If the user deposits 100 USDT, the user will receive 99.97 USDT OmniTokens.
    * If {_mintFeeBasisPoint} is greater than 10000, the mint fee will be invalid.
    * `updateMintFeeBasisPoint` can only be called by the owner.

    * @param _mintFeeBasisPoint The new mint fee basis point.
    */
    function updateMintFeeBasisPoint(uint256 _mintFeeBasisPoint) external onlyOwner {
        require(_mintFeeBasisPoint <= 10000, "OCPRouter: mint fee invalid");
        mintFeeBasisPoint = _mintFeeBasisPoint;
    }
}

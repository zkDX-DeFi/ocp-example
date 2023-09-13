// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@ocplabs/contracts/interfaces/IOCPRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./References/Vault.sol";

/**
    * @title ExampleDerivatives
    * @author Muller
    * @dev ExampleDerivatives is used to increase and decrease positions.

    * The `pluginIncreasePosition` function will call the `omniMint` function from the router.
    * The `pluginIncreasePosition` function will call the `increasePosition` function from the vault.

    * The `pluginIncreasePosition` function will deposit the tokens into the vault and mint the `omniDepositTokens`.
    * And the `pluginIncreasePosition` function will mint the `omniDepositTokens` to the account.
    * And increase the position size by the amount of tokens deposited.

    * The `pluginDecreasePosition` function will call the `omniRedeem` function from the router.
    * The `pluginDecreasePosition` function will call the `decreasePosition` function from the vault.

    * The `pluginDecreasePosition` function will burn the `omniDepositTokens` from the account and redeem the `omniDepositTokens` from the vault.
    * And the `pluginDecreasePosition` function will withdraw the tokens from the vault.
    * And decrease the position size by the amount of tokens withdrawn.

    * `router` is the address of the OCP Router and is immutable.

    * `remoteChainId` is the chainId of the remote chain and is immutable.

    * `depositToken` is the address of the deposit token and is immutable.

    * `vault` is the address of the vault and is immutable.
    * `vault` will be used to deposit and withdraw tokens.
    * `vault` will be used to increase and decrease positions.
    * `vault` will be used to get the position key and omniDepositToken will be deposited to the position key.
*/
contract ExampleDerivatives is ReentrancyGuard{
    IOCPRouter public immutable router;
    uint16 public immutable remoteChainId;
    IERC20 public immutable depositToken;
    Vault public immutable vault;

    /**
        * @dev constructor is used to initialize the router, remote chain id, deposit token and vault.

        * The router is the address of the OCP Router.

        * The remote chain id is the chainId of the remote chain.

        * The deposit token is the address of the deposit token.

        * The vault is the address of the vault.

        * @param _router The address of the OCP Router.
        * @param _remoteChainId The chainId of the remote chain.
        * @param _depositToken The address of the deposit token.
        * @param _vault The address of the vault.
    */
    constructor (
        address _router,
        uint16 _remoteChainId,
        address _depositToken,
        address _vault
    ) {
        router = IOCPRouter(_router);
        remoteChainId = _remoteChainId;
        depositToken = IERC20(_depositToken);
        vault = Vault(_vault);
    }

    /**
        * @dev pluginIncreasePosition is used to increase positions.

        * The `pluginIncreasePosition` function will call the `omniMint` function from the router.
        * Deposit the token into the vault and mint the `omniDepositTokens`.
        * And the `pluginIncreasePosition` function will mint the `omniDepositTokens` to the account.
        * And increase the position size by the amount of tokens deposited.

        * The `pluginIncreasePosition` function will call the `increasePosition` function from the vault.
        * The `increasePosition` function will increase the position size by the amount of tokens deposited.

        * @param _account The address of the account to increase the position for.
        * @param _collateralToken The address of the collateral token to increase the position for.
        * @param _indexToken The address of the index token to increase the position for.
        * @param _sizeDelta The amount of tokens to increase the position size by.
        * @param _amountIn The amount of tokens to deposit into the vault.
        * @param _isLong The direction of the position.
    */
    function pluginIncreasePosition(
        address _account,
        address _collateralToken,
        address _indexToken,
        uint256 _sizeDelta,
        uint256 _amountIn,
        bool _isLong
    ) external {
        router.omniMint(
            remoteChainId,
            address(depositToken),
            _amountIn,
            address(this),
            abi.encodeWithSelector(this.pluginIncreasePosition.selector, _amountIn)
        );
        vault.increasePosition(_account, _collateralToken, _indexToken, _sizeDelta, _isLong);
    }

    /**
        * @dev pluginDecreasePosition is used to decrease positions.

        * `pluginDecreasePosition` function will call the `omniRedeem` function from the router.
        * Burn the `omniDepositTokens` from the account and redeem the `omniDepositTokens` from the vault.
        * And the `pluginDecreasePosition` function will withdraw the tokens from the vault.
        * And decrease the position size by the amount of tokens withdrawn.

        * The `pluginDecreasePosition` function will call the `decreasePosition` function from the vault.
        * The `decreasePosition` function will decrease the position size by the amount of tokens withdrawn.

        * @param _account The address of the account to decrease the position for.
        * @param _collateralToken The address of the collateral token to decrease the position for.
        * @param _indexToken The address of the index token to decrease the position for.
        * @param _collateralDelta The amount of tokens to withdraw from the vault.
        * @param _sizeDelta The amount of tokens to decrease the position size by.
        * @param _amountIn The amount of tokens to burn from the account.
        * @param _isLong The direction of the position.
        * @param _receiver The address to withdraw the tokens to.
    */
    function pluginDecreasePosition(
        address _account,
        address _collateralToken,
        address _indexToken,
        uint256 _collateralDelta,
        uint256 _sizeDelta,
        uint256 _amountIn,
        bool _isLong,
        address _receiver
    ) external {
        router.omniRedeem(
            remoteChainId,
            address(depositToken),
            _amountIn,
            address(this),
            abi.encodeWithSelector(this.pluginDecreasePosition.selector, _amountIn)
        );
        vault.decreasePosition(_account, _collateralToken, _indexToken, _collateralDelta, _sizeDelta, _isLong, _receiver);
    }
}

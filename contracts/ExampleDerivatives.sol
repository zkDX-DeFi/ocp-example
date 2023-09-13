// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@ocplabs/contracts/interfaces/IOCPRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ExampleDerivatives/Vault.sol";

contract ExampleDerivatives is ReentrancyGuard{
    IOCPRouter public immutable router;
    uint16 public immutable remoteChainId;
    IERC20 public immutable depositToken;
    Vault public immutable vault;

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

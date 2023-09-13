// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
/**
    * @title Vault
    * @author Muller
    * @dev Vault is used to store the token address and shared decimals.

    * The positions is the mapping of the position key to the position.
    * The position key is the keccak256 hash of the `account`, `collateral` token, `index` token and `long/short`.
    * The position is the struct that stores the position information.

    * The {isInitialized} variable is used to ensure that the `initialize` function can only be called once.
    * The {router} variable is the address of the router.
    * The {initialize} function is used to initialize the router address.
    * The {getPositionKey} function is used to get the position key.

    * The {increasePosition} function is used to increase the position size.
    * The {decreasePosition} function is used to decrease the position size.
*/
contract Vault is ReentrancyGuard{
    mapping(bytes32 => Position) public positions;
    bool public isInitialized = false;
    address public router;

    constructor () public {
    }

    /**
        * @dev onlyRouter is used to ensure that the function can only be called by the router.

        * If the caller is not the router then revert.
    */
    modifier onlyRouter() {
        require(msg.sender == router, "Vault: caller is not the router");
        _;
    }

    /**
        * @dev constructor is used to initialize the router address.

        * The {isInitialized} variable is used to ensure that the `initialize` function can only be called once.

        * If the {isInitialized} variable is true then revert.

        * The {router} variable is the address of the router.
    */
    function initialize(address _router) external {
        require(isInitialized == false, "Vault: already initialized");
        isInitialized = true;
        router = _router;
    }

    /**
        * @dev Position is the struct that stores the position information.

        * Position struct is used for the `positions` mapping.

        * `positions` is the mapping of the position key to the position.

        * `position key` is the keccak256 hash of the `account`, `collateral` token, `index` token and `long/short`.

        * For example, the position key for the long position of 1 ETH using USDC as collateral is `keccak256(abi.encodePacked(account, usdc, eth, true))`.

        * For example, the position key for the short position of 1 ETH using USDC as collateral is `keccak256(abi.encodePacked(account, usdc, eth, false))`.

        * For example, the position key for the long position of 1 ETH using DAI as collateral is `keccak256(abi.encodePacked(account, dai, eth, true))`.

        * For example, the position key for the short position of 1 ETH using DAI as collateral is `keccak256(abi.encodePacked(account, dai, eth, false))`.

        * Position struct stores the following information:

        * @param size The size of the position.
        * @param collateral The amount of collateral in the position.
        * @param averagePrice The average price of the position.
        * @param entryFundingRate The entry funding rate of the position.
        * @param reserveAmount The reserve amount of the position.
        * @param realisedPnl The realised PnL of the position.
        * @param lastIncreasedTime The last increased time of the position.
    */
    struct Position {
        uint256 size;
        uint256 collateral;
        uint256 averagePrice;
        uint256 entryFundingRate;
        uint256 reserveAmount;
        int256 realisedPnl;
        uint256 lastIncreasedTime;
    }

    /**
        * @dev getPositionKey is used to get the position key.

        * The position key is the keccak256 hash of the `account`, `collateral` token, `index` token and `long/short`.

        * For example, the position key for the long position of 1 ETH using USDC as collateral is `keccak256(abi.encodePacked(account, usdc, eth, true))`.

        * For example, the position key for the short position of 1 ETH using USDC as collateral is `keccak256(abi.encodePacked(account, usdc, eth, false))`.

        * The result of the `getPositionKey` function is used as the key for the `positions` mapping.

        * @param _account The address of the account to get the position key for.
        * @param _collateralToken The address of the collateral token to get the position key for.
        * @param _indexToken The address of the index token to get the position key for.
        * @param _isLong The direction of the position to get the position key for.
        * @return The position key. The key is bytes32.
        * The key is the keccak256 hash of the `account`, `collateral` token, `index` token and `long/short`.
    */
    function getPositionKey(
        address _account,
        address _collateralToken,
        address _indexToken,
        bool _isLong
    ) public view returns (bytes32) {
        bytes32 key = keccak256(abi.encodePacked(_account, _collateralToken, _indexToken, _isLong));
        return key;
    }

    /**
        * @dev increasePosition is used to increase the position size.

        * The {getPositionKey} function is used to get the position key.
        * The {positions} mapping is used to get the position.
        * The {position} variable is the position.

        * The `increasePosition` is an external function.

        * The `increasePosition` function can only be called by the router.
        * And if the caller is not the router then revert.

        * nonReentrant is used to ensure that the function is not called again until the previous call has completed.
        * And nonReentrant is used to prevent reentrancy attacks.


        * @param _account The address of the account to increase the position size for.
        * @param _collateralToken The address of the collateral token to increase the position size for.
        * @param _indexToken The address of the index token to increase the position size for.
        * @param _sizeDelta The amount to increase the position size by.
        * @param _isLong The direction of the position to increase the position size for.
    */
    function increasePosition(
        address _account,
        address _collateralToken,
        address _indexToken,
        uint256 _sizeDelta,
        bool _isLong
    ) external nonReentrant onlyRouter{
        bytes32 key = getPositionKey(_account, _collateralToken, _indexToken, _isLong);
        Position storage position = positions[key];
    }

    /**
        * @dev decreasePosition is used to decrease the position size.

        * The {getPositionKey} function is used to get the position key.
        * The {positions} mapping is used to get the position.
        * The {position} variable is the position.

        * nonReentrant is used to ensure that the function is not called again until the previous call has completed.
        * And nonReentrant is used to prevent reentrancy attacks.

        * The `decreasePosition` is an external function.

        * The `decreasePosition` function is nonReentrant.
        * And if the function is called again before the previous call has completed then revert.

        * The `decreasePosition` function can only be called by the router.
        * And if the caller is not the router then revert.

        * @param _account The address of the account to decrease the position size for.
        * @param _collateralToken The address of the collateral token to decrease the position size for.
        * @param _indexToken The address of the index token to decrease the position size for.
        * @param _collateralDelta The amount of collateral to decrease the position size by.
        * @param _sizeDelta The amount to decrease the position size by.
        * @param _isLong The direction of the position to decrease the position size for.
        * @param _receiver The address to send the tokens to.

        * @return The amount of tokens sent to the receiver.
    */
    function decreasePosition(
        address _account,
        address _collateralToken,
        address _indexToken,
        uint256 _collateralDelta,
        uint256 _sizeDelta,
        bool _isLong,
        address _receiver
    ) external nonReentrant onlyRouter returns (uint256){
        bytes32 key = getPositionKey(_account, _collateralToken, _indexToken, _isLong);
        Position storage position = positions[key];

        return 0;
    }

}

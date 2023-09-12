// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

/**
    * @title OCPPool
    * @author Muller
    * @dev OCPPool is used to store the token address and shared decimals.

    * The token address is the address of the token that the pool is for.
    * The shared decimals is the number of decimals that the token and OmniTokens share.
    * The shared decimals is used to calculate the conversion rate between the token and OmniTokens.
    * The conversion rate is calculated as `10 ** (tokenDecimals - sharedDecimals)`.
    * The {initialized} variable is used to ensure that the `initialize` function can only be called once.

    * The `token` variable is the address of the token that the pool is for.
    * The `sharedDecimals` variable is the number of decimals that the token and OmniTokens share.
    * The `convertRate` variable is the conversion rate between the token and OmniTokens.
    * The `initialized` variable is used to ensure that the `initialize` function can only be called once.
    * The `initialize` function is used to initialize the token address and shared decimals.
*/

contract OCPPool {
    address public token;
    uint256 public sharedDecimals;
    uint256 public convertRate;
    bool internal initialized;

    /**
        * @dev initialize is used to initialize the token address and shared decimals.
        * The token address is the address of the token that the pool is for.
        * The shared decimals is the number of decimals that the token and OmniTokens share.
        * The shared decimals is used to calculate the conversion rate between the token and OmniTokens.
        * The conversion rate is calculated as `10 ** (tokenDecimals - sharedDecimals)`.
        * The {initialized} variable is used to ensure that the `initialize` function can only be called once.
        * The {_sharedDecimals} variable must be less than or equal to the token decimals.

        * @param _token The address of the token that the pool is for.
        * @param _sharedDecimals The number of decimals that the token and OmniTokens share.
    */
    function initialize(address _token, uint256 _sharedDecimals) external {
        require(!initialized, "OCPPool: already initialized");
        uint256 _localDecimals = IERC20Metadata(_token).decimals();
        require(_sharedDecimals <= _localDecimals, "OCPPool: shared decimals invalid");
        token = _token;
        sharedDecimals = _sharedDecimals;
        convertRate = 10 ** (_localDecimals - _sharedDecimals);
        initialized = true;
    }
}

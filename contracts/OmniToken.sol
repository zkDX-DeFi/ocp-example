// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@layerzerolabs/solidity-examples/contracts/token/oft/v2/OFTV2.sol";

/**
    * @title OmniToken
    * @author Muller
    * @notice Example of a token that inherits from OFTV2
    * @dev `OmniToken` is an ERC20 token that inherits from OFTV2.

    * It is a simple example of how to use OFTV2.
*/
contract OmniToken is OFTV2 {
    /**
        * @dev Constructor that gives msg.sender all of existing tokens.

        * The `OmniToken` constructor is called with the `_name`, `_symbol`, `_sharedDecimals`, and `_layerZeroEndpoint` arguments.
        * The `_name` argument is the name of the token.
        * The `_symbol` argument is the symbol of the token.
        * The `_sharedDecimals` argument is the number of decimals that the token and OmniTokens share.
        * The `_layerZeroEndpoint` argument is the endpoint of the Layer Zero contract.

        * @param _name The name of the token.
        * @param _symbol The symbol of the token.
        * @param _sharedDecimals The number of decimals to use.
        * @param _layerZeroEndpoint The endpoint of the Layer Zero contract.
    */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _sharedDecimals,
        address _layerZeroEndpoint
    ) OFTV2(_name, _symbol, _sharedDecimals, _layerZeroEndpoint) {}
}

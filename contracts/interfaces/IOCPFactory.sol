// SPDX-License-Identifier: MIT
// OCPLabs Contracts
// @author Muller
pragma solidity ^0.8.17;

/**
    * @dev Interface of the OCP Factory.
    * IOCPFactory is used to deploy OCP pools and OmniTokens.
    * OmniTokens are deployed optimistically, and their address is stored in `getOmniToken` mapping.
    * This allows for a simple lookup of the OmniToken address for a specific token and chainId.
    * If the OmniToken has not been deployed yet, the address in `getOmniToken` will be `0x1`.
    * This is to prevent the router from attempting to deploy the OmniToken on every deposit.
    * The router will check the `getOmniToken` mapping, and if the value is `0x1`, it will call
    * `optimisticDeployed` to update the mapping with the correct OmniToken address.
    * This allows for a simple lookup in the future, and prevents the router from attempting to deploy
    * the OmniToken on every deposit.

    * Pools are deployed optimistically, and their address is stored in `getPool` mapping.
    * This allows for a simple lookup of the pool address for a specific token.
    * If the pool has not been deployed yet, the address in `getPool` will be `0x0`.
    * This is to prevent the router from attempting to deploy the pool on every deposit.
    * The router will check the `getPool` mapping, and if the value is `0x0`, it will call `createPool` to deploy the pool.

    * The router address is set in the constructor, and can only be updated by the owner.
    * Only the router can call `createPool` and `optimisticDeployed`.
    * The pool and OmniToken are deployed using CREATE2, which allows for a deterministic address based on the salt used.
    * The salt is a hash of the pool/token address and the string "OCP_CREATE_POOL" or "OCP_CREATE_TOKEN".
    * This allows for a simple lookup of the pool and OmniToken addresses in the future.
    * The pool and OmniToken addresses are stored in the `getPool` and `getOmniToken` mappings.
    * The pool and OmniToken are deployed with the `initialize` function, which sets the initial values for the pool/token.
    * This is done to save gas, as the router will have to call `initialize` after deploying the pool/token.
    * `initialize` is called in the `createPool` and `createToken` functions.
    * `initialize` can only be called once per pool/token.
    * The pool/token will be deployed with the `initialize` function, and the `initialize` function will check if it has already been called.
*/
interface IOCPFactory {
    /**
        * @dev Returns the address of the pool for a given token,
        * or `0x0` if the pool has not been deployed yet.
        * The pool address is stored in the `getPool` mapping.

        * @param _token The address of the token used to create the pool.
        * @return pool The address of the pool.
        */
    function getPool(address _token) external view returns (address pool);
    /**
        * @dev Returns the address of the OmniToken for a given token and chainId,
        * or `0x1` if the OmniToken has not been deployed yet.
        * This is to prevent the router from attempting to deploy the OmniToken on every deposit.
        * The router will check the `getOmniToken` mapping, and if the value is `0x1`, it will call
        * `optimisticDeployed` to update the mapping with the correct OmniToken address.

        * @param _token The address of the token used to create the pool.
        * @param _chainId The chainId of the OmniToken.
        * @return token The address of the OmniToken.
    */
    function getOmniToken(address _token, uint16 _chainId) external view returns (address token);

    /**
        * @dev deploys a new OCP pool for a given token withe the given shared decimals.
        * The pool address is stored in the `getPool` mapping.
        * The pool is deployed using CREATE2, which allows for a deterministic address based on the salt used.
        * The salt is a hash of the pool/token address and the string "OCP_CREATE_POOL".
        * This allows for a simple lookup of the pool address in the future.
        * The pool is deployed with the `initialize` function, which sets the initial values for the pool.
        * This is done to save gas, as the router will have to call `initialize` after deploying the pool.
        * `initialize` is called in the `createPool` function.
        * `initialize` can only be called once per pool.

        * @param _token The address of the token used to create the pool.
        * @param _sharedDecimals The number of decimals the token has.
        * @return pool The address of the pool.

        * Emits a {PoolCreated} event.
    */
    function createPool(address _token, uint8 _sharedDecimals) external returns (address pool);

    /**
        * @dev deploys a new OmniToken for a given token and chainId.
        * The OmniToken address is stored in the `getOmniToken` mapping.

        * @param _token The address of the token used to create the OmniToken.
        * @param _chainId The chainId of the OmniToken.
        * @notice The address of the OmniToken.
    */
    function optimisticDeployed(address _token, uint16 _chainId) external;
}

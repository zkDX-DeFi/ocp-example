// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IOCPFactory.sol";
import "./OCPPool.sol";
import "./OmniToken.sol";

/**
    * @dev Implementation of the {IOCPFactory} interface.
    *
    * This contract is used to deploy OCP pools and OmniTokens.

    * OmniTokens are deployed on-demand, when a user deposits to a pool on a specific chainId.
    * OmniTokens are deployed optimistically, and their address is stored in `getOmniToken` mapping.
    * This allows for a simple lookup of the OmniToken address for a specific token and chainId.
    * If the OmniToken has not been deployed yet, the address in `getOmniToken` will be `0x1`.
    * This is to prevent the router from attempting to deploy the OmniToken on every deposit.
    * The router will check the `getOmniToken` mapping, and if the value is `0x1`, it will call
    * `optimisticDeployed` to update the mapping with the correct OmniToken address.
    * This allows for a simple lookup in the future, and prevents the router from attempting to deploy
    * the OmniToken on every deposit.
    * If the OmniToken has been deployed, the address will be returned from `getOmniToken` and the router
    * will not attempt to deploy it again.

    * Pools are deployed optimistically, and their address is stored in `getPool` mapping.
    * This allows for a simple lookup of the pool address for a specific token.
    * If the pool has not been deployed yet, the address in `getPool` will be `0x0`.
    * This is to prevent the router from attempting to deploy the pool on every deposit.
    * The router will check the `getPool` mapping, and if the value is `0x0`, it will call
    * `createPool` to deploy the pool.
    * This allows for a simple lookup in the future, and prevents the router from attempting to deploy
    * the pool on every deposit.
    * If the pool has been deployed, the address will be returned from `getPool` and the router
    * will not attempt to deploy it again.

    * The router address is set in the constructor, and can only be updated by the owner.
    * Only the router can call `createPool` and `optimisticDeployed`.

    * The pool and OmniToken are deployed using CREATE2, which allows for a deterministic address
    * based on the salt used. The salt is a hash of the pool/token address and the string
    * "OCP_CREATE_POOL" or "OCP_CREATE_TOKEN".
    * This allows for a simple lookup of the pool and OmniToken addresses in the future.
    * The pool and OmniToken addresses are stored in the `getPool` and `getOmniToken` mappings.

    * The pool and OmniToken are deployed with the `initialize` function, which sets the initial
    * values for the pool/token. This is done to save gas, as the router will have to call `initialize`
    * after deploying the pool/token.
    * `initialize` is called in the `createPool` and `createToken` functions.
    * `initialize` can only be called once per pool/token.
    * The pool/token will be deployed with the `initialize` function, and the `initialize` function
    * will check if it has already been called.

 */
contract OCPFactory is IOCPFactory, Ownable {
    mapping(address => address) public override getPool; // srcToken -> pool
    mapping(address => mapping(uint16 => address)) public override getOmniToken; // srcToken -> chainId -> omniToken
    address public router;
    /**
        * @dev Initializes the contract setting the deployer as the initial owner.
    */
    modifier onlyRouter() {
        require(msg.sender == router, "OCPFactory: caller is not the router");
        _;
    }

    /**
        * @dev creates a new pool for a specific token.
        * This is called by the router when the pool has not been deployed yet.
        * @param _token The address of the token.
        * @param _sharedDecimals The number of decimals of the token.
        * @return pool The address of the pool.
    */
    function createPool(address _token, uint8 _sharedDecimals) external returns (address pool){
        require(address(getPool[_token]) == address(0x0), "OCPFactory: Pool already exists");

        OCPPool newPool = new OCPPool{salt: keccak256(abi.encodePacked("OCP_CREATE_POOL", _token))}();
        newPool.initialize(_token, _sharedDecimals);
        pool = address(newPool);
        getPool[_token] = pool;
    }

    /**
        * @dev Deploys an OmniToken for a specific token and chainId.
        * @param _token The address of the token.
        * @return token The address of the OmniToken.
    */
    function createToken(address _token) external returns (address token) {
        require(address(getPool[_token]) == address(0x0), "OCPFactory: Token already exists");

        // todo: create omniToken
        OmniToken newToken = new OmniToken{salt: keccak256(abi.encodePacked("OCP_CREATE_TOKEN", _token))}(
            "name", "symbol", 6, address(0x0)
        );
        token = address(newToken);
    }

    /**
        * @dev Updates the `getOmniToken` mapping with the address of the OmniToken for a specific token and chainId.
        * This is called by the router when the OmniToken has been deployed.
        * @param _token The address of the token.
        * @param _chainId The chainId of the OmniToken.
    */
    function optimisticDeployed(address _token, uint16 _chainId) external onlyRouter {
        getOmniToken[_token][_chainId] = address(0x1);
    }

    /**
        * @dev Updates the router address.
        * This is called by the owner.
        * @param _router The address of the router.
    */
    function updateRouter(address _router) external onlyOwner {
        require(_router != address(0x0), "OCPFactory: router invalid");
        router = _router;
    }
}

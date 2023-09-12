// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@layerzerolabs/solidity-examples/contracts/lzApp/NonblockingLzApp.sol";
/**
    * @title OCPBridge
    * @author Muller
    * @dev OCPBridge is used to bridge tokens between chains.
    * @dev Implementation of the {IOCPBridge} interface.

    * OCPBridge is used to bridge tokens between chains.
    * OCPBridge is used to mint OmniTokens and is called by the router.
    * OCPBridge is used to pass the function call and payload to the lzEndPoint.
    * OCPBridge is used to update the bridge lookup.

    * {router} is the address of the router.
    * {lzEndPoint} is the address of the lzEndPoint.
    * {bridgeLookup} is a mapping of remote chainId to bridge address.
    * {gasLookup} is a mapping of remote chainId to gas amount.

    * The `omniMint` function is used to mint OmniTokens and is called by the router.
    * The router will call `omniMint` when tokens are deposited.
    * The `omniMint` function is only callable by the router.

    * The `updateBridgeLookup` function is used to update the bridge lookup.
    * The bridge lookup is used to get the bridge address for a remote chain.
    * The bridge lookup is used in the `omniMint` function.
*/
contract OCPBridge is NonblockingLzApp {

    address public router;
    mapping(uint16 => bytes) public bridgeLookup;
    mapping(uint8 => uint256) public gasLookup;

    /**
        * @dev OCPBridge constructor.
        * @dev Sets the values for {router} and {lzEndPoint}.

        * {router} is the address of the router, and it cannot be changed.
        * {lzEndPoint} is the address of the lzEndPoint, and it cannot be changed.
        * onlyOwner is used to set the owner of the contract and the owner of the contract is the deployer.
        * The onlyRouter modifier is used to restrict access to the router, and only {router} can call the function `omniMint`.

        * @param _router The address of the router.
    */
    constructor(address _router, address _lzEndpoint) NonblockingLzApp(_lzEndpoint) {
        router = _router;
    }

    /**
        * @dev onlyRouter
        * @dev Modifier to only allow the router to call the function.
        * If the caller is not the router, the transaction will revert.
    */
    modifier onlyRouter() {
        require(msg.sender == router, "OCPBridge: caller is not the router");
        _;
    }

    /**
        * @dev omniMint
        * The `omniMint` function is used to mint OmniTokens.
        * The router will call `omniMint` when tokens are deposited.
        * For example, if a user deposits 1 ETH into the pool, the router will call `omniMint` to mint 1 OmniETH.
        * If a user deposits 1 DAI into the pool, the router will call `omniMint` to mint 1 OmniDAI.
        * The `omniMint` function is only callable by the router.
        * The `omniMint` function is used to pass the function call and payload to the lzEndPoint.

        * @param _remoteChainId The chainId of the remote chain.
        * @param _destination The destination address on the remote chain.
        * @param _token The address of the token to mint OmniTokens for.
        * @param _name The name of the OmniToken.
        * @param _symbol The symbol of the OmniToken.
        * @param _decimals The decimals of the OmniToken.
        * @param _amountIn The amount of tokens to mint OmniTokens for.
        * @param _to The address to mint the OmniTokens to.
        * @param _payload The payload to send to the remote chain.
    */
    function omniMint(
        uint16 _remoteChainId,
        bytes calldata _destination,
        address _token,
        string calldata _name,
        string calldata _symbol,
        uint8 _decimals,
        uint256 _amountIn,
        address _to,
        bytes memory _payload
    ) external payable onlyRouter {

//        lzEndPoint.send{value: msg.value}(_chainId, bridgeLookup[_remoteChainId], _payload, _refundAddress, address(this), lzTxParamBuilt);
    }

    /**
        * @dev updateBridgeLookup
        * The `updateBridgeLookup` function is used to update the bridge lookup.
        * The bridge lookup is used to get the bridge address for a remote chain.
        * The bridge lookup is used in the `omniMint` function.
        * The `updateBridgeLookup` function is only callable by the owner.

        * @param _remoteChainIds The chainIds of the remote chains.
        * @param _bridges The addresses of the bridges.
    */
    function updateBridgeLookup(uint16[] calldata _remoteChainIds, bytes[] calldata _bridges) external onlyOwner {
        require(_remoteChainIds.length == _bridges.length, "OCPBridge: invalid params");
        for (uint256 i = 0; i < _remoteChainIds.length; i++)
            bridgeLookup[_remoteChainIds[i]] = _bridges[i];
    }

    function _nonblockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal override {

    }
}

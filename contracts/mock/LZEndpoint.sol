// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@layerzerolabs/solidity-examples/contracts/mocks/LZEndpointMock.sol";
contract LZEndpoint is LZEndpointMock {
    constructor(uint16 _chainId) LZEndpointMock(_chainId) {}
}

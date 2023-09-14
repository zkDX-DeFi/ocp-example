// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MockA {
    address public immutable factory;
    address public immutable WETH;

    constructor (address _factory, address _WETH) {
        factory = _factory;
        WETH = _WETH;
    }
}

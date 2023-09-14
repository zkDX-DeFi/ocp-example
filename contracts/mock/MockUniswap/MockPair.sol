// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MockPair {
    address public immutable factory;
    address public token0;
    address public token1;

    constructor () public {
        factory = msg.sender;
    }

    uint private unlocked = 1;
    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;

    modifier lock() {
        require(unlocked == 1, "Locked");
        unlocked = 0;
        _;

        unlocked = 1;
    }

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "Factory: FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }

    function getReserves() public view
    returns(
        uint112 _reserve0,
        uint112 _reserve1,
        uint32 _blockTimestampLast
    ) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    function mint(address _to) external lock returns(uint _liquidity) {

    }
}

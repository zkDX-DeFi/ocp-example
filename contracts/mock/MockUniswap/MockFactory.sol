// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./MockPair2.sol";

contract MockFactory {
    mapping(address => mapping(address => address)) public getPair; // mapping from tokenA to tokenB to pair address
    address[] public allPairs; // array with all pairs
    address public feeTo;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor() {
    }

    /**
        * @dev allPairsLength is used to get the length of the allPairs array.

        * allPairs is an array with all the pair addresses.
        * The length of the allPairs array is used to get the number of pairs.

        * @return The length of the allPairs array.
    */
    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address _token0, address _token1) external returns(address _pair) {
        require(_token0 != _token1, "MockFactory: IDENTICAL_ADDRESSES");
        (address token0, address token1) = _token0 < _token1 ? (_token0, _token1) : (_token1, _token0);

        require(token0 != address(0), "MockFactory: ZERO_ADDRESS");
        require(getPair[token0][token1] == address(0), "MockFactory: PAIR_EXISTS");

        bytes memory bytecode = type(MockPair2).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        assembly {
            _pair := create2(0, add(bytecode,32), mload(bytecode), salt)
        }

        MockPair2(_pair).initialize(token0, token1);

        getPair[token0][token1] = _pair;
        getPair[token1][token0] = _pair;

        allPairs.push(_pair);
        emit PairCreated(token0, token1, _pair, allPairs.length);
    }
}

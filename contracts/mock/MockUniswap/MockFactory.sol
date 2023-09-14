// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MockFactory {
    mapping(address => mapping(address => address)) public getPair; // mapping from tokenA to tokenB to pair address
    address[] public allPairs; // array with all pairs

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

    function createPair(address _tokenA, address _tokenB) external returns(address _pair) {

    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./MockPair.sol";

contract MockFactory is Ownable {
    address public feeTo;
    mapping(address => mapping(address => address)) public getPair; // token0 => token1 => pair
    address[] public allPairs; // all pairs
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    /* views */
    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    /* settings */
    function setFeeTo(address _feeTo) external onlyOwner {
        feeTo = _feeTo;
    }

    /* public functions */
    function createPair(address _token0, address _token1) external returns(address _pair) {
        require(_token0 != _token1, "MockFactory: IDENTICAL_ADDRESSES");
        (address token0, address token1) = _token0 < _token1 ? (_token0, _token1): (_token1, _token0);
        require( token0 != address(0), "MockFactory: ZERO_ADDRESS");
        require( getPair[token0][token1] == address(0), "MockFactory: PAIR_EXISTS");

        bytes memory bytecode = type(MockPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        assembly {
            _pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        MockPair(_pair).initialize(token0, token1);
        getPair[token0][token1] = _pair;
        getPair[token1][token0] = _pair;
        allPairs.push(_pair);

        emit PairCreated(token0, token1, _pair, allPairs.length);
    }
}

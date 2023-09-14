// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MockPair is ERC20{

    address public factory;
    address public token0;
    address public token1;

    constructor (address _factory) ERC20("MockPair", "MP"){
        factory = _factory;
    }


    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'FORBIDDEN');
        token0 = _token0;
        token1 = _token1;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20{
    constructor () ERC20("MockToken", "MT"){
        _mint(msg.sender, 10000e18);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {

    uint256 public interval;
    uint256 public faucetTotal;
    uint256 public faucetAmount;
    uint256 public giveawayTotal;
    mapping(address => uint256) public accountLastTime;
    uint8 private _decimals;

    constructor(string memory _n, uint8 _dc, uint256 _interval, uint256 _faucetTotal, uint256 _faucetAmount) ERC20(_n, _n) {
        _decimals = _dc;
        interval = _interval;
        faucetTotal = _faucetTotal;
        faucetAmount = _faucetAmount;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function faucet() external {
        require(faucetAmount > 0, "Faucet is not enabled now.");
        require(faucetTotal >= giveawayTotal + faucetAmount, "Faucet is running out now.");
        require(block.timestamp - accountLastTime[msg.sender] >= interval, "Faucet interval is not expired.");

        giveawayTotal += faucetAmount;
        accountLastTime[msg.sender] = block.timestamp;
        _mint(msg.sender, faucetAmount);
    }

    function setInterval(uint256 _interval) external onlyOwner {
        interval = _interval;
    }

    function setFaucetAmount(uint256 _faucetAmount) external onlyOwner {
        faucetAmount = _faucetAmount;
    }

    function setFaucetTotal(uint256 _faucetTotal) external onlyOwner {
        faucetTotal = _faucetTotal;
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Token: insufficient balance");
        _burn(msg.sender, amount);
        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "failed to send ether");
    }
}

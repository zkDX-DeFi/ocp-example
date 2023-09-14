// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/utils/math/Math.sol";
import "./UQ112x112.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockPair is ERC20 {
    address public token0;
    address public token1;

    uint public constant MINIMUM_LIQUIDITY = 10**3;
    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;

    event Mint(address indexed sender, uint amount0, uint amount1);

    /**
        * @dev initialize is used to initialize the token address and shared decimals.

        * @param _token0 The address of the token that the pool is for.
        * @param _token1 The number of decimals that the token and OmniTokens share.
    */
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }
    address public immutable factory;
    constructor () ERC20("MP","MP")public {
        factory = msg.sender;
    }

    uint private unlocked = 1;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
    modifier lock() {
        require(unlocked == 1, "LOCKED");
        unlocked = 0;
        _;
        unlocked = 1;
    }

    /**
        * @dev Returns the total supply of the token.

        * @param _balance0 The balance of token0 in the pair.
        * @param _balance1 The balance of token1 in the pair.
        * @param _reserve0 The reserve of token0 in the pair.
        * @param _reserve1 The reserve of token1 in the pair.
    */
    function _update(
        uint _balance0,
        uint _balance1,
        uint112 _reserve0,
        uint112 _reserve1
    ) private {

    }

    /**
        * @dev Returns the total supply of the token.

        * @param _reserve0 The reserve of token0 in the pair.
        * @param _reserve1 The reserve of token1 in the pair.
        * @return feeOn Returns true if the fee is on.
    */
    function _mintFee(
        uint112 _reserve0,
        uint112 _reserve1
    ) private returns(bool feeOn) {
        return true;
    }

    /**
        * @dev safeTransfer is used to transfer tokens safely.

        * @param _token The address of the token to transfer.
        * @param _to The address to transfer the tokens to.
        * @param _value The amount of tokens to transfer.
    */
    function _safeTransfer(
        address _token,
        address _to,
        uint _value
    ) private {
        (bool success, bytes memory data) = _token.call(abi.encodeWithSelector(SELECTOR, _to, _value));
        require(success && (
            data.length == 0 || abi.decode(data, (bool))
        ), "TRANSFER_FAILED");
    }

    /**
        * @dev Returns the getReserves of the token.

        * @return _reserve0 The reserve of token0 in the pair.
        * @return _reserve1 The reserve of token1 in the pair.
        * @return _blockTimestampLast The block timestamp last.
    */
    function getReserves() public view returns(
        uint112 _reserve0,
        uint112 _reserve1,
        uint32 _blockTimestampLast
    )  {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }


    /**
        * @dev mint is used to mint MockPair tokens.

        * @param _to The address to mint the MockPair tokens to.
        * @return _liquidity The amount of MockPair tokens minted.
    */
    function mint (address _to) external lock returns (uint _liquidity) {
        (uint112 _reserve0, uint112 _reserve1, ) = getReserves();

        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));
        uint amount0 = balance0 - _reserve0;
        uint amount1 = balance1 - _reserve1;

        bool feeOn = _mintFee(_reserve0, _reserve1);
        uint _totalSupply = totalSupply();

        if (_totalSupply == 0) {
            _liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
            _mint(address(0), MINIMUM_LIQUIDITY);
        } else {
            _liquidity = Math.min(amount0 * _totalSupply / _reserve0, amount1 * _totalSupply / _reserve1);
        }

        require(_liquidity > 0, "INSUFFICIENT_LIQUIDITY_MINTED");
        _mint(_to, _liquidity);

        _update(balance0, balance1, _reserve0, _reserve1);
        emit Mint(msg.sender, amount0, amount1);
    }
}

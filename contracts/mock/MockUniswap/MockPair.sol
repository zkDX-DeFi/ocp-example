// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "./MockFactory.sol";

contract MockPair is ERC20 {
    address public immutable factory;
    address public token0;
    address public token1;

    using SafeMath for uint;
    uint public constant MINIMUM_LIQUIDITY = 10**3;

    constructor () ERC20('Pair','Pair') public {
        factory = msg.sender;
    }

    uint private unlocked = 1;
    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;

    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    uint public kLast;

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

    function _mintFee(uint _reserve0, uint112 _reserve1) private returns(bool feeOn) {
        address feeTo = MockFactory(factory).feeTo();
        feeOn = feeTo != address(0);
        uint _kLast = kLast;
        if (feeOn) {
            if (_kLast != 0) {
                // todo: add code
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    function mint(address _to) external lock returns(uint _liquidity) {
        (uint112 _reserve0, uint112 _reserve1,) = getReserves();

        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));
        uint amount0 = balance0 - _reserve0;
        uint amount1 = balance1 - _reserve1;

        bool feeOn = _mintFee(_reserve0, _reserve1);
        uint _totalSupply = totalSupply();

        if (_totalSupply == 0) {
            _liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
        }
    }
}

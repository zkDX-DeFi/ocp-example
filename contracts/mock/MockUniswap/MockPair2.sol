// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "./MockFactory.sol";
import "./UQ112x112.sol";

contract MockPair2 is ERC20{
    using UQ112x112 for uint224;
    address public immutable factory;
    constructor() ERC20('MockPair2','MockPair2') public  {
        factory = msg.sender;
    }

    address public token0;
    address public token1;
    uint public constant MINIMUM_LIQUIDITY = 10**3;
    bool public initialized = false;

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

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
    event Sync(uint112 reserve0, uint112 reserve1);

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "Factory: FORBIDDEN"); // sufficient check
        require(initialized == false, "Factory: ALREADY INITIALIZED");
        initialized = true;
        token0 = _token0;
        token1 = _token1;
    }

    /**
        * @dev getReserves is used to get the reserves of the pair.
    */
    function getReserves() public view returns (
        uint112 _reserve0,
        uint112 _reserve1,
        uint32 _blockTimestampLast
    ) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }
}

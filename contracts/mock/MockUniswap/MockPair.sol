// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./UQ112x112.sol";

contract MockPair is ERC20{
    using UQ112x112 for uint224;

    uint public constant MINIMUM_LIQUIDITY = 10**3;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    address public factory;
    address public token0;
    address public token1;

    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;

    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    uint public kLast;
    uint private unlocked = 1;

    modifier lock() {
        require(unlocked == 1, "LOCKED");
        unlocked = 0;
        _;
        unlocked = 1;
    }

    constructor () ERC20("MockPair", "MP"){
        factory = msg.sender;
    }

    event Mint(address indexed _sender, uint _amount0, uint _amount1);
    event Burn(address indexed _sender, uint _amount0, uint _amount1, address indexed _to);
    event Swap(address indexed _sender, uint _amount0In, uint _amount1In, uint _amount0Out, uint _amount1Out, address indexed _to);
    event Sync(uint112 _reserve0, uint112 _reserve1);


    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'FORBIDDEN');
        token0 = _token0;
        token1 = _token1;
    }

    function getReserves() public view returns(
        uint112 _reserve0,
        uint112 _reserve1,
        uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    /* private */
    function _safeTransfer(address _token, address _to, uint _value) private {
        (bool success, bytes memory data) = _token.call(abi.encodeWithSelector(SELECTOR, _to, _value));
        require(success && (
            data.length == 0 || abi.decode(data, (bool))
        ), "TRANSFER_FAILED");
    }

    function _update() private {
        // todo: add code
    }

    function _mintFee() private returns(bool feeOn) {
        // todo: add code
        feeOn = true;
    }

    // public functions
    function mint(address _to) external lock returns(uint _liquidity) {
        // todo: add code
        _liquidity = 0;
    }
}

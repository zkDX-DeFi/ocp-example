// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract Vault is ReentrancyGuard{
    mapping(bytes32 => Position) public positions;
    bool public isInitialized = false;
    address public router;

    constructor () public {
    }
    function initialize(address _router) external {
        require(isInitialized == false, "Vault: already initialized");
        isInitialized = true;
        router = _router;
    }

    struct Position {
        uint256 size;
        uint256 collateral;
        uint256 averagePrice;
        uint256 entryFundingRate;
        uint256 reserveAmount;
        int256 realisedPnl;
        uint256 lastIncreasedTime;
    }

    function increasePosition(
        address _account,
        address _collateralToken,
        address _indexToken,
        uint256 _sizeDelta,
        bool _isLong
    ) external nonReentrant {
        bytes32 key = getPositionKey(_account, _collateralToken, _indexToken, _isLong);
        Position storage position = positions[key];
    }

    function getPositionKey(
        address _account,
        address _collateralToken,
        address _indexToken,
        bool _isLong
    ) public view returns (bytes32) {
        bytes32 key = keccak256(abi.encodePacked(_account, _collateralToken, _indexToken, _isLong));
        return key;
    }
}

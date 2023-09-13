// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@ocplabs/contracts/interfaces/IOCPRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ExampleDerivatives {
    IOCPRouter public immutable router;
    uint16 public immutable remoteChainId;
    IERC20 public immutable depositToken;

    constructor (
        address _router,
        uint16 _remoteChainId,
        address _depositToken
    ) {
        router = IOCPRouter(_router);
        remoteChainId = _remoteChainId;
        depositToken = IERC20(_depositToken);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

interface IPool {
    function deposit(uint256 amount, address owner) external;

    function withdraw(uint256 amount, address owner) external;
}

contract Controller {
    IERC20 underlying;
    IPool pool;
    address poolAddress;

    constructor(address _poolAddress, address underlyingAddress) {
        underlying = IERC20(underlyingAddress);
        pool = IPool(_poolAddress);
        poolAddress = _poolAddress;
    }

    function _deposit(uint256 amount) public {
        underlying.transferFrom(msg.sender, poolAddress, 200);
        pool.deposit(amount, msg.sender);
    }

    function _withdraw() public {}
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract receiptToken is ERC20 {
    address owner;
    address poolAddress;

    constructor() ERC20("Receipt token", "RT") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    modifier onlyPool() {
        require(msg.sender == poolAddress, "Only called from pool");
        _;
    }

    function mint(uint256 amount, address to) public {
        _mint(to, amount);
    }

    function burn(uint256 amount, address from) public {
        _burn(from, amount);
    }

    function setPoolAddress(address _poolAddress) public onlyOwner {
        poolAddress = _poolAddress;
    }
}

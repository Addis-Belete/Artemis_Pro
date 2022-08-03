// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
Example of ERC20 Token contract used to test the pool
Assume it is DAI Token
*/
contract DAIToken is ERC20 {
    address owner;
    address poolAddress;

    constructor() ERC20("Predefined token", "PT") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
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

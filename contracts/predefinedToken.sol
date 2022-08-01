// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
Example of ERC20 Token contract used to test the pool
*/
contract DAIToken is ERC20 {
    constructor() ERC20("Predefined token", "PT") {}

    /*
@notice - is used to mint receipt token
*/
    function mint(uint256 amount, address to) public {
        _mint(to, amount * 10**decimals());
    }

    function burn(uint256 amount, address from) public {
        _burn(from, amount * 10**decimals());
    }
}

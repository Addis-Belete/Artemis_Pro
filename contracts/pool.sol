// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool {
    IERC20 public underyling; // any ERC20 predefined token
    address public receiptToken; //receipt token

    constructor(address _predefinedTokenAddress, address receiptTokensAddress) {
        underyling = IERC20(_predefinedTokenAddress);
        receiptToken = receiptTokensAddress;
    }

    struct userInfo {
        uint256 amount;
        uint256 deposit_time;
        bool isDeposited;
    }
    mapping(address => userInfo) public userData;

    /*
@dev - Is a function used to deposit predefined token to the contract
@param amount - amount of predefined token
*/

    function deposit(uint256 amount) public {}
}

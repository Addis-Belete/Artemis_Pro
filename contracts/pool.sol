// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IReceiptToken {
    function mint(uint256 amount, address to) external;

    function burn(uint256 amount, address from) external;

    function balanceOf(address account) external view returns (uint256);
}

contract Pool {
    IERC20 public underyling; // any ERC20 predefined token
    IReceiptToken public receiptToken; //receipt token

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

    function deposit(uint256 amount) public {
        require(
            underyling.balanceOf(msg.sender) >= amount,
            "You don't have enough amount to withdraw"
        );
        underyling.transfer(address(this), amount);
        if (userData[msg.sender].isDeposited == true) {
            uint256 initialAmount = userData[msg.sender].amount;
            uint256 initialTime = userData[msg.sender].dep_started;
            uint256 reward = calculateReward(initialAmount, initialTime);
            uint256 finalAmount = initialAmount + amount + reward;
            userData[msg.sender] = userInfo(finalAmount, block.timestamp, true);
        } else {
            userData[msg.sender] = userInfo(amount, block.timestamp, true);
        }
        receiptToken.mint(amount, msg.sender);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "hardhat/console.sol";

interface IReceiptToken {
    function mint(uint256 amount, address to) external;

    function burn(uint256 amount, address from) external;

    function balanceOf(address account) external view returns (uint256);
}

contract Account {}

contract Pool {
    using SafeERC20 for IERC20;
    IERC20 public underlying; // any ERC20 predefined token
    IReceiptToken public receiptToken; //receipt token
    address controllerAddress;
    address _owner;

    constructor(address _predefinedTokenAddress, address receiptTokensAddress) {
        underlying = IERC20(_predefinedTokenAddress);
        receiptToken = IReceiptToken(receiptTokensAddress);
        _owner = msg.sender;
    }

    struct userInfo {
        uint256 amount;
        uint256 deposit_time;
        bool isDeposited;
    }
    mapping(address => userInfo) public userData;
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call");
        _;
    }
    modifier onlyController() {
        require(msg.sender == controllerAddress, "only called vai controller");
        _;
    }

    /*
@dev - Is a function used to deposit predefined token to the contract
@param amount - amount of predefined token
*/

    function deposit(uint256 amount, address owner) public {
        require(
            underlying.balanceOf(owner) >= amount,
            "You don't have enough amount to withdraw"
        );
        // underlying.transfer(owner,address(this), amount);
        if (userData[owner].isDeposited == true) {
            uint256 initialAmount = userData[owner].amount;
            uint256 initialTime = userData[owner].deposit_time;
            uint256 reward = calculateReward(initialAmount, initialTime);
            uint256 finalAmount = initialAmount + amount + reward;
            userData[owner] = userInfo(finalAmount, block.timestamp, true);
        } else {
            userData[owner] = userInfo(amount, block.timestamp, true);
        }
        receiptToken.mint(amount, owner);
    }

    /*
@dev - Function used to withdraw funds from the contract
@param amount - amount of receipt token owner wants to redeem
@param owner - address of owner

*/
    function withdraw(uint256 amount, address owner) public {
        require(
            receiptToken.balanceOf(owner) >= amount,
            "you don't have enough amount to redeem"
        );
        require(owner != address(0), "Invalid address");
        uint256 userBalance = userData[owner].amount;
        uint256 initialTime = userData[owner].deposit_time;
        uint256 reward = calculateReward(userBalance, initialTime);
        userData[owner].amount += reward;
        console.log("calculated amount -->", userData[owner].amount);
        uint256 amountToWithdraw = calculareShare(amount, owner);
        receiptToken.burn(amount, owner);
        userData[owner].amount -= amountToWithdraw;
        userData[owner].deposit_time = block.timestamp;
        if (userData[owner].amount == 0) {
            userData[owner].isDeposited = false;
        }
        underlying.transfer(owner, amountToWithdraw);
    }

    /*
@dev - Function used to calculate rewards by giving 30% interest in 60 secs;
@param  - amount - the total underlying deposited at the time of reward calculation
@param - startTime - the time at which user deposited funds
*/
    function calculateReward(uint256 amount, uint256 startTime)
        private
        view
        returns (uint256 reward)
    {
        // uint256 one_year = 60;
        uint256 endTime = block.timestamp;
        uint256 duration = endTime - startTime;
        reward = (amount * duration * 3) / 600;
    }

    /*
@notice - Function used to convert the amount of receipt token to predefined token
@param share - the amount of receipt token to redeem
@param owner - address of the owner
*/
    function calculareShare(uint256 share, address owner)
        private
        view
        returns (uint256)
    {
        uint256 fullAmount = userData[owner].amount;
        uint256 totalShare = receiptToken.balanceOf(owner);
        uint256 amountToBeWithdrawed = (fullAmount * share) / totalShare;
        console.log("converted share amount -->", amountToBeWithdrawed);
        return amountToBeWithdrawed;
    }

    function setController(address _controllerAddress) public onlyOwner {
        controllerAddress = _controllerAddress;
    }
}

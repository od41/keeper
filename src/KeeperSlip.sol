// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./KeeperPool.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IKUSD} from "./asd/IKUSD.sol";

contract KeeperSlip {
    bool isActive;
    KeeperPool public pool;
    uint256 public coverAmount;
    uint256 public withdrawnAmount;
    address public trader;

    address public immutable kUSD; // Note: Note backed stablecoin used as liquidity

    constructor(address payable _pool, address payable _trader, uint256 _coverAmount, address _kUSDAddress) {
        pool = KeeperPool(_pool);
        coverAmount = _coverAmount;
        trader = _trader;
        kUSD = _kUSDAddress;

        isActive = true;
    }

    fallback() external payable {
        require(isActive, "This slip is inactive");
    }

    receive() external payable {
        require(isActive, "This slip is inactive");
    }

    modifier onlyOwner() {
        require(msg.sender == trader, "Only trader can complete this action");
        _;
    }

    event KeeperPoolUpdated(address indexed trader, address indexed pool, uint256 indexed amount);
    event KeeperPoolWithdrawal(address indexed slipAddress, uint256 amount);

    function getTrader() public view returns (address) {
        return trader;
    }
    /* 
    make sure that approve is called to allow transfer from the user's 
    wallet to the keeper slip contract
    */

    function repaySlip(uint256 _amount) external {
        require(isActive, "This slip is inactive");
        require((_amount + withdrawnAmount) <= coverAmount, "deposit is larger than debt available");
        IKUSD kUSDToken = IKUSD(kUSD);

        kUSDToken.transferFrom(msg.sender, address(this), _amount);
        withdrawnAmount -= _amount;
    }

    function withdrawDebt(uint256 _amount) external onlyOwner {
        require(isActive, "This slip is inactive");
        require((_amount + withdrawnAmount) <= coverAmount, "Not enough KUSD debt in this slip");
        IKUSD kUSDToken = IKUSD(kUSD);

        kUSDToken.transfer(msg.sender, _amount);

        withdrawnAmount = withdrawnAmount - _amount;
        emit KeeperPoolWithdrawal(address(this), _amount);
    }

    function closeSlip() external onlyOwner {
        require(isActive, "This slip is inactive");
        require(withdrawnAmount == 0, "Slip has unpaid debt");
        IKUSD kUSDToken = IKUSD(kUSD);
        kUSDToken.transfer(address(pool), coverAmount);

        payable(address(pool)).transfer(address(this).balance);

        isActive = false;
    }
}

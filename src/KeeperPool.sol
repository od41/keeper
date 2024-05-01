// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./KeeperSlip.sol";

import "forge-std/console.sol";

contract KeeperPool is Ownable {
    uint256 MAX_INT = 2 ** 256 - 1;

    mapping(address => uint256) traderCollateralBalance;
    mapping(address => uint256) liquidityProviderBalance;
    
    uint256 public totalLiquidityBalance;
    uint256 public totalCollateralBalance;

    IERC20 internal liquidityToken; // Note: stablecoin used as liquidity
    // mapping(address => uint256) public deposits;
    // mapping(address => uint256) public borrows;

    event LiquidtyDeposit(address liquidityProvider, uint256 value);
    event NewKeeperDeployed(address keeperSlip, address pool, address trader, uint256 value);

    constructor(address _noteContractAddress) Ownable(msg.sender) {
        liquidityToken = IERC20(_noteContractAddress);
    }

    /* 
        Provide liquidity 
    */
    function depositLiquidity(uint256 amount) payable external {
        require(amount > 0, "Amount must be greater than 0");
        require(msg.sender != address(0), "Invalid sender address");

        console.logAddress(address(this));
        console.logAddress(address(liquidityToken));

        uint256 allowance = liquidityToken.allowance(msg.sender, address(this));
        require(allowance >= amount, "Insufficient allowance for token transfer");
        
        liquidityToken.transferFrom(address(this), msg.sender, amount);

        liquidityProviderBalance[msg.sender] += amount;
        totalLiquidityBalance += amount;
        
        emit LiquidtyDeposit(msg.sender, amount);

    }

    function withdrawLiquidity(uint256 amount) external {
        // Ensure sender has enough balance to withdraw
        require(liquidityProviderBalance[msg.sender] >= amount, "Insufficient balance");
        require(totalLiquidityBalance >= amount, "Insufficient balance in contract");
        // Transfer stablecoins from this contract to sender
        liquidityToken.transfer(msg.sender, amount);
        // Decrease sender's deposit balance
        liquidityProviderBalance[msg.sender] -= amount;
        totalLiquidityBalance -= amount;
    }

    /* 
        Use liquidity
     */
    function borrow(address keeperPool, address trader, uint256 amount)
        external
        returns (address)
    {
        require(amount < MAX_INT, "Too close to MAX INT");
        require(traderCollateralBalance[msg.sender] >= amount, "Not enough collateral in the pool");
        require(totalCollateralBalance >= amount, "Not enough working collateral in the pool");

        KeeperSlip slip = new KeeperSlip(payable(address(keeperPool)), payable(address(trader)), amount);

        payable(address(slip)).transfer(amount);

        traderCollateralBalance[msg.sender] -= amount;
        totalCollateralBalance -= amount;

        emit NewKeeperDeployed(address(slip), address(this), trader, amount);

        return address(slip);
        // Implement borrow logic, using deposited Canto or CAD as collateral'
        // put up something
        // get liquidity to their wallet
        // pay directly to the CAD pool
        // make it a whitelist thing, where you pay directly to whatever protocol needs protection
    }

    function repay(uint256 amount) external {
        // Implement repay logic, reducing borrowed amount
    }
}

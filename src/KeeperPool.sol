// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import {IKUSD} from "./asd/IKUSD.sol";
import "./KeeperSlip.sol";

contract KeeperPool is Ownable {
    uint256 MAX_INT = 2 ** 256 - 1;

    mapping(address => uint256) traderCollateralBalance;
    mapping(address => uint256) traderDebtBalance;
    mapping(address => uint256) liquidityProviderBalance;
    
    uint256 public totalLiquidityBalance;
    uint256 public totalCollateralBalance;
    uint256 public totalDebtBalance;

    IKUSD internal kUSD; // Note: Note backed stablecoin used as liquidity

    uint64 priceCantoUSD = 1427;
    uint64 decimalPlacesPrice = 4;

    event LiquidtyDeposit(address liquidityProvider, uint256 value);
    event NewKeeperDeployed(address keeperSlip, address pool, address trader, uint256 value);

    constructor(address _kUSDAddress) Ownable(msg.sender) {
        kUSD = IKUSD(_kUSDAddress);
    }
    

    /// @notice Deposit Note into the pool to create new kUSD
    /// @param amount The value of Note that is deposited 
    /// and will mint equivalent amount of kUSD
    function depositLiquidity(uint256 amount) payable external {
        require(amount > 0, "Amount must be greater than 0");
        require(msg.sender != address(0), "Invalid sender address");

        // mint new kUSD
        kUSD.mint(amount);

        // approve transfer of tokens
        kUSD.approve(address(this), amount);
        // transfer to KeeperPool
        bool res = kUSD.transferFrom(msg.sender, address(this), amount);

        require(res, 'Error depositing liquidity to pool');

        liquidityProviderBalance[msg.sender] += amount;
        totalLiquidityBalance += amount;
        
        emit LiquidtyDeposit(msg.sender, amount);

    }

    function withdrawLiquidity(uint256 amount) external {
        // Ensure sender has enough balance to withdraw
        require(liquidityProviderBalance[msg.sender] >= amount, "Insufficient balance");
        require(totalLiquidityBalance >= amount, "Insufficient balance in contract");

        
        // remove the amount of kUSD from circulation
        kUSD.burn(amount);
        // transfer amount to user
        kUSD.transfer(msg.sender, amount);

        // TODO: withdraw rewards 
        // kUSD.withdrawCarry(amount);

        // Decrease sender's deposit balance
        liquidityProviderBalance[msg.sender] -= amount;
        totalLiquidityBalance -= amount;
    }

    /* 
        Use liquidity
     */
    function borrow(address keeperPool, address trader, uint256 amount)
        payable
        external
        returns (address)
    {
        // deposit collateral e.g which is CANTO
        // collateral must be 120 * amount (over collateralized) by 120%
        
        // Implement borrow logic, using deposited Canto or CAD as collateral'
        // put up something
        // get liquidity to their wallet
        // pay directly to the CAD pool
        // make it a whitelist thing, where you pay directly to whatever protocol needs protection

        require(amount < MAX_INT, "Too close to MAX INT");
        uint256 collateralInUSD = cantoInUSD(msg.value);
        require(collateralInUSD >= (((amount * 10**decimalPlacesPrice) * 120) / 100) + (amount * 10**decimalPlacesPrice), "Collateral is too low");
        require(totalLiquidityBalance >= amount, "Not enough liquidity in the pool");

        KeeperSlip slip = new KeeperSlip(payable(address(keeperPool)), payable(address(trader)), amount);
        
        // Transfer liquidity to slip where debtor can draw from whenever they like
        kUSD.transfer(address(slip), amount);

        traderCollateralBalance[msg.sender] += msg.value;
        totalCollateralBalance += msg.value;

        traderDebtBalance[msg.sender] += amount;
        totalLiquidityBalance -= amount;

        emit NewKeeperDeployed(address(slip), address(this), trader, amount);

        return address(slip);
    }

    function cantoInUSD(uint256 amount) view public returns(uint256 inUSD) {
        if(amount == 0) return 0;
        inUSD = (amount * priceCantoUSD);
    }

    function repay(uint256 amount) external {
        // Implement repay logic, reducing borrowed amount
    }
}
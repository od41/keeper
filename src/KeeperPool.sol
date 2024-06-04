// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/access/Ownable.sol";
import {IKUSD} from "./asd/IKUSD.sol";
import {CTokenInterface, CErc20Interface} from "./asd/CTokenInterfaces.sol";
import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./KeeperSlip.sol";

contract KeeperPool is Ownable {
    uint256 MAX_INT = 2 ** 256 - 1;

    mapping(address => uint256) public traderCollateralBalance;
    mapping(address => uint256) public traderDebtBalance;
    mapping(address => uint256) public liquidityProviderBalance;

    uint256 public totalLiquidityBalance;
    uint256 public totalCollateralBalance;
    uint256 public totalDebtBalance;

    address public immutable kUSD; // Note: Note backed stablecoin used as liquidity
    address public immutable cNote; // Reference to the cNOTE token

    uint64 priceCantoUSD = 1427;
    uint64 decimalPlacesPrice = 4;

    event LiquidtyDeposit(address indexed liquidityProvider, uint256 value);
    event LiquidtyWithdrawal(address indexed liquidityProvider, uint256 value);
    event NewKeeperSlip(address indexed keeperSlip, address indexed pool, address indexed trader, uint256 value);

    constructor(address _kUSDAddress, address _cNote) {
        kUSD = _kUSDAddress;
        cNote = _cNote;
    }

    /// @notice Deposit KUSD into the pool to create new kUSD
    /// @param amount The value of KUSD that is deposited
    function depositLiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(msg.sender != address(0), "Invalid sender address");

        // transfer note
        CErc20Interface cNoteToken = CErc20Interface(cNote);
        IERC20 note = IERC20(cNoteToken.underlying());
        SafeERC20.safeTransferFrom(note, msg.sender, address(this), amount);

        // approve asd contract to spend for this contract's behalf
        note.approve(address(kUSD), amount);

        // mint new kUSD
        IKUSD kUSDToken = IKUSD(kUSD);
        kUSDToken.mint(amount); // call the asdOFT mint

        liquidityProviderBalance[msg.sender] += amount;
        totalLiquidityBalance += amount;

        emit LiquidtyDeposit(msg.sender, amount);
    }

    function withdrawLiquidity(uint256 amount) external {
        // Ensure sender has enough balance to withdraw
        require(liquidityProviderBalance[msg.sender] >= amount, "Insufficient balance");
        require(totalLiquidityBalance >= amount, "Insufficient balance in contract");

        CErc20Interface cNoteToken = CErc20Interface(cNote);
        IERC20 note = IERC20(cNoteToken.underlying());
        IKUSD kUSDToken = IKUSD(kUSD);

        // remove the amount of kUSD from circulation
        kUSDToken.burn(amount);

        // transfer Note to user
        SafeERC20.safeTransfer(note, msg.sender, amount);

        // TODO: withdraw rewards
        // kUSD.withdrawCarry(amount);

        // Decrease sender's deposit balance
        liquidityProviderBalance[msg.sender] -= amount;
        totalLiquidityBalance -= amount;
    }

    /* 
        Use liquidity
    */
    function borrow(address trader, uint256 amount) external payable returns (address) {
        require(amount < MAX_INT, "Too close to MAX INT");
        uint256 collateralInUSD = cantoInUSD(msg.value);
        // TODO: get price from oracle
        require(
            collateralInUSD >= (((amount * 10 ** decimalPlacesPrice) * 120) / 100) + (amount * 10 ** decimalPlacesPrice),
            "Collateral is too low"
        );
        require(totalLiquidityBalance >= amount, "Not enough liquidity in the pool");

        KeeperSlip slip = new KeeperSlip(payable(address(this)), payable(address(trader)), amount, kUSD);

        IKUSD kUSDToken = IKUSD(kUSD);

        // Transfer liquidity to slip where debtor can draw from whenever they like
        kUSDToken.transfer(address(slip), amount);

        traderCollateralBalance[msg.sender] += msg.value;
        totalCollateralBalance += msg.value;

        traderDebtBalance[msg.sender] += amount;
        totalLiquidityBalance -= amount;

        emit NewKeeperSlip(address(slip), address(this), trader, amount);

        return address(slip);
    }

    function cantoInUSD(uint256 amount) public view returns (uint256 inUSD) {
        if (amount == 0) return 0;
        inUSD = (amount * priceCantoUSD);
    }

    function priceOfCanto() public view returns (uint256 cantoPrice) {
        return 1;
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract FeeManager {
    uint256 public fixedDepositFee;
    uint256 public fixedWithdrawalFee;

    constructor(uint256 _depositFee, uint256 _withdrawalFee) {
        fixedDepositFee = _depositFee;
        fixedWithdrawalFee = _withdrawalFee;
    }

    function setFixedDepositFee(uint256 _fee) external {
        fixedDepositFee = _fee;
    }

    function setFixedWithdrawalFee(uint256 _fee) external {
        fixedWithdrawalFee = _fee;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TimedAccess {
    uint256 public startTime;
    uint256 public endTime;

    constructor(uint256 _startTime, uint256 _duration) {
        startTime = _startTime;
        endTime = _startTime + _duration;
    }

    modifier onlyDuringActivePeriod() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Access period is not active");
        _;
    }

    modifier onlyAfterActivePeriod() {
        require(block.timestamp > endTime, "Access period is still active");
        _;
    }
}

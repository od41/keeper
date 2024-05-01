// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./KeeperPool.sol";

contract KeeperSlip {
    
    KeeperPool public pool;
    uint256 public coverAmount;
    address public trader;

    constructor(
        address payable _pool,
        address payable _trader,
        uint256 _coverAmount
    ) {
        pool = KeeperPool(_pool);
        coverAmount = _coverAmount;
        trader = _trader;
    }

    fallback() external payable {}
    receive() external payable {}

    event KeeperPoolUpdated(address indexed trader, address indexed pool, uint256 indexed amount);

    function getTrader() public view returns (address) {
        return trader;
    }

    // function reward(uint256 amount) public {
    //     // pool.updatePool(trader, amount);

    //     coverAmount -= (amount);

    //     payable(address(pool)).transfer(amount);

    //     emit KeeperPoolUpdated(trader, address(pool), amount);
    // }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/KeeperPool.sol";
import "./Utils.sol";
import "./MockNote.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KeeperPoolTest is Test {
    KeeperPool public kPool;
    Utils internal utils;
    MockNote public noteToken;

    address payable[] internal users;

    address payable internal trader;
    address payable internal lProvider;
    address payable internal anotherTrader;
    address payable internal anotherLProvider;

    address internal noteTokenAddress;

    event LiquidtyDeposit(address liquidityProvider, uint256 value);

    fallback() external payable {}
    receive() external payable {}

    function setUp() public {
        noteToken = new MockNote();
        noteTokenAddress = address(noteToken);
        address mockKUSDAddress = noteTokenAddress;
        utils = new Utils();
        kPool = new KeeperPool(mockKUSDAddress, noteTokenAddress);

        users = utils.createUsers(4);

        trader = users[0];
        vm.label(trader, "Trader Beethoven");

        lProvider = users[1];
        vm.label(lProvider, "Liquidity Provider Chopin");

        anotherTrader = users[2];
        vm.label(anotherTrader, "Another Trader Krazinsky");

        anotherLProvider = users[3];
        vm.label(anotherLProvider, "Another Liquidity Provider Dolce");

        vm.deal(address(trader), 100 ether);
        vm.deal(address(lProvider), 100 ether);
        vm.deal(address(anotherTrader), 100 ether);
        vm.deal(address(anotherLProvider), 100 ether);
    }

    // function tesLiquidityProvidertDesposit() public {
    //     vm.startPrank(lProvider);
    //     assertEq(lProvider.balance, 100 ether);

    //     vm.expectEmit(true, false, false, true);
    //     emit LiquidtyDeposit(address(lProvider), 1 ether);

    //     kPool.depositLiquidity{value: 1 ether}(1 ether);

    //     assertEq(lProvider.balance, 99 ether);

    //     vm.stopPrank();
    // }

    function testRequestBorrowNotEnoughCollateral() public {
        vm.startPrank(lProvider);

        vm.expectRevert("Not enough collateral in the pool");
        kPool.borrow(address(this), address(trader), 1 ether);

        vm.stopPrank();
    }

     function testTraderBorrowDeploysKeeperSlip(uint256 collateralDeposit) public {
        collateralDeposit = bound(collateralDeposit, 1 ether, 10000 ether);

        vm.deal(lProvider, collateralDeposit);

        vm.startPrank(lProvider);
        assertEq(lProvider.balance, collateralDeposit);
        noteToken.approve(address(kPool), collateralDeposit);
        vm.expectRevert(); // TODO: remove
        kPool.depositLiquidity(collateralDeposit);
        vm.stopPrank();

        // vm.startPrank(trader);
        // assertEq(kPool.totalLiquidityBalance(), collateralDeposit);
        // assertEq(noteToken.balanceOf(address(kPool)), collateralDeposit);
        // address kSlip = kPool.borrow(address(this), address(trader), collateralDeposit);
        // assertEq(noteToken.balanceOf(address(kSlip)), collateralDeposit);
        // assertEq(kPool.totalLiquidityBalance(), 0);
        // vm.stopPrank();
    }
    
}

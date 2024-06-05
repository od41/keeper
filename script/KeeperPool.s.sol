// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {KeeperPool} from "../src/KeeperPool.sol";

contract KeeperPoolScript is Script {
    function setUp() public {}

    function run() public {
        uint256 pk = vm.envUint("MY_WALLET_PRIVATE_KEY");
        bool isTestnet = vm.envBool("IS_CANTO_TESTNET");

        address kUSDAddress = address(0x987D567B56b3186f0fea777Bc3c5723DDb52bfB8);
        address cNoteAddress = isTestnet
            ? address(0x04E52476d318CdF739C38BD41A922787D441900c)
            : address(0xEe602429Ef7eCe0a13e4FfE8dBC16e101049504C);

        address pythAddress = isTestnet
            ? address(0x26DD80569a8B23768A1d80869Ed7339e07595E85)
            : address(0x98046Bd286715D3B0BC227Dd7a956b83D8978603);
        bytes32 CANTO_PRICE_FEED_ID = bytes32(0x972776d57490d31c32279c16054e5c01160bd9a2e6af8b58780c82052b053549);

        vm.startBroadcast(pk);
        KeeperPool kpContract = new KeeperPool(kUSDAddress, cNoteAddress, pythAddress, CANTO_PRICE_FEED_ID);
        console.logAddress(address(kpContract));
        vm.stopBroadcast();
    }
}

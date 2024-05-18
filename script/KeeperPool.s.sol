// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {KeeperPool} from "../src/KeeperPool.sol";

contract KeeperPoolScript is Script {
    function setUp() public {}

    function run() public {
        uint pk = vm.envUint("MY_WALLET_PRIVATE_KEY");
        bool isTestnet = vm.envBool("IS_CANTO_TESTNET");

        address kUSDAddress = address(0x987D567B56b3186f0fea777Bc3c5723DDb52bfB8);
        address cNoteAddress = isTestnet ? address(0x04E52476d318CdF739C38BD41A922787D441900c) : address(0xEe602429Ef7eCe0a13e4FfE8dBC16e101049504C);

        vm.startBroadcast(pk);
        KeeperPool kpContract = new KeeperPool(kUSDAddress, cNoteAddress);
        console.logAddress(address(kpContract));
        vm.stopBroadcast();
    }
}

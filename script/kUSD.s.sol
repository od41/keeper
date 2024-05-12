// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.13;

// import {Script, console} from "forge-std/Script.sol";
// import {kUSD} from "../src/asd/kUSD.sol";

// // NOT ACTUAL DEPLOY, BUGGY ASD CONTRACT

// contract KUSDScript is Script {
//     function setUp() public {}

//     function run() public {
//         uint pk = vm.envUint("MY_WALLET_PRIVATE_KEY");

//         address lzEndpoint = address(0xEbe265c9299d0C879bcc2A76948511BA6ED6C36D);
//         address cNoteContract = address(0x04E52476d318CdF739C38BD41A922787D441900c);
//         address cSRAddress = address(0x0FC28558E05EbF831696352363c1F78B4786C4e5);

//         vm.startBroadcast(pk);
//         kUSD kusdContract = new kUSD("KeeperUSD", "KUSD", lzEndpoint, cNoteContract, cSRAddress);
//         console.logAddress(address(kusdContract));
//         vm.stopBroadcast();
//     }
// }

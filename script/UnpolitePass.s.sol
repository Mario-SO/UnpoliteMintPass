// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {UnpolitePass} from "src/UnpolitePass.sol"

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        UnpolitePass = new UnpolitePass();
        vm.stopBroadcast();
    }
}

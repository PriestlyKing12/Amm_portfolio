// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {Amm} from "../src/AM.sol";

contract AmmScript is Script {
    Amm public amm;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        amm = new Amm();

        vm.stopBroadcast();
    }
}

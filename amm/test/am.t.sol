// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Amm} from "../src/AM.sol";

contract AMMtest is Test{
    Amm public amm;
    address public charles = makeAddr('charles');
    address public andrew = makeAddr('andrew');

    function setUp() public{
        amm = new Amm();
    }
    function testPoolInitiation() public{
        vm.prank(andrew);
        amm.pool(2000,20);
        assertEq(amm.reserveX(), 2000);
        assertEq(amm.totalShares(), 200);
        assertEq(amm.reserveY(), 20);
        assertEq(amm.mintedShares(), 200);
    }
    function testInvalidshareratio() public{
        vm.prank(charles);
        amm.pool(2000,20);
        vm.prank(andrew);
        amm.pool(200,200);
        assertEq(amm.totalShares(), 200);
    }
    function testshareUpdate() public {
         vm.prank(charles);   
         amm.pool(2000,20);
         vm.prank(andrew);
         amm.pool(200,2);
         assertEq(amm.shares(andrew), 2);
          } 
}

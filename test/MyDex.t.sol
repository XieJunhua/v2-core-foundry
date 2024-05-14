// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";

import { UniswapV2Factory } from "../src/UniswapV2Factory.sol";
import "../src/RNT.sol";
import "../src/Weth.sol";
// import { UniswapV2Library } from "../src/libraries/UniswapV2Library.sol";
import "../src/libraries/UniswapV2Library.sol";

import { UniswapV2Router01 } from "../src/UniswapV2Router01.sol";
import { UniswapV2Pair } from "../src/UniswapV2Pair.sol";
import "../src/MyDex.sol";

contract MyDexTest is Test {
    MyDex mydex;
    RNT rnt;
    address alice = makeAddr("alice");

    function setUp() public {
        mydex = new MyDex();
        rnt = new RNT();
    }

    function testsellETH() public {
        vm.startPrank(alice);
        vm.deal(alice, 1 ether);

        mydex.sellETH{ value: 1 ether }(address(rnt), 1e8);
        assertEq(rnt.balanceOf(alice), 1e8);
        vm.stopPrank();
    }

    function testBuyEth() public {
        vm.startPrank(alice);
        vm.deal(address(mydex), 1 ether);
        rnt.mint(alice, 1e8);

        mydex.buyETH(address(rnt), 1e8, 1 ether);
        assertEq(rnt.balanceOf(alice), 0);
        assertEq(alice.balance, 1 ether);
        vm.stopPrank();
    }
}

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
import "../src/libraries/Math.sol";

contract UniswapV2FactoryTest is Test {
    UniswapV2Factory factory;
    address alice = makeAddr("alice");
    RNT rnt;
    WETH9 weth;
    UniswapV2Router01 router;

    function setUp() public {
        factory = new UniswapV2Factory(alice);
        rnt = new RNT();
        weth = new WETH9();
        router = new UniswapV2Router01(address(factory), address(weth));
    }

    function testCreatePair() public {
        addPair(address(rnt), address(weth));
    }

    function testAddLiquidity() public {
        vm.startPrank(alice);
        vm.deal(alice, 10 ether);

        rnt.mint(alice, 1e10);
        rnt.approve(address(router), 1e10);
        router.addLiquidityETH{ value: 10 ether }(address(rnt), 1e9, 1e9, 10 ether, alice, block.timestamp + 1 days);

        vm.stopPrank();
    }

    function testRemoveLiquidity() public {
        vm.startPrank(alice);
        vm.deal(alice, 10 ether);

        rnt.mint(alice, 1e10);
        rnt.approve(address(router), 1e10);
        router.addLiquidityETH{ value: 10 ether }(address(rnt), 1e9, 1e9, 10 ether, alice, block.timestamp + 1 days);

        address pair = UniswapV2Library.pairFor(address(factory), address(rnt), address(weth));
        UniswapV2Pair(pair).approve(address(router), 1e9);
        UniswapV2Pair(pair).balanceOf(alice);

        // remove liquidity the amountTokenMin should me set a small value
        // todo: how to set the amountTokenMin and etherMin?
        router.removeLiquidityETH(address(rnt), 1 * 1e9, 10, 1 gwei, alice, block.timestamp + 1 days);

        console2.log("rnt balance: ", rnt.balanceOf(alice));
        console2.log("weth balance: ", weth.balanceOf(alice));

        vm.stopPrank();
    }

    function testMath() public {
        console2.log(Math.sqrt(1e8 * 1e19));
    }

    function testcalculateInitcode() public pure {
        bytes memory bytecode = type(UniswapV2Pair).creationCode;
        bytes32 result = keccak256(abi.encodePacked(bytecode));
        console2.logBytes32(result);
    }

    function addPair(address tokenA, address tokenB) private {
        factory.createPair(address(rnt), address(weth));
    }
}

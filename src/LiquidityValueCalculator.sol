// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "./interfaces/ILiquidityValueCalculator.sol";
import "./UniswapV2Pair.sol";
// import { UniswapV2Library } from "@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";

contract LiquidityValueCalculator is ILiquidityValueCalculator {
    address public factory;

    constructor(address factory_) {
        factory = factory_;
    }

    function pairInfo(
        address tokenA,
        address tokenB
    )
        internal
        view
        returns (uint256 reserveA, uint256 reserveB, uint256 totalSupply)
    {
        // todo: need to be compeleted
        UniswapV2Pair pair = UniswapV2Pair(factory);
        totalSupply = pair.totalSupply();
        (uint256 reserves0, uint256 reserves1,) = pair.getReserves();
        (reserveA, reserveB) = tokenA == pair.token0() ? (reserves0, reserves1) : (reserves1, reserves0);
    }

    function computeLiquidityShareValue(
        uint256 liquidity,
        address tokenA,
        address tokenB
    )
        public
        override
        returns (uint256 tokenAAmount, uint256 tokenBAmount)
    { }
}

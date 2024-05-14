// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "./interfaces/IDEX.sol";
import "./RNT.sol";

/**
 * @title
 * @author
 * @notice
 * 该合约提供了一个简单的DEX，用于兑换RNT
 */
contract MyDex is IDex {
    receive() external payable { }

    /**
     * @dev 卖出ETH，兑换成 buyToken
     *      msg.value 为出售的ETH数量
     * @param buyToken 兑换的目标代币地址
     * @param minBuyAmount 要求最低兑换到的 buyToken 数量
     */
    function sellETH(address buyToken, uint256 minBuyAmount) external payable {
        assert(msg.value > 0);
        RNT(buyToken).mint(msg.sender, minBuyAmount);
    }

    /**
     * @dev 买入ETH，用 sellToken 兑换
     * @param sellToken 出售的代币地址
     * @param sellAmount 出售的代币数量
     * @param minBuyAmount 要求最低兑换到的ETH数量
     */
    function buyETH(address sellToken, uint256 sellAmount, uint256 minBuyAmount) external {
        RNT(sellToken).burn(msg.sender, sellAmount);
        (bool ok,) = payable(msg.sender).call{ value: minBuyAmount }("");
        require(ok, "refund failed");
    }
}

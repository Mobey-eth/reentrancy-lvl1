// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

contract Bank {
    using Address for address payable;
    mapping(address => uint256) public balanceOf;

    function getPoolBal() external view returns (uint256) {
        return address(this).balance;
    }

    // deposit ether funds
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    // withdraw ether funds
    function withdraw() external {
        // require(balanceOf[msg.sender] >= _amount, "Not enough fundss ma boi!!");

        /*
            (bool success, ) = payable(msg.sender).call{value: _amount}("");
            require(success);
        METHOD 2
            payable(msg.sender).sendValue(_amount);
         */
        uint256 _amount = balanceOf[msg.sender];
        require(balanceOf[msg.sender] >= _amount, "Not enough fundss ma boi!!");
        // for some reason '.transfer' couldn't be reentered...
        payable(msg.sender).sendValue(_amount);
        balanceOf[msg.sender] = 0;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => uint256) private balances;

    event Deposit(address indexed user, uint256 amount, uint256 newBalance);

    function deposit(uint256 amount) public returns (uint256) {
        require(amount > 0, "Deposit amount must be greater than 0");

        balances[msg.sender] += amount;

        emit Deposit(msg.sender, amount, balances[msg.sender]);

        return balances[msg.sender];
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function verifyBalanceIncreases(uint256 initialBalance, uint256 depositAmount)
        public
        pure
        returns (bool)
    {
        require(depositAmount > 0, "Deposit amount must be greater than 0");
        uint256 newBalance = initialBalance + depositAmount;

        assert(newBalance >= initialBalance);
        assert(newBalance == initialBalance + depositAmount);

        return true;
    }
}

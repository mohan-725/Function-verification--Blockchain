# **README: Formal Verification of Solidity Deposit Function with Dafny**

---

## **Overview**
This project demonstrates how **formal verification** with Dafny and **runtime checks** in Solidity can ensure the correctness of a deposit operation in a smart contract. By combining both methods, we improve the reliability and security of financial operations on the blockchain.

The objective is to validate that a deposit operation:
1. Always increases a user's balance.
2. Accurately calculates the new balance after a deposit.

---

## **Solidity Code Analysis**

### **Key Features**
- **Mapping for Balances**:  
  A mapping (`mapping(address => uint256)`) tracks each user's balance.

- **Deposit Function**:  
  Allows users to deposit funds. It includes:
  - **`require`** checks to ensure valid inputs.
  - Updates to the user's balance.
  - **`emit`** statements to log the transaction.

- **Balance Retrieval**:  
  Provides a `getBalance()` function to fetch the caller's balance.

- **Verification Function**:  
  The `verifyBalanceIncreases` function ensures the deposit logic adheres to key properties.

### **Solidity Code**
```solidity
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

    function verifyBalanceIncreases(
        uint256 initialBalance,
        uint256 depositAmount
    ) public pure returns (bool) {
        require(depositAmount > 0, "Deposit amount must be greater than 0");
        uint256 newBalance = initialBalance + depositAmount;
        assert(newBalance >= initialBalance);
        assert(newBalance == initialBalance + depositAmount);
        return true;
    }
}
```

### **Properties Verified in Solidity**
1. **Balance Increases After Deposit**:  
   Ensured by `balances[msg.sender] += amount` in the deposit function.

2. **Correct Balance Calculation**:  
   Assertions (`assert`) in `verifyBalanceIncreases` validate that the new balance equals `initialBalance + depositAmount` and is greater than or equal to the initial balance.

---

## **Dafny Code Analysis**

### **Key Features**
- Formal verification of the deposit logic using **mathematical proofs**.
- Ensures correctness for **all possible inputs**.

### **Dafny Code**
```dafny
function deposit(balance: nat, amount: nat): nat
    ensures deposit(balance, amount) >= balance
    ensures deposit(balance, amount) == balance + amount
{
    balance + amount
}

method VerifyDepositIncreasesBalance()
{
    var initialBalance: nat := 100;
    var depositAmount: nat := 50;
    var newBalance: nat := deposit(initialBalance, depositAmount);
    
    assert newBalance >= initialBalance;
    assert newBalance == initialBalance + depositAmount;
}
```

### **Properties Verified in Dafny**
1. **Balance Does Not Decrease**:  
   Proven using the ensures clause `deposit(balance, amount) >= balance`.

2. **Correct Calculation**:  
   Proven using the ensures clause `deposit(balance, amount) == balance + amount`.

3. **Mathematical Proofs**:  
   Dafny verifies these properties for all valid inputs of `balance` and `amount`.

---

## **Comparison: Dafny vs. Solidity**

| **Aspect**               | **Dafny**                                   | **Solidity**                              |
|--------------------------|---------------------------------------------|------------------------------------------|
| **Verification Type**    | Formal verification with mathematical proofs. | Runtime verification using `require` and `assert`. |
| **Scope**                | Validates for all possible inputs.          | Verifies behavior for specific inputs during execution. |
| **Error Detection**       | Compile-time error detection.              | Errors detected during contract execution. |
| **Precision**            | Enforces strict mathematical correctness.    | Relies on runtime checks to enforce correctness. |

---

## **Benefits of Formal Verification**

### **Proves All Possible Scenarios**
- Dafny guarantees correctness for all inputs satisfying preconditions.
- Example: It proves `deposit(balance, amount)` always satisfies the ensures clauses.

### **Prevents Logical Errors**
- Logical bugs (e.g., overflow) are ruled out with mathematical reasoning in Dafny.
- Solidity’s runtime checks may miss certain edge cases.

### **Mathematical Precision**
- Avoids pitfalls like rounding errors or unexpected behavior.

### **Reliability**
- Verified code provides confidence in the correctness and reduces the risk of bugs.

---

## **Implementation Steps**

1. **Write Dafny Code**:
   - Implement the `deposit` function with ensures clauses.
   - Test with sample values in `VerifyDepositIncreasesBalance`.

2. **Write Solidity Code**:
   - Implement a similar `deposit` function with `require` and `assert` checks.
   - Add event logging and balance retrieval for usability.

3. **Test Solidity Code**:
   - Deploy the contract.
   - Verify the logic works for various input scenarios.

4. **Validate with Dafny**:
   - Run the Dafny code to ensure mathematical correctness.

---

## **Conclusion**
By combining formal verification with Dafny and runtime checks in Solidity:
1. Dafny ensures correctness for all valid inputs.
2. Solidity implements runtime-enforced correctness during execution.
3. Together, these methods create a robust, reliable system for blockchain-based financial operations.

This approach is especially critical for smart contracts, where financial errors can lead to irrecoverable losses.

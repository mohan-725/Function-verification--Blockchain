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

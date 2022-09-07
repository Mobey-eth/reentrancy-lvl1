from brownie import Bank, Attacker, accounts, web3


def test_bank_rentrancy():
    account = accounts[0]
    account2 = accounts[1]
    attacker = accounts[9]

    value = web3.toWei(60, "ether")
    value2 = web3.toWei(50, "ether")
    bank = Bank.deploy({"from": account})
    attackerContract = Attacker.deploy(bank.address, {"from": attacker})

    bank.deposit({"from": account, "value": value})
    bank.deposit({"from": account2, "value": value2})
    assert bank.balanceOf(account.address) == value
    print("The poool Balnceeoor: ", web3.fromWei(bank.getPoolBal(), "ether"))
    # print(bank.balance())

    bank.withdraw({"from": account2})
    print(bank.balanceOf(account2.address))
    print("The neu poool Balnceeoor: ", web3.fromWei(bank.getPoolBal(), "ether"))
    return bank, attacker, attackerContract


def test_attacker():
    attackAmount = web3.toWei(10, "ether")
    bank, attacker, attackerContract = test_bank_rentrancy()
    print(" Attacker balance is = ", attacker.balance())
    print(" Performing Attack!!")
    attackerContract.execute({"from": attacker, "value": attackAmount})

    print("--------------AfterMath of ATTACK!---------------")
    print("The Bank Balnceeoor: ", web3.fromWei(bank.getPoolBal(), "ether"))
    print(" new Attacker balance is = ", attacker.balance())

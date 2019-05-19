[Mining blocks](docs/mining-blocks.md)

Making transactions
===================
Now that the coinbase has some money, we can play with transactions.

Coinbase will be sending money to an other account. Let's create it.

## Create a second account
```javascript
> personal.newAccount()
Passphrase: 
Repeat passphrase: 
"0xd74a59b538598bbfb1165accd1b00676cb098d86"
> eth.accounts
["0x2c98842bfc7434f2272d8940b4e26f48dbec2878", "0xd74a59b538598bbfb1165accd1b00676cb098d86"]
> eth.accounts[0] == eth.coinbase
true
> second = eth.accounts[1]
"0xd74a59b538598bbfb1165accd1b00676cb098d86"
> eth.getBalance(second)
0
```

Let's transfer some Ether from `coinbase` to `second`.

```javascript
> eth.sendTransaction({ from: eth.coinbase, to: second, value: web3.toWei(10, "ether")})
Error: authentication needed: password or unlock
    at web3.js:3143:20
    at web3.js:6347:15
    at web3.js:5081:36
    at <anonymous>:1:1
```

## Unlocking an account
In order to use the coinbases' private key, the account must be unlocked with the password:

```javascript
> personal.unlockAccount(eth.coinbase)
Unlock account 0x2c98842bfc7434f2272d8940b4e26f48dbec2878
Passphrase: 
true
```

The account will be unlocked for 5 minutes only. It's still possible to specify a different timeout with:

```javascript
> personal.unlockAccount(address, password, duration)
```

## Transfering Ethers
With Coinbase unblocked, let's try again sending the transaction:

```javascript
> eth.sendTransaction({ from: eth.coinbase, to: second, value: web3.toWei(10, "ether")})
"0xb82c851cd472051cad625f4d91f3271d14d25a2824dcbdff99f20abf862508ef"
```

Despite the transaction has been successfully created, `coinbase`'s and `second`'s balance have not changed at all:

```javascript
> eth.getBalance(eth.coinbase)
298000000000000000000
> eth.getBalance(second)
0
```



[Mining blocks](docs/mining-blocks.md)

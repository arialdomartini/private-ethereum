[Mining blocks](mining-blocks.md) :: [Including the transaction in a mined block](mining-transactions.md)

Creating transactions
=====================
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
With Coinbase unlocked, let's try again sending the transaction:

```javascript
> transaction = eth.sendTransaction({ from: eth.coinbase, to: second, value: web3.toWei(10, "ether")})
"0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646"
```

Notice how only the sender's account needed to be unlocked: in fact, it's only the sender that needs to access its private key; the receiver's private key so far is not involved at all.

Also, notice that despite the transaction has been successfully created, `coinbase`'s and `second`'s balance have not changed at all:

```javascript
> eth.getBalance(eth.coinbase)
298000000000000000000
> eth.getBalance(second)
0
```

In fact, the transaction is still pending, as it has not yet been included in any mined block:

```javascript
> eth.pendingTransactions
[{
    blockHash: null,
    blockNumber: null,
    from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
    gas: 90000,
    gasPrice: 1000000000,
    hash: "0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646",
    input: "0x",
    nonce: 0,
    r: "0xc84600f15ef991303fb6176403e5c0b3c5dfe0063c9dbc141d4d925783366480",
    s: "0x61639418219493e306ac60fa0c09a5732d1d5e63ed3a907483b0f955942dc2bc",
    to: "0xd74a59b538598bbfb1165accd1b00676cb098d86",
    transactionIndex: 0,
    v: "0xe9",
    value: 10000000000000000000
}]
> eth.pendingTransactions[0].blockNumber
null
> eth.pendingTransactions[0].transactionIndex
0
```

## Transaction Parameter Object
We created the transaction providing only few fields of a structure called Transaction Parameter Objects

```javascript
{ from: eth.coinbase, to: second, value: web3.toWei(10, "ether")}`
```

and we ended up with a much more complex object, comprising more details.


```javascript
> eth.pendingTransactions
[{
    blockHash: null,
    blockNumber: null,
    from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
    gas: 90000,
    gasPrice: 1000000000,
    hash: "0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646",
    input: "0x",
    nonce: 0,
    r: "0xc84600f15ef991303fb6176403e5c0b3c5dfe0063c9dbc141d4d925783366480",
    s: "0x61639418219493e306ac60fa0c09a5732d1d5e63ed3a907483b0f955942dc2bc",
    to: "0xd74a59b538598bbfb1165accd1b00676cb098d86",
    transactionIndex: 0,
    v: "0xe9",
    value: 10000000000000000000
}]
```

In this structure, `v`, `r` and `s` are the transaction signature: `r` and `s` are the outputs of the ECDSA signature, while `v` is the recovery id. They can be used to retrieve the sender's public key.

The value `nonce: 0` indicates this is our first transaction: all the transactions of an account are sequentially numerated, to assist miners in ordering all the transactions.

## Deleting a transaction
Note: once a transaction has been created, it can't be deleted, but it's always possible to overwrite it, as long as it hasn't been included into any mined block. To overwrite the original transaction, we need to rebroadcast the same transaction with the same nonce, but increasing the gase price at least of `10%`.

So, to cancel a transaction, we could rewrite it setting the value to `0`:

```javascript
> eth.sendTransaction({ from: eth.coinbase, to: second, value: 0, nonce: '0', gasPrice: 2000000000, gasLimit: 100000})
"0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646"
```

Create a couple additional transactions and then delete them with the technique above. Let's see if they will be included in a mine block or if they will be just deleted. 

[Mining blocks](mining-blocks.md) :: [Including the transaction in a mined block](mining-transactions.md)

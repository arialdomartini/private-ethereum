[Creating transactions](making-transactions.md) : [Connecting nodes](connecting-nodes.md)

## Including the transaction in a mined block
Our pending transaction has been automatically included in tre Transaction Pool, from which the pending transactions are taken for the inclusion in a block.

```javascript
> txpool.content.pending
{
  0x2c98842bfc7434f2272D8940b4e26f48dBec2878: {
    0: {
      blockHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
      blockNumber: null,
      from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
      gas: "0x15f90",
      gasPrice: "0x77359400",
      hash: "0xa27aad2b83feefe1145191ad32197f882a1b6f4e27490b9c4927c2c9763f40dc",
      input: "0x",
      nonce: "0x0",
      r: "0x930f00207662e705004b498c711e683a4489dcbb5df75d021f5d44359c9fa87a",
      s: "0x31cbd9da1eaec32f093d260678b5f86a0377edaedfb85cf5000ad3b70d09e7d0",
      to: "0xd74a59b538598bbfb1165accd1b00676cb098d86",
      transactionIndex: "0x0",
      v: "0xe9",
      value: "0x0"
    }
  }
}
> 
```

There are several hints that the transaction has not confirmed yet:

* the transaction is included in the list returned by `eth.pendingTransactions`;
* the transaction appears also in the list returned by `txpool.content.pending`;
* the transaction fields `blockHash` and `blockNumber` are not set yet;
* the Transaction Receipt is still null:

```javascript
> eth.getTransactionReceipt(eth.pendingTransactions[0].hash)
null
```

* the sender's and receiver's balance don't reflect the transaction execution;

We need a miner to confirm the transaction. Let's start the mining process again:

```javascript
> miner.start(1)
null
> eth.mining
true
```

After few seconds the transaction will have been removed from the list of pending transactions, and we could stop the miner:

```javascript
> txpool.content.pending
{}
> eth.pendingTransactions
[]
> miner.stop()
null
```

We can verify that the 10 Ethers have been transferred from `coinbase` to `second`:

```javascript
> web3.fromWei(eth.getBalance(eth.coinbase), "ether")
326
> web3.fromWei(eth.getBalance(second), "ether")
10
```

Despite having spent `10` Ethers, `coinbase` is richer than before as it mined some additional blocks.

That the transaction has been mined is also apparent from the existence of a transaction receipt:

```javascript
> eth.getTransactionReceipt(transaction)
{
  blockHash: "0x20d8584d70fd9863067340c6789811561540ae84218b2f57a5aca3f10480c804",
  blockNumber: 150,
  contractAddress: null,
  cumulativeGasUsed: 63000,
  from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
  gasUsed: 21000,
  logs: [],
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  status: "0x1",
  to: "0xd74a59b538598bbfb1165accd1b00676cb098d86",
  transactionHash: "0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646",
  transactionIndex: 2
}
```

The Transactoin Receipt also reports that the transaction costed `21000` gas:

```javascript
> eth.getTransactionReceipt(transaction).gasUsed
21000
```

Let's inspect the transaction again:

```javascript
> transaction
"0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646"
> eth.getTransaction(transaction)
{
  blockHash: "0x20d8584d70fd9863067340c6789811561540ae84218b2f57a5aca3f10480c804",
  blockNumber: 150,
  from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
  gas: 90000,
  gasPrice: 1000000000,
  hash: "0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646",
  input: "0x",
  nonce: 2,
  r: "0xc84600f15ef991303fb6176403e5c0b3c5dfe0063c9dbc141d4d925783366480",
  s: "0x61639418219493e306ac60fa0c09a5732d1d5e63ed3a907483b0f955942dc2bc",
  to: "0xd74a59b538598bbfb1165accd1b00676cb098d86",
  transactionIndex: 2,
  v: "0xe9",
  value: 10000000000000000000
}
```

Notice how some of the values that were unset before the mining process now do have a value: namely, `blockHash`, `blockNumber` and `transactionIndex`.


Let's see which other transactions have been included in the block referenced in the transaction as `blockHash`:

```javascript
> eth.getBlock(eth.getTransaction(transaction).blockHash).transactions
["0xa27aad2b83feefe1145191ad32197f882a1b6f4e27490b9c4927c2c9763f40dc", "0x6d82777bef247d13a8bf9c1d42683a7432d010178e7bb249a32c87bb46d551fb", "0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646"]
```

There are 3 of them. One is the transaction with which `coinbase` moved `10` Ethers to `second`. The other 2 must be the ones we created and then we deleted:

```javascript
> eth.getBlock(eth.getTransaction(transaction).blockHash).transactions[1]
"0x6d82777bef247d13a8bf9c1d42683a7432d010178e7bb249a32c87bb46d551fb"
> eth.getTransaction(eth.getBlock(eth.getTransaction(transaction).blockHash).transactions[1])
{
  blockHash: "0x20d8584d70fd9863067340c6789811561540ae84218b2f57a5aca3f10480c804",
  blockNumber: 150,
  from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
  gas: 90000,
  gasPrice: 2000000000,
  hash: "0x6d82777bef247d13a8bf9c1d42683a7432d010178e7bb249a32c87bb46d551fb",
  input: "0x",
  nonce: 1,
  r: "0xa55ae34a3a703da475e6f4a7407ee8b25371a32b2c325895e68ff44658af7063",
  s: "0x584b9087d0a0fa1f1a480b879620ec28b88714ddecef5778e8d82765982308e5",
  to: "0xd74a59b538598bbfb1165accd1b00676cb098d86",
  transactionIndex: 1,
  v: "0xe9",
  value: 0
}
```

The `value: 0` confirms this.


Another way to access mined transactions is by using the `blockNumber` value:

```javascript
> eth.getTransactionFromBlock(150, 1)
{
  blockHash: "0x20d8584d70fd9863067340c6789811561540ae84218b2f57a5aca3f10480c804",
  blockNumber: 150,
  from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
  gas: 90000,
  gasPrice: 2000000000,
  hash: "0x6d82777bef247d13a8bf9c1d42683a7432d010178e7bb249a32c87bb46d551fb",
  input: "0x",
  nonce: 1,
  r: "0xa55ae34a3a703da475e6f4a7407ee8b25371a32b2c325895e68ff44658af7063",
  s: "0x584b9087d0a0fa1f1a480b879620ec28b88714ddecef5778e8d82765982308e5",
  to: "0xd74a59b538598bbfb1165accd1b00676cb098d86",
  transactionIndex: 1,
  v: "0xe9",
  value: 0
}
> eth.getTransactionFromBlock(150, 2)
{
  blockHash: "0x20d8584d70fd9863067340c6789811561540ae84218b2f57a5aca3f10480c804",
  blockNumber: 150,
  from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
  gas: 90000,
  gasPrice: 1000000000,
  hash: "0x74bcc261f56295db80c63172476c35df4c2e44776f54829d8e4c507af1092646",
  input: "0x",
  nonce: 2,
  r: "0xc84600f15ef991303fb6176403e5c0b3c5dfe0063c9dbc141d4d925783366480",
  s: "0x61639418219493e306ac60fa0c09a5732d1d5e63ed3a907483b0f955942dc2bc",
  to: "0xd74a59b538598bbfb1165accd1b00676cb098d86",
  transactionIndex: 2,
  v: "0xe9",
  value: 10000000000000000000
}
```

Notice how, despite being empty, increased the `transactionIndex`. Also, the transaction costed us `21000` gas, even if it moved no Ethers:

```javascript
> eth.getTransactionReceipt(eth.getTransactionFromBlock(hash,0).hash).gasUsed
21000
```


## Raw transactions
The json structures we got using the console are just a representation of the binary, raw data stored in the blockchain, which can be retrieved with `eth.getRawTransaction`:

```javascript
> eth.getRawTransaction(transaction)
"0xf86d02843b9aca0083015f9094d74a59b538598bbfb1165accd1b00676cb098d86888ac7230489e800008081e9a0c84600f15ef991303fb6176403e5c0b3c5dfe0063c9dbc141d4d925783366480a061639418219493e306ac60fa0c09a5732d1d5e63ed3a907483b0f955942dc2bc"`
```

It's really the same transaction:

```javascript
> web3.sha3(eth.getRawTransaction(transaction), {encoding: "hex"}) == transaction
true
```

We could try to resend it:

```javascript
> eth.sendRawTransaction(eth.getRawTransaction(transaction))
Error: nonce too low
    at web3.js:3143:20
    at web3.js:6347:15
    at web3.js:5081:36
    at <anonymous>:1:1
```

from which we untuit that the "nonce" is a strictly, monotonous increasing value representing the number of transactions created by an account.

[Creating transactions](making-transactions.md) : [Connecting nodes](connecting-nodes.md)

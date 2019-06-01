[Bytecode](bytecode.md)
# A first, simple program
Let's try to write and execute a dead simple program, directly writing its bytecode, and then pushing it into the blockchain with a transaction.

## Source code

EVM is a stack based VM, so the assembly code is not that different from other CPU's ones.

```assembly
PUSH1 0x03
PUSH1 0x05
ADD          // 3 5 + => 8
PUSH1 0x02
MUL          // 8 2 * => 16
PUSH1 0x00
SSTORE       // store 16 in memory location 0
```

Replacing each command with its opcode (we can use again [the table](https://github.com/djrtwo/evm-opcode-gas-costs/blob/master/opcode-gas-costs_EIP-150_revision-1e18248_2017-04-12.csv) we saw before):

```assembly
0x60 0x03
0x60 0x05
0x01
0x60 0x02
0x02
0x60 0x00
0x55
```

and packing all the hex numbers to a single string, we get:

```assembly
0x6003600501600202600055
```

## Sending the bytecode to the blockchain
Now it's time to create a transaction containing this bytecode string:

```javascript
> var bytecode = "0x6003600501600202600055"
undefined
> var transactionWithCode = eth.sendTransaction({ from: eth.coinbase, data: bytecode})
Error: authentication needed: password or unlock
    at web3.js:3143:20
    at web3.js:6347:15
    at web3.js:5081:36
    at <anonymous>:1:27
> personal.unlockAccount(eth.coinbase)
Unlock account 0x2c98842bfc7434f2272d8940b4e26f48dbec2878
Passphrase: 
true
> var transactionWithCode = eth.sendTransaction({ from: eth.coinbase, data: bytecode})
undefined
> transactionWithCode
"0xf906dad8d9328b75a656b3346ad7a0bc1eede32bacc3919af84ca9c856253b39"
```

The node logged the following:

```bash
$docker logs ethereum-node --tail 1
INFO [06-01|04:55:49.387] Submitted contract creation
   fullhash=0xf906dad8d9328b75a656b3346ad7a0bc1eede32bacc3919af84ca9c856253b39
   contract=0x9755c8347d5C61535A68Ee5e0e5dD2468aC45Bb7
```

The transaction is still pending:

```javascript
> txpool.content.pending
{
  0x2c98842bfc7434f2272D8940b4e26f48dBec2878: {
    3: {
      blockHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
      blockNumber: null,
      from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
      gas: "0x15f90",
      gasPrice: "0x3b9aca00",
      hash: "0xf906dad8d9328b75a656b3346ad7a0bc1eede32bacc3919af84ca9c856253b39",
      input: "0x6003600501600202600055",
      nonce: "0x3",
      r: "0x4bff1abc02f1bab09d784d1c844f3bb6e63ba1236ef8058514547fe926ee623d",
      s: "0x38201ca913f5bc9f092c91a2912ffdce81ab400c97b6f7f0bb9e1a5eec50b26c",
      to: null,
      transactionIndex: "0x0",
      v: "0xea",
      value: "0x0"
    }
  }
}
```

Let's mine it:

```javascript
> miner.start(1)
null
> miner.stop()
null
> txpool.content.pending
{}
> eth.getTransactionReceipt(transactionWithCode)
{
  blockHash: "0xc461cd4259d21bd84a7128fa1e56bc8ecc0f7b2c9ad5935c83a5b3a9ace3449f",
  blockNumber: 169,
  contractAddress: "0x9755c8347d5c61535a68ee5e0e5dd2468ac45bb7",
  cumulativeGasUsed: 73704,
  from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
  gasUsed: 73704,
  logs: [],
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  status: "0x1",
  to: null,
  transactionHash: "0xf906dad8d9328b75a656b3346ad7a0bc1eede32bacc3919af84ca9c856253b39",
  transactionIndex: 0
}
```

The important information, here, is the `contractAddress`, which we can use to address the code and verify it has been executed:

```javascript
> eth.getStorageAt(eth.getTransactionReceipt(transactionWithCode).contractAddress)
"0x0000000000000000000000000000000000000000000000000000000000000010"
```

`0x10` is actually the value `16` we permanently stored at location `0x0`.<br/>
Notice that to execute this code we spent `73704` gas:

```javascript
> eth.getTransactionReceipt(transactionWithCode).gasUsed
73704
```

[Bytecode](bytecode.md)

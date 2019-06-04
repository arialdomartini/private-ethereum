[A first, simple program](contract-1.md)

# Another contract
So, our first contract stored the value `0x10` in the storage location `0x00`. Let's try to overwrite this value with another program. We won't succeed, but it's important to understand why.<br/>
Let's use this code:

```assembly
PUSH1 0x11
PUSH1 0x00
SSTORE
```

The corresponding bytecode is:

```assembly
0x6011600055
```

Let's try to send this data code with a transaction, using as target the contract address of our first program:

```javascript
> var transactionWithCode2 = eth.sendTransaction({ from: eth.coinbase, to: eth.getTransactionReceipt(transactionWithCode).contractAddress, data: bytecode2})
undefined
> > miner.start(1)

null
> txpool.content.pending

{
  0x2c98842bfc7434f2272D8940b4e26f48dBec2878: {
    4: {
      blockHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
      blockNumber: null,
      from: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
      gas: "0x15f90",
      gasPrice: "0x3b9aca00",
      hash: "0x355e84497b4b44270a44bc9d1615fc967a5b3557003c558df10e2a87b23a332f",
      input: "0x6011600055",
      nonce: "0x4",
      r: "0xa5e0725dc6fa9189cd01be7e8cc7336b50ffeddbec4851f7f12e45bd4e59aad4",
      s: "0x62471676e54921c157dd324e0649837ce383d0bb1a37a81a96cae785fc5e6071",
      to: "0x9755c8347d5c61535a68ee5e0e5dd2468ac45bb7",
      transactionIndex: "0x0",
      v: "0xe9",
      value: "0x0"
    }
  }
}
> txpool.content.pending
{}
> miner.stop()
null
```

Let's verify the first contract's storage:

```javascript
> eth.getStorageAt(eth.getTransactionReceipt(transactionWithCode).contractAddress)
"0x0000000000000000000000000000000000000000000000000000000000000010"
```

It didn't change. Why?

## Contract creation and invocation

We created the first contract with:

```javascript
> var transactionWithCode = eth.sendTransaction({ from: eth.coinbase, data: bytecode})
```

* When the Transactin Parameter Object specifies no target, i.e. with `to: null`, then the `data: bytecode` is interpreted as the code of a contract to be created. And so it happened.

* When the transaction is sent to a specific address, the content of `data` is used as the payload for a contract invocation, not for a contract creation or modification.

Therefore, with our second

```javascript
> var transactionWithCode2 = eth.sendTransaction({ from: eth.coinbase, to: eth.getTransactionReceipt(transactionWithCode).contractAddress, data: bytecode2})
```

we haven't overwritten the first program, but we invoked its code, using as the payload the data `0x6011600055`.

## Contract code
What's the first program's code? Isn't it the `0x6003600501600202600055` corresponding to the assembly code we wrote?

```assembly
PUSH1 0x03
PUSH1 0x05
ADD
PUSH1 0x02
MUL
PUSH1 0x00
SSTORE
```

No, it isn't, and we can verify it with:

```javascript
> eth.getCode(eth.getTransactionReceipt(transactionWithCode).contractAddress)
"0x"
```

No code at all. This may sound surprising.

[A first, simple program](contract-1.md)

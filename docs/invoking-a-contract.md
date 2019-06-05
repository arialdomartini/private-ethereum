[Packing code](packing-code.md)

# Invoking a contract

Let's save the contract code in a variable:

```javascript
> var address3 = eth.getTransactionReceipt(transactionWithCode3).contractAddress
undefined
> address3
"0x5588cdbc6878e0d03aee78f4f00f4c113d525f83"
```

Let's send a transaction with some data to the contract address:

```javascript
> eth.getStorageAt(address3)
"0x0000000000000000000000000000000000000000000000000000000000000000"
> personal.unlockAccount(eth.coinbase)
Unlock account 0x2c98842bfc7434f2272d8940b4e26f48dbec2878
Passphrase: 
true
> eth.sendTransaction({to: address3, from: eth.coinbase, data: "0x22"})
"0x320545249904d877bf3733c8bdcbfc06038d612a3887bcd98cbeb53750ae61e4"
> miner.start(1)
null
> eth.getStorageAt(address3)
"0x2200000000000000000000000000000000000000000000000000000000000000"
```

Nice: the contract stored in its storage the data `0x22` we sent it through the transaction.

Notice how the value `0x22` has been right-padded with `0`s, up to `32` bytes.

## Sending `32` bytes

Let's try to send exactly `32` bytes:

```javascript
> var data32 = "0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
undefined
> eth.sendTransaction({to: address3, from: eth.coinbase, data: data32})
"0x22ee396a8f1c886fa1476c73a007b8ac9f2d043a7125606dd7d42f1f845eae41"
> txpool.content.pending
{}
> eth.getStorageAt(address3)
"0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
```
# Data overflow
And what if we send more than `32` bytes?

```javascript
> var data33 = "0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20"
undefined
> eth.sendTransaction({to: address3, from: eth.coinbase, data: data33})
"0x13f0601c05d08b7734ff3d810d1886ba773a9056e7bb1f67852989ceefcdc7c9"
> eth.getStorageAt(address3)
"0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
```

So, the `33`rd byte was removed. It is not even been stored in the next memory slot:

```javascript
> eth.getStorageAt(address3, 1)
"0x0000000000000000000000000000000000000000000000000000000000000000"
```

It has just been dropped out.

We are done with this experiment. We can stop the miner:

```javascript
> miner.stop()
null
```
[Packing code](packing-code.md)

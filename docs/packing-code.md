[Another contract](contract-2.md) :: [Invoking a contract](invoking-a-contract.md)
# Packing code

Let's write a contract that stores at address `0x00` whatever data is sent it through a transaction. We can use the command `CALLDATALOAD` to retrieve 32 bytes of data sent with a transaction and to push it to the stack.

```assembly
PUSH1 0x00
CALLDATALOAD
PUSH1 0x00
SSTORE
```

The program is not complete, because now we need to pack it to let the EVM unpack it bak and execute it at a later stage. To pack the bytecode, we must put some special code in front of it, the so called *constructor bytecode*.

This is the rational:

* When some code is sent with a transaction, it will be immediately executed; 
* The code will terminate when `RETURN` is found; at this point, the code is discarded;
* Whatever code remains in memory after the execution will be stored as the contract code;
* We will need to specify the EVM the address the contract code can be found at, and the contract code length in bytes, so it can copy it to the contract.

Here we go: we must find a way to copy some code in a memory position, so it will be retained after the code execution. In other words, the code initially sent with a transaction is the startup code: it is responsible to set up the initial state of the storage, and to copy the contract code in meory.

```assembly
// First, copy the bytecode to some memory slot:
PUSH1 <bytecode-lenght>
PUSH1 <bytecode-position-offset>
PUSH1 <memory-slot>       // memory slot where we want to send the code
CODECOPY                  // copy <bytecode-lenght> bytes of the code located at
                          // <bytecode-position-offset> to <memory-slot>

// Put the bytecode reference (its position and length) in memory
PUSH1 <bytecode-length>
PUSH1 <memory-slot>
RETURN

// The code
PUSH1 0x00
CALLDATALOAD
PUSH1 0x00
SSTORE
```

We need to find the values for `<bytecode-position-offset>`, `<bytecode-lenght>` and `<memory-slot>`.

* to get `<bytecode-lenght>`, let's compile the contract code:

```assembly
PUSH1 0x00
CALLDATALOAD
PUSH1 0x00
SSTORE
```
compiles to `0x600035600055`, there is `6` bytes long.<br/>
So, `<bytecode-length>` is `6`.

As for `<bytecode-position-offset>`, we must calculate how many bytes separate the first command

```assembly
// First, copy the bytecode to some memory slot:
PUSH1 <bytecode-lenght>
[...]
```

from the contract code:
```assembly
[...]
// The code
PUSH1 0x00
```

Let's see:

```assembly
// First, copy the bytecode to some memory slot:
00: PUSH1 <bytecode-lenght>
02: PUSH1 <bytecode-position-offset>
04: PUSH1 <memory-slot>       // memory slot where we want to send the code
06: CODECOPY                  // copy <bytecode-lenght> bytes of the code located at
                              // <bytecode-position-offset> to <memory-slot>

// Put the bytecode reference (its position and length) in memory
07: PUSH1 <bytecode-length>
09: PUSH1 <memory-slot>
0b: RETURN

// The code
0c: 0x600035600055
```

So, `<bytecode-position-offset>` is `0c`.

As for `<memory-slot>`, we can choose an arbitrary address. Let's choose `0x00`.

```assembly
// First, copy the bytecode to some memory slot:
00: PUSH1 0x06
02: PUSH1 0x0c
04: PUSH1 0x00            // memory slot where we want to send the code
06: CODECOPY              // copy <bytecode-lenght> bytes of the code located at
                          // <bytecode-position-offset> to <memory-slot>

// Put the bytecode reference (its position and length) in memory
07: PUSH1 0x06
09: PUSH1 0x00
0b: RETURN

// The code
0c: 0x600035600055
```

This compiles to:

```assembly
0x6006600c60003960066000f3600035600055
```

Let's send to to the blockchain with a transaction:


```javascript
> var bytecode3 = "0x6006600c60003960066000f3600035600055"
undefined
> var transactionWithCode3 = eth.sendTransaction({ from: eth.coinbase, data: bytecode3 })
undefined
> miner.start(1)
null
> txpool.content.pending
{}
> miner.stop()
null
```

Let's first verify if this contract has a code contract:

```javascript
> eth.getCode(eth.getTransactionReceipt(transactionWithCode3).contractAddress)
"0x600035600055"
```

That's nice: previously we got a `0x00`. Also, this is exactly what we wrote in the source code at:

```assembly
// The code
0c: 0x600035600055
```

It sounds we finally managed to store some contract code in the blockchain.<br/>
Now it's time to invoke it.

[Another contract](contract-2.md) :: [Invoking a contract](invoking-a-contract.md)

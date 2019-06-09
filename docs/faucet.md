[Introduction](solidity-introduction.md) :: [Interacting with the faucet contract](faucet-interact.md)

# Deploying a faucet

A faucet is a smart contract that holds some Ethers and on demand sends some of them to a requester, possibly under some specific rules (for example, limiting the provided number of Ether per second).

## Compiling the code

Here's the [source code](../src/Faucet.sol).

There are 2 main possible output of the compilation: the bytecode and the ABI contract.

* the bytecode is the assembly machine code for the EVM to run.
* the ABI contract is a human and machine readable representation of the interface for interacting with the contract, that is, its public invocable methods.

The 2 outputs can be generated respectively with `solc --bin <source.sol>` and `solc --abi <source.sol>`, but we are going to generate both of them in one shot using the option `solc --combined-json abi,bin <source.sol>`:

```bash
$./compiler.sh
/src $ cd src/
Faucet.sol  Owned.bin   Owned.sol
/src/src $ solc Faucet.sol 
Compiler run successful, no output requested.
/src/src $ solc --combined-json abi,bin Faucet.sol > Faucet.json
/src/src $ cat Faucet.json 
{"contracts":{"Faucet.sol:Faucet":{"abi":"[{\"constant\":true,\"inputs\":[],\"name\":\"getBalance\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"target\",\"type\":\"address\"}],\"name\":\"sendWei\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"withdrawWei\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getSendAmount\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"killMe\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"constructor\"},{\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"fallback\"}]","bin":"6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550670de0b6b3a764000060018190555061034a806100626000396000f3fe6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506101ba565b005b3480156100df57600080fd5b506100e8610206565b005b3480156100f657600080fd5b506100ff610251565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b50610156610276565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610280565b604051808215151515815260200191505060405180910390f35b60003073ffffffffffffffffffffffffffffffffffffffff1631905090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610202573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f1935050505015801561024e573d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102db57600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a72305820c619c8ebedfa1e177f3af01e378d29465fc6f77e4d71942f9cfa0f2bf7209fd664736f6c63430005090032"}},"version":"0.5.9+commit.c68bc34e.Linux.g++"}}
```

The compiled bytecode is contained in the node `bin`:

```javascript
/src/src # cat Faucet.json | jq  '. "contracts"."Faucet.sol:Faucet"."bin"'
"6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffff
ffffffffffffffffffffffffffffff160217905550670de0b6b3a764000060018190555061034a806100626000396000f
3fe6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e
146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b348015610063576
00080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b50
6100d1600480360360208110156100a557600080fd5b81019080803573fffffffffffffffffffffffffffffffffffffff
f1690602001909291905050506101ba565b005b3480156100df57600080fd5b506100e8610206565b005b3480156100f6
57600080fd5b506100ff610251565b604051808273ffffffffffffffffffffffffffffffffffffffff1673fffffffffff
fffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b50610156
610276565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610280565b6
04051808215151515815260200191505060405180910390f35b60003073ffffffffffffffffffffffffffffffffffffff
ff1631905090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc60015490811502906040516000604
05180830381858888f19350505050158015610202573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffff
ffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f1935050505015801561024e5
73d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681
565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff167
3ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102db
57600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673fffffffffffffff
fffffffffffffffffffffffff16fffea265627a7a72305820c619c8ebedfa1e177f3af01e378d29465fc6f77e4d71942f
9cfa0f2bf7209fd664736f6c63430005090032"
```

The ABI is a JSON representation of the interface to invoke in a friendly way the contract:

```bash
/src/src # cat Faucet.json | jq  '. "contracts"."Faucet.sol:Faucet"."abi"' | jq -r | jq
[
  {
    "constant": true,
    "inputs": [],
    "name": "getBalance",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "target",
        "type": "address"
      }
    ],
    "name": "sendWei",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "withdrawWei",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getSendAmount",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "killMe",
    "outputs": [
      {
        "name": "",
        "type": "bool"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "payable": true,
    "stateMutability": "payable",
    "type": "constructor"
  },
  {
    "payable": true,
    "stateMutability": "payable",
    "type": "fallback"
  }
]
```

Let's deploy the Faucet smart contract to the blockchain.

## Deploying the bytecode

Let's copy the JSON result of the compilation (sorry, I haven't found a way to read a file from `geth`):

```javascript
> var compiled = '{"contracts":{"Faucet.sol:Faucet":{"abi":"[{\"constant\":true,\"inputs\":[],\"name\":\"getBalance\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"target\",\"type\":\"address\"}],\"name\":\"sendWei\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"withdrawWei\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getSendAmount\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"killMe\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"constructor\"},{\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"fallback\"}]","bin":"6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550670de0b6b3a764000060018190555061034a806100626000396000f3fe6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506101ba565b005b3480156100df57600080fd5b506100e8610206565b005b3480156100f657600080fd5b506100ff610251565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b50610156610276565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610280565b604051808215151515815260200191505060405180910390f35b60003073ffffffffffffffffffffffffffffffffffffffff1631905090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610202573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f1935050505015801561024e573d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102db57600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a72305820c619c8ebedfa1e177f3af01e378d29465fc6f77e4d71942f9cfa0f2bf7209fd664736f6c63430005090032"}},"version":"0.5.9+commit.c68bc34e.Linux.g++"}'
```

From this complete JSON we will need to extract 2 information:

* the bytecode, contained in `bin`; we will use this information as the `data` of a transaction;
* the contract, represented as a JSON string in `abi`; this is the Javascript contract to use for interacting with the smart contract, and it is usually referred to as *Web3 contract object*.

### Getting the bytecode

Let's get the bytecode:

```javascript
> var bytecode = compiled.contracts["Faucet.sol:Faucet"].bin
undefined
> bytecode
"6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550670de0b6b3a7640000600181905550610330806100626000396000f3fe6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506101a0565b005b3480156100df57600080fd5b506100e86101ec565b005b3480156100f657600080fd5b506100ff610237565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b5061015661025c565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610266565b604051808215151515815260200191505060405180910390f35b600090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f193505050501580156101e8573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610234573d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102c157600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a723058203af177114c98fdf5b5b53f1ec8ad02f0690b64711d8434d77c33b8c1f0ece9bd64736f6c63430005090032"
```

### Building the Web3 contract object

Run:

```javascript
> var contract = eth.contract(JSON.parse(compiled.contracts["Faucet.sol:Faucet"].abi))
```

### Deploying the Faucet with a Transaction
We have all that's needed to deploy the Faucet through a transaction. Notice that we cannot reuse [the previous approach](packing-code.md), when we sent the bytecode with:

```javascript
> var transactionWithCode2 = eth.sendTransaction({ 
    from: eth.coinbase, 
    to: eth.getTransactionReceipt(transactionWithCode).contractAddress, 
    data: bytecode2 })
```

In the previous case, the bytecode contained the setup code needed to copy the contract code to memory:

```assembly
PUSH1 <bytecode-lenght>
PUSH1 <bytecode-position-offset>
PUSH1 <memory-slot>       // memory slot where we want to send the code
CODECOPY                  // copy <bytecode-lenght> bytes of the code located at
                          // <bytecode-position-offset> to <memory-slot>

// Put the bytecode reference (its position and length) in memory
PUSH1 <bytecode-length>
PUSH1 <memory-slot>
RETURN
```

In our case, all the bytecode we have is the one produced by `solc` during the compilation.

Fortunately, we can use the Web3 contract object (derived by the ABI) to build an instance of the contract with `.new()` or with `.at()`, and deploy it instead. All the code necessary to load the contract code in memory will be automatically handled.

The method Faucet instance's `new()` method takes a Deploy Transaction Object, and it will create the needed transaction.

```javascript
> var deployTransactionObject = { from: eth.coinbase, data: "0x" + bytecode, value: web3.toWei(1, "ether"), gas: 1000000 };
undefined
> var faucetInstance = contract.new(deployTransactionObject);
undefined
```

* we defined no `to:` field, and this is interpreted as a contract creation;
* the `value` field refers to the amount of Ether sent along with the transaction; with `value: web3.toWei(1, "ether")` we gave the faucet `1` initial ether
* the `gas` fields specifies the maximum amount of gas we are willing to pay the miner to deploy this contract.

`faucetInstance` contains 2 important fields: `abi` and `address`. `abi` is exactly the same interface generated by the compilation with the option `--combined-json abi` in 

```bash
solc --combined-json abi,bin Faucet.sol > Faucet.json
```

`address` is the deployment address we can use to invoke methods of the contract; it is just like the pointer of a class instance.</br>
Ours is still `undefined`, since the transaction `faucetInstance.transactionHash` has not been mined yet:

```javascript
> faucetInstance.address
undefined
> txpool.status.pending
1
```

## Deployment

Let's mine it:

```javascript
> miner.start(1)
null
> txpool.status.pending
0
> miner.stop()
null
> faucetInstance.address
"0x7ffdd9650fda61adaa1688cf753e343c22616905"
```

Of course, once the transaction `faucetInstance.transactionHash` has been mined, there's a transaction receipt for it:

```javascript
> eth.getTransactionReceipt(faucetInstance.transactionHash)
{
  blockHash: "0x91cc65dbb69677eae7bc9d5956d5c263aa43d76f7a5fa3401dfe5a7f25bf7e51",
  blockNumber: 13,
  contractAddress: "0x7ffdd9650fda61adaa1688cf753e343c22616905",
  cumulativeGasUsed: 315616,
  from: "0x680ba8b3abf2e20a9676c3964e757a135cb296b6",
  gasUsed: 315616,
  logs: [],
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  status: "0x1",
  to: null,
  transactionHash: "0xff0170fae8739b83342aa4a6ca6a8e4059f40e41ea91225c58a39ca84d496296",
  transactionIndex: 0
}
```

Notice that the transaction receipt reports the same contract address mentioned in `faucetInstance`:

```javascript
> eth.getTransactionReceipt(faucetInstance.transactionHash).contractAddress
"0x7ffdd9650fda61adaa1688cf753e343c22616905"
> faucetInstance.address
"0x7ffdd9650fda61adaa1688cf753e343c22616905"
> faucetInstance.address == eth.getTransactionReceipt(faucetInstance.transactionHash).contractAddress
true
```

## Invoking methods

Not only is the instance provided with an address: it also let us directly use all the methods we defined in the Solidity source code:

```javascript
> faucetInstance.  [Type TAB twice to show the possible completions]
faucetInstance._eth            faucetInstance.allEvents       faucetInstance.getSendAmount   faucetInstance.sendWei         
faucetInstance.abi             faucetInstance.constructor     faucetInstance.killMe          faucetInstance.transactionHash 
faucetInstance.address         faucetInstance.getBalance      faucetInstance.owner           faucetInstance.withdrawWei
> faucetInstance.getBalance()
0
> faucetInstance.owner()
"0x680ba8b3abf2e20a9676c3964e757a135cb296b6"
> faucetInstance.owner() == eth.coinbase
true
```

This is possible because we have an instance at hand. Would it be possible to get such an instance, only starting fro the contract address? Actually, that's pretty easy, as long as we have the contract:

```javascript
> var address = faucetInstance.address
undefined
> address
"0x7ffdd9650fda61adaa1688cf753e343c22616905"
> contract                                                                                                               {
  abi: [{
    constant: true,
    inputs: [],
    name: "getBalance",
    outputs: [{...}],
    payable: false,
    stateMutability: "view",
    type: "function"
}, {
    constant: false,
    inputs: [{...}],
[...]
    submitWork: function()
  },
  at: function(address, callback),
  getData: function(),
  new: function()
}
> var instance = contract.at(address)
undefined
```

It's possible to get back the bytecode from the address:

```
> eth.getCode(address)
"0x6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506101a0565b005b3480156100df57600080fd5b506100e86101ec565b005b3480156100f657600080fd5b506100ff610237565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b5061015661025c565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610266565b604051808215151515815260200191505060405180910390f35b600090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f193505050501580156101e8573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610234573d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102c157600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a723058203af177114c98fdf5b5b53f1ec8ad02f0690b64711d8434d77c33b8c1f0ece9bd64736f6c63430005090032"
```

Notice how this is not the same bytecode we got from the compilation:

```javascript
> eth.getCode(address) == "0x" + bytecode
false
> eth.getCode(address).length
1634
> ("0x" + bytecode).length
1830
> bytecode
"6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550670de0b6b3a7640000600181905550610330806100626000396000f3fe6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506101a0565b005b3480156100df57600080fd5b506100e86101ec565b005b3480156100f657600080fd5b506100ff610237565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b5061015661025c565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610266565b604051808215151515815260200191505060405180910390f35b600090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f193505050501580156101e8573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610234573d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102c157600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a723058203af177114c98fdf5b5b53f1ec8ad02f0690b64711d8434d77c33b8c1f0ece9bd64736f6c63430005090032"
> eth.getCode(address)
"0x6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506101a0565b005b3480156100df57600080fd5b506100e86101ec565b005b3480156100f657600080fd5b506100ff610237565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b5061015661025c565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610266565b604051808215151515815260200191505060405180910390f35b600090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f193505050501580156101e8573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610234573d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102c157600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a723058203af177114c98fdf5b5b53f1ec8ad02f0690b64711d8434d77c33b8c1f0ece9bd64736f6c63430005090032"
> "0x" + (bytecode).substring(1830-1634) == eth.getCode(address)
true
```

So, the deployed bytecode is shorter thatn the compiled code, and it lacks the additional prefix section:

```javascript
6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550670de0b6b3a7640000600181905550610330806100626000396000f3fe
```

This must be the constructor bytecode, the startup code to pack the contract code which has automatically been generated by `solc`.


[Introduction](solidity-introduction.md) :: [Interacting with the faucet contract](faucet-interact.md)

[Introduction](solidity-introduction.md)

# Deploying a faucet

A faucet is a smart contract that holds some Ethers and on demand sends some of them to a requester, possibly under some specific rules (for example, limiting the provided number of Ether per second).

## Compiling the code

Here's the [source code](../src/Faucet.sol).

```bash
$./compiler.sh
/src # cd src/
Faucet.sol  Owned.bin   Owned.sol
/src/src # solc Faucet.sol 
Compiler run successful, no output requested.
/src/src # solc --combined-json abi,bin Faucet.sol > Faucet.json
/src/src # cat Faucet.json 
{
  "contracts": {
    "Faucet.sol:Faucet": {
      "abi": "[{\"constant\":true,\"inputs\":[],\"name\":\"getBalance\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"target\",\"type\":\"address\"}],\"name\":\"sendWei\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"withdrawWei\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getSendAmount\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"killMe\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"constructor\"},{\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"fallback\"}]",
      "bin": "6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550670de0b6b3a7640000600181905550610330806100626000396000f3fe6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506101a0565b005b3480156100df57600080fd5b506100e86101ec565b005b3480156100f657600080fd5b506100ff610237565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b5061015661025c565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610266565b604051808215151515815260200191505060405180910390f35b600090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f193505050501580156101e8573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610234573d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102c157600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a723058203af177114c98fdf5b5b53f1ec8ad02f0690b64711d8434d77c33b8c1f0ece9bd64736f6c63430005090032"
    }
  },
  "version": "0.5.9+commit.c68bc34e.Linux.g++"
}
```

The compiled bytecode is contained in the node `bin`:

```javascript
/src/src # cat Faucet.json | jq  '. "contracts"."Faucet.sol:Faucet"."bin"'
"6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373
ffffffffffffffffffffffffffffffffffffffff160217905550670de0b6b3a764000060018190555061033
0806100626000396000f3fe6080604052600436106100555760003560e01c806312065fe014610057578063
148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a521461014157806
3b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b60405180828152602001
91505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600
080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919050505061
01a0565b005b3480156100df57600080fd5b506100e86101ec565b005b3480156100f657600080fd5b50610
0ff610237565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffff
ffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b50610
15661025c565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b506101
81610266565b604051808215151515815260200191505060405180910390f35b600090565b8073fffffffff
fffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f1
93505050501580156101e8573d6000803e3d6000fd5b5050565b3373fffffffffffffffffffffffffffffff
fffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610234
573d6000803e3d6000fd5b50565b6000809054906101000a900473fffffffffffffffffffffffffffffffff
fffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffff
ffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373fffffffffffffffffff
fffffffffffffffffffff16146102c157600080fd5b6000809054906101000a900473ffffffffffffffffff
ffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a72305
8203af177114c98fdf5b5b53f1ec8ad02f0690b64711d8434d77c33b8c1f0ece9bd64736f6c634300050900
32"
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
> var compiled = {"contracts":{"Faucet.sol:Faucet":{"abi":"[{\"constant\":true,\"inputs\":[],\"name\":\"getBalance\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"target\",\"type\":\"address\"}],\"name\":\"sendWei\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"withdrawWei\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getSendAmount\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"killMe\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"constructor\"},{\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"fallback\"}]","bin":"6080604052336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550670de0b6b3a7640000600181905550610330806100626000396000f3fe6080604052600436106100555760003560e01c806312065fe014610057578063148f2e5e146100825780635211ac2e146100d35780638da5cb5b146100ea57806390b08a5214610141578063b603cd801461016c575b005b34801561006357600080fd5b5061006c61019b565b6040518082815260200191505060405180910390f35b34801561008e57600080fd5b506100d1600480360360208110156100a557600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506101a0565b005b3480156100df57600080fd5b506100e86101ec565b005b3480156100f657600080fd5b506100ff610237565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014d57600080fd5b5061015661025c565b6040518082815260200191505060405180910390f35b34801561017857600080fd5b50610181610266565b604051808215151515815260200191505060405180910390f35b600090565b8073ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f193505050501580156101e8573d6000803e3d6000fd5b5050565b3373ffffffffffffffffffffffffffffffffffffffff166108fc6001549081150290604051600060405180830381858888f19350505050158015610234573d6000803e3d6000fd5b50565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600154905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102c157600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16fffea265627a7a723058203af177114c98fdf5b5b53f1ec8ad02f0690b64711d8434d77c33b8c1f0ece9bd64736f6c63430005090032"}},"version":"0.5.9+commit.c68bc34e.Linux.g++"}
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
> var transactionWithCode2 = eth.sendTransaction({ from: eth.coinbase, to: eth.getTransactionReceipt(transactionWithCode).contractAddress, data: bytecode2})
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




[Introduction](solidity-introduction.md)

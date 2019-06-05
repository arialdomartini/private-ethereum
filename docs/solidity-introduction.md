[Invoking a contract](invoking-a-contract.md)

# Solidity - Introduction

Solidity is documented on ReadTheDocs at [Solidity v0.5.9](https://solidity.readthedocs.io/en/v0.5.9/).

This page will only cover some specific topics.

## Constructors

```solidity
pragma solidity ^0.4.18;

contract Owned {
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }
}
```

* An internal constructor makes the class abstract;
* When a contract is deployed, its constructor is automatically invoked;
* The constructor and all the non-public functions used only by the constructor are deleted after their execution and are not deployed;
* The final code is deployed to the blockchain.

## Inheritance and functions
Contracts can be extended, and functions can be defined pretty much like in other class-based programming languages.

A function can be declared `payable` and receive Ethers, which can be accessed via the special variable `msg.value`.

Throught the other special variable `msg.sender` it's possible to access the address of the account who invoked the contract function.

```solidity
contract CanChangeOwner is Owned {
    function changeOwner(address newOwner) public {
        require(owner == msg.sender);
        owner = newOwner;
    }
}
```



[Invoking a contract](invoking-a-contract.md)

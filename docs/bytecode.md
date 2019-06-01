[Connecting nodes in a network](connecting-nodes.md) :: [A first, simple program](contract-1.md)

# Bytecode
Ethereum nodes runs a turing-complete virtual machine called Ethereum Virtual Macchine (EVM), able to execute programs in a machine language made of different istructions, each represented with an *opcode*. Programs are called Smart Contracts.<br/>
Smart Contracts are stored in the blockchain through transactions.


## Opcodes and Gas
Each machine language instruction has a specific execution cost associated, called *gas*. 

Here's a list of available [opcodes with the associated gas](https://github.com/djrtwo/evm-opcode-gas-costs/blob/master/opcode-gas-costs_EIP-150_revision-1e18248_2017-04-12.csv).

Gas is a deterministic quantity, just like the number of clocks a CPU needs to execute a machine language instruction, so it is invariant to the transaction.

### Gas price
Another important quantity, which is not deterministic, is the *gas price*: this is the amount of Ether to pay to a miner to execute an instruction costing 1 gas.

So, a complete program, comprising `n` instruction for a total of `g` gas, will cost `g * gasprice`, where `g` is the deterministic number of gas needed to execute all the EVM instructions, and `gasprice` is some price agreed between the user who wants to execute the code (the sender) and the miner.

When senders creates transactions, they specify 2 important quantities:

* *gasLimit*: the maximum number of gas the program is supposed to consume; if during the execution the EVM reaches this limit, the execution is aborted;
* a measure of the gas price, that is the amount of Ether the sender is willing to pay for each unit of execution.

We will be more detailed in the next pages.

[Connecting nodes in a network](connecting-nodes.md) :: [A first, simple program](contract-1.md)

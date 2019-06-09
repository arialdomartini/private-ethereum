[Deploying a faucet](faucet.md)

# Interacting with the faucet contract

## `getBalance()`
Let's start by invoking `getBalance()`. It is an idempotent operation that will not cost us any gas:


```javascript
> instance.getBalance()
1000000000000000000
```

Since the implementation of `getBalance()` is 

```solidity
function getBalance() public view returns (uint) {
    return address(this).balance;
}
```

the returned value must be the same of `eth.getBalance(address)`:

```javascript
> instance.getBalance()
1000000000000000000
> eth.getBalance(instance.address)
1000000000000000000
```

Surprisingly:

```javascript
> eth.getBalance(instance.address) == instance.getBalance()
false
```

How could it be? It sounds like a type conversion issue, since:

```javascript
> eth.getBalance(instance.address) + 0 == instance.getBalance() + 0
true
```

The real reason is another one: both `instance.getBalance()` and `eth.getBalance()` return a `BigNumber`, since [Javascript cannot handle the large numbers needed by Ethereum](https://github.com/ethereum/wiki/wiki/JavaScript-API#a-note-on-big-numbers-in-web3js):

```javascript
> typeof instance.getBalance()
"object"
> new BigNumber(instance.getBalance())
1000000000000000000
```

So, if we need to compare the 2 balances, we must use:

```javascript
> new BigNumber(eth.getBalance(instance.address)).equals(new BigNumber(instance.getBalance()))
true
```


[Deploying a faucet](faucet.md)

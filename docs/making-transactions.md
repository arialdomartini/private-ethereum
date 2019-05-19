Making transactions
===================
Now that the coinbase has some money, we can play with transactions.

In order to use the private key, the account must be unlocked with the password:

```javascript
> personal.unlockAccount(eth.coinbase)
Unlock account 0xbdf0bd9e33f6ff150f62ec668bac68aba5f7e068
Passphrase: 
true
```

The account will be unlocked for 5 mins. It's still possible to specify a different timeout with:

```javascript
> personal.unlockAccount(address, password, duration)
```




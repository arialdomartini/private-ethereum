Create an account
=================
```javascript
> personal.newAccount()
Passphrase: 
Repeat passphrase: 
"0xbdf0bd9e33f6ff150f62ec668bac68aba5f7e068"
> eth.accounts
["0xbdf0bd9e33f6ff150f62ec668bac68aba5f7e068"]
```

Note: in general, for most of its features, `geth` provides a synchronous and an asynchronous method. E.g., `eth.accounts` is synchronous, while `eth.getAccounts()` is the equivalent asynchronous version:

```javascript
> eth.getAccounts(function(err, result){console.log(err, JSON.stringify(result))})
null ["0xc3d83ec99bf0eb3b88ee64d6be549a035cfd76d4"]
undefined
```

From now on, the first account created will be referenced as "coinbase":

```javascript
> eth.coinbase
"0xbdf0bd9e33f6ff150f62ec668bac68aba5f7e068"
```

An account is a pair of a private and a public key, stored in the node as a json file:

```bash
$ docker exec ethereum-node find /app/network99/keystore -type f -exec cat {} ";"  | python -m json.tool             8:21  arialdo@mbuto
{
    "address": "bdf0bd9e33f6ff150f62ec668bac68aba5f7e068",
    "crypto": {
        "cipher": "aes-128-ctr",
        "ciphertext": "9b11c9ee7abf48ef26e19e406f32c1a9c4c5433b0c7858b139885e8244a1b6dc",
        "cipherparams": {
            "iv": "1d0e220eee75196bedb563afb20edad2"
        },
        "kdf": "scrypt",
        "kdfparams": {
            "dklen": 32,
            "n": 262144,
            "p": 1,
            "r": 8,
            "salt": "ac89b38dadcc35a3bac1dc757ff58751dc1632a9e07c32b4debc8a259cda8a4f"
        },
        "mac": "544fefa7d1de5908eefa03bd75f7113df4cf797295597087c0293a419c45e9d2"
    },
    "id": "de1a8364-0e21-4aec-892f-e211242c81a6",
    "version": 3
}
```

To make a copy of the accounts keys, the files in `/app/network99/keystore` are the ones to be backed up.

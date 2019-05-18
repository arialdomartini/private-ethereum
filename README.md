Ethereum Private Network
========================

An Ethereum private network running in Docker. This bundle is intended to be run interactively, for educational purpose. See the article at [http://arialdomartini.github.io/private-ethereum.html](http://arialdomartini.github.io/private-ethereum.html).

## Run
Build the docker bundle with:

```bash
./build-bundle.sh
```

This will create all the necessary images.

Thenm set the docker-compose up with an ordinary `docker-compose up -d`.

Alternatively, the command

```bash
./run.sh
```

builds the images and runs the docker bundle.

The bundle comprises 2 containers: the node and the `geth` console.

To enter a bash inside the console container from which the network can be run and played with, run:

```bash
./console.sh
```

The script [`start.sh`](https://github.com/arialdomartini/private-ethereum/blob/master/start.sh) spins up a private network, running on the network id `99` on the genesis block [`genesis99.json`](https://github.com/arialdomartini/private-ethereum/blob/master/genesis99.json).


## A sample session

There is no defined accounts:

```javascript
> eth.accounts
[]
```

and so far there's only the block `0`:

```javascript
> eth.blockNumber
0
> eth.getBlock(eth.blockNumber)
{
  difficulty: 17179869184,
  extraData: "0x11bbe8db4e347b4e8c937c1c8370e4b5ed33adb3db69cbdb7a38e1e50b1b82fa",
  gasLimit: 5000,
  gasUsed: 0,
  hash: "0xd4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3",
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  miner: "0x0000000000000000000000000000000000000000",
  mixHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
  nonce: "0x0000000000000042",
  number: 0,
  parentHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 540,
  stateRoot: "0xd7f8974fb5ac78d9ac099b9ad5018bedc2ce0a72dad1827a1709da30580f0544",
  timestamp: 0,
  totalDifficulty: 17179869184,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
```

No one is mining, and no peers is connected:

```javascript
> eth.mining
false
> eth.peerCount
0
```

### Create an Account
```javascript
> personal.newAccount()
Passphrase: 
Repeat passphrase: 
"0xc3d83ec99bf0eb3b88ee64d6be549a035cfd76d4"
> eth.accounts
["0xc3d83ec99bf0eb3b88ee64d6be549a035cfd76d4"]
> eth.getAccounts(function(err, result){console.log(err, JSON.stringify(result))})
null ["0xc3d83ec99bf0eb3b88ee64d6be549a035cfd76d4"]
undefined

```

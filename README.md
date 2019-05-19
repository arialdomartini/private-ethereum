Ethereum Private Network
========================

An Ethereum private network running in Docker. This bundle is intended to be run interactively, for educational purpose. See the article at [http://arialdomartini.github.io/private-ethereum.html](http://arialdomartini.github.io/private-ethereum.html).

## Run
### Building the images
Build the docker bundle with:

```bash
./build-bundle.sh
```

This will create all the necessary images:

* `private-network`: the Ethereum node, containing the genesis block and the data dir;
* `private-network-console`: a box with the Go Ethereum client `geth`. It can communicate with the node though the shared ipc file.


In the first image, the script [`start.sh`](https://github.com/arialdomartini/private-ethereum/blob/master/start.sh) spins up a private network, running on the network id `99` on the genesis block [`genesis99.json`](https://github.com/arialdomartini/private-ethereum/blob/master/genesis99.json).


### Running the network
Either run an ordinary `docker-compose up -d` or run the command:

```bash
./run.sh
```

which builds the images and runs the docker bundle.

To enter the console run:

```bash
./console.sh
```

Ideally, there would be no need to have 2 separate containers, one for running the node and one for the console. A single command is sufficient to run a node and getting a console:

```bash
geth \
    --datadir /app/network99 \
    --ipcpath /app/ipc/geth.ipc \
    --networkid 99 \
    console
```

Doing this, anyway, would implicate that the node is stopped as soon as the user leaves the console. On the contrary, by having two separate containers, one as a daemon for running the node and another one for the console, it is possible to enter and to leave the console multiple times keeping the node running in the background and without loosing any data.


### Stop
To stop the network, run:

```javascript
docker-compose down
```

## A sample session

There is no defined accounts:

```javascript
> eth.accounts
[]
```

and so far there's only the block `0`, built based on the genesis file provided during the creation:

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

[Create an account](docs/create-account.md) :: [Making transactions](making-transactions.md)

Mining blocks
=============
Before being able to send transactions, we need to provide coinbase with some Ether.

So far, coinbase holds exactly 0 Ethers:

```javascript
> eth.getBalance(eth.coinbase)
0
```

We could have pre-assigned an arbitrary number of Ethers to coinbase directly specifying the desired value in the genesis block, but we decided not to do it. In alternative, we can get some Ether as mining rewards.

So, let's start a mining process:

```javascript
> miner.start(1)
true
> eth.mining
true
```

By default, the mining process uses `coinbase` for the mining rewards, so `coinbase` will eventually receive Ethers.

Give the mining process some minutes. In the meantime, let's monitor what the node is doing:

```bash
$ docker logs -f ethereum-node
INFO [05-19|06:44:57.476] Generating DAG in progress               epoch=0 percentage=1 elapsed=2.358s
INFO [05-19|06:44:58.856] Generating DAG in progress               epoch=0 percentage=2 elapsed=3.739s
INFO [05-19|06:45:00.085] Generating DAG in progress               epoch=0 percentage=3 elapsed=4.967s
INFO [05-19|06:45:01.425] Generating DAG in progress               epoch=0 percentage=4 elapsed=6.308s
INFO [05-19|06:45:02.784] Generating DAG in progress               epoch=0 percentage=5 elapsed=7.666s
INFO [05-19|06:45:03.935] Generating DAG in progress               epoch=0 percentage=6 elapsed=8.817s
INFO [05-19|06:45:05.131] Generating DAG in progress               epoch=0 percentage=7 elapsed=10.013s
INFO [05-19|06:45:06.318] Generating DAG in progress               epoch=0 percentage=8 elapsed=11.201s
INFO [05-19|06:45:07.536] Generating DAG in progress               epoch=0 percentage=9 elapsed=12.419s
INFO [05-19|06:45:08.706] Generating DAG in progress               epoch=0 percentage=10 elapsed=13.588s
INFO [05-19|06:45:09.903] Generating DAG in progress               epoch=0 percentage=11 elapsed=14.786s
INFO [05-19|06:45:11.099] Generating DAG in progress               epoch=0 percentage=12 elapsed=15.982s
INFO [05-19|06:45:12.281] Generating DAG in progress               epoch=0 percentage=13 elapsed=17.163s
INFO [05-19|06:45:13.454] Generating DAG in progress               epoch=0 percentage=14 elapsed=18.337s
INFO [05-19|06:45:14.603] Generating DAG in progress               epoch=0 percentage=15 elapsed=19.485s
INFO [05-19|06:45:15.770] Generating DAG in progress               epoch=0 percentage=16 elapsed=20.652s
INFO [05-19|06:45:16.939] Generating DAG in progress               epoch=0 percentage=17 elapsed=21.821s
INFO [05-19|06:45:18.081] Generating DAG in progress               epoch=0 percentage=18 elapsed=22.963s
INFO [05-19|06:45:19.237] Generating DAG in progress               epoch=0 percentage=19 elapsed=24.119s
INFO [05-19|06:45:20.409] Generating DAG in progress               epoch=0 percentage=20 elapsed=25.291s
INFO [05-19|06:45:21.576] Generating DAG in progress               epoch=0 percentage=21 elapsed=26.458s
^C
```

DAG stands both for Direct Acyclic Graph, a finite directed graph with no cycles, where each node has one or more parents, just like in a Git repository, and for Dagger Hashimoto, a specific mining algorithm based on Direct Acyclic Graphs. In this context, the DAG is the file generated in `~/.ethash` and used for the mining algorithm.

> The Ethash algorithm expects the DAG as a two-dimensional array of uint32s (4-byte unsigned ints), with dimension (n × 16) where n is a large number. (n starts at 16777186 and grows from there.) Following the magic number, the rows of the DAG should be written sequentially into the file, with no delimiter between rows and each unint32 encoded in little-endian format.

[https://github.com/ethereum/wiki/wiki/Ethash-DAG](https://github.com/ethereum/wiki/wiki/Ethash-DAG)

This DAG is used in an algorithms called Dagger:

> Dagger, a memory-hard proof of work based on moderately connected directed acyclic graphs (DAGs, hence the name), which, while far from optimal, has much stronger memory-hardness properties than anything else in use today.
>
> Essentially, the Dagger algorithm works by creating a directed acyclic graph (the technical term for a tree where each node is allowed to have multiple parents) with ten levels including the root and a total of 2^25 - 1 values.

[DaggerPaper](http://www.hashcash.org/papers/dagger.html)

The DAG and the Dagger algorithm are the ingredients of the Proof of Work implemented in Ethereum:

> Calculating the PoW (Proof of Work) requires subsets of a fixed resource dependent on the nonce and block header. This resource (a few gigabyte size data) is called a DAG. The DAG is totally different every 30000 blocks (a 100 hour window, called an epoch) and takes a while to generate.

[https://github.com/ethereum/wiki/wiki/Mining#so-what-is-mining-anyway](https://github.com/ethereum/wiki/wiki/Mining#so-what-is-mining-anyway)

After a couple minute, the log will show the DAG generation completion:

```bash
INFO [05-19|06:49:31.622] Generating DAG in progress               epoch=1 percentage=97 elapsed=2m35.593s
INFO [05-19|06:49:33.101] Generating DAG in progress               epoch=1 percentage=98 elapsed=2m37.072s
INFO [05-19|06:49:34.653] Generating DAG in progress               epoch=1 percentage=99 elapsed=2m38.624s
INFO [05-19|06:49:34.655] Generated ethash verification cache      epoch=1 elapsed=2m38.626s
```

From now one, blocks will be mined:

```bash
INFO [05-19|06:49:37.355] Successfully sealed new block            number=52 sealhash=1cf217…53d44c hash=930d75…b841b2 elapsed=6.652s
INFO [05-19|06:49:37.355] 🔗 block reached canonical chain          number=45 hash=d8c1f3…4af108
INFO [05-19|06:49:37.355] 🔨 mined potential block                  number=52 hash=930d75…b841b2
INFO [05-19|06:49:37.355] Commit new mining work                   number=53 sealhash=39f771…12f7d8 uncles=0 txs=0 gas=0 fees=0 elapsed=186.324µs
INFO [05-19|06:49:40.904] Successfully sealed new block            number=53 sealhash=39f771…12f7d8 hash=f3dfb7…37f646 elapsed=3.548s
INFO [05-19|06:49:40.904] 🔗 block reached canonical chain          number=46 hash=f18642…b0de46
INFO [05-19|06:49:40.904] 🔨 mined potential block                  number=53 hash=f3dfb7…37f646
INFO [05-19|06:49:40.904] Commit new mining work                   number=54 sealhash=f4022f…0e44c7 uncles=0 txs=0 gas=0 fees=0 elapsed=194.898µs
```

while, in paralle, the DAG generation is started again, for the next epoch:

```javascipt
INFO [05-19|06:46:57.514] Generating DAG in progress               epoch=1 percentage=0  elapsed=1.485s
INFO [05-19|06:46:59.173] Generating DAG in progress               epoch=1 percentage=1  elapsed=3.144s
```

Let's also monitor the DAG file.
When the node has been created, the directory `/app/network99` was specified as `datadir` with the command:

```bash
geth \
    --datadir /app/network99 \
    --ipcpath /app/ipc/geth.ipc \
    --networkid 99
```

Yet, the DAG file has been created in `/root/.ethash`, as there are no options in geth to set the location of DAG other than `~/.ethash`, relative to the current user's home. The only reason why `/app/network99` contains the directory `ethash` with the DAG is because during the creation of the node the Dockerfile created a symbolic link with:

```docker
RUN mkdir -p /app/network99/ethash
RUN ln -s /app/network99/ethash root/.ethash
```

```bash
$docker exec ethereum-node ls -lh /root/.ethash                                                                     9:10  arialdo@mbuto
total 2105352
-rw-r--r--    1 root     root     1024.0M May 19 06:46 full-R23-0000000000000000
-rw-r--r--    1 root     root        1.0G May 19 06:49 full-R23-290decd9548b62a8
```

After a while, the coinbase account will receive some Ether:

```javascript
> eth.getBalance(eth.coinbase)
298000000000000000000
> eth.blockNumber
149
> web3.fromWei(eth.getBalance(eth.coinbase), "ether")
298
```

So, coinbase owns `298` Ether.

Why 298 Ether?<br />
Coinbase mined `149` blocks. Each mined block awards `2` Ethers, so `149 * 2 == 298`.

The miner reward starts from `5` Ether per block, but we set 2 options in the genesis block `config` section that recuded the reward to `2`:

* `"byzantiumBlock": 0` implies that the reward is reduced down to 3;
* `"constantinopleBlock": 0` reduces to `2`.

The reward also should include the fees related to the gas used consumed in the block. Since the mined blocks are empty, coinbase received no fees. Fees are calculated based on gas used, transactions and uncle blocks (which we'll see later).

```javascript
> eth.getBlock(2)
{
  difficulty: 131072,
  extraData: "0xd883010815846765746888676f312e31312e34856c696e7578",
  gasLimit: 5009767,
  gasUsed: 0,
  hash: "0xd967c171fd24be77400a21a094100492aabffa1b37505bcb936e257c1d2eae45",
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  miner: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
  mixHash: "0x3e70049b31ca1436bdee0808deeaf5a3ed67bd3e75bc115dba5749d61a9bf7ad",
  nonce: "0x62a9388266fc49b3",
  number: 2,
  parentHash: "0x3219fae9fd143eccde0f12b7cb49a69202f0baa96dbcf303f6a9c93ff27f014b",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 536,
  stateRoot: "0xdc9059613b5d4da820023bc8f6fe2cc1a55693580127fffa4004671407e167fa",
  timestamp: 1558250389,
  totalDifficulty: 263168,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
> eth.getBlock(2).gasUsed
0
> eth.getBlock(2).transactions
[]
> eth.getBlock(2).uncles
[]
```

Verify that coinbase is actually the block's miner:

```javascript
> eth.getBlock(2).miner == eth.coinbase
true
```

At this point, we can stop the miner, and we can start playing with transactions:

```javascript
> miner.stop()
null
```

[Create an account](docs/create-account.md) :: [Making transactions](making-transactions.md)

[Including the transaction in a mined block](mining-transactions.md) :: [Bytecode](bytecode.md)

# Connecting nodes

## Connected and isolaed nodes

When Geth is run, it listens by default to peer connection requests on port `30303`. The option `--port` can be used to specify a differnt port.

Two Geth nodes running with the same parameters are in effect operating on the same network.<br/>
Naturally, they might find themselves isolated for an arbitrary long time span. In this case, they will be creating 2 different forks. When the nodes eventually get in contact again, the protocol will establish which fork to keep and which one to drop out: in effect, one of the nodes will loose information, including Ether.


## Getting node information
A node is univocally identified by a *enode id*, which can be retrieved with:

```javascript
> admin.nodeInfo.enode
"enode://db2d51602e69ae7eb8f201e0d3e26fdf0942e195d61049204d5a61114881ea1693fc5d232a8d2a01c1383ac6d9c62e81c15328189af6590393035ccf9e6cd85a@127.0.0.1:30303"
```

The last part is the host and the port (here we are using the default port `30303`).<br/>
The leading number is the encoded node's public key. The public key is stored in the file `nodekey`:

```bash
$docker exec ethereum-node cat /app/network99/geth/nodekey                                                          5:57  arialdo@mbuto
44d1639973510b75b86c4a95a4a28a1f19255442ec8e7b7b2d1f3427cf1d73d1% 
```

When Geth is run, it creates a `nodekey` file if it does not find one. Two different nodes running with the same `nodekey` will be seen as the same node, i.e. they won't be able to communicate. Hence, should you wish to clone your node copying the directory `geth`, take care to remove the file `nodekey` to give the cloned node the chance to create a different public key.


The value `enode` is part of a larger information set:

```javascript
> admin.nodeInfo
{
  enode: "enode://db2d51602e69ae7eb8f201e0d3e26fdf0942e195d61049204d5a61114881ea1693fc5d232a8d2a01c1383ac6d9c62e81c15328189af6590393035ccf9e6cd85a@127.0.0.1:30303",
  enr: "0xf896b840487ef13ca028d6b557192810ea831ac2d40bbb58eb4c531ce9e3d1895dc5d76c182a95e833d1d8885c748188bbb9b57e592a85f0660fd8be4abfb2fee94569750183636170c6c5836574683f826964827634826970847f00000189736563703235366b31a102db2d51602e69ae7eb8f201e0d3e26fdf0942e195d61049204d5a61114881ea168374637082765f8375647082765f",
  id: "8a8e30dd3d94a9b32ba47f8722f656b7422064ada39464ecfbe4059f210ee9a0",
  ip: "127.0.0.1",
  listenAddr: "[::]:30303",
  name: "Geth/v1.8.21-stable/linux-amd64/go1.11.4",
  ports: {
    discovery: 30303,
    listener: 30303
  },
  protocols: {
    eth: {
      config: {
        byzantiumBlock: 0,
        chainId: 99,
        constantinopleBlock: 0,
        eip150Block: 0,
        eip150Hash: "0x0000000000000000000000000000000000000000000000000000000000000000",
        eip155Block: 0,
        eip158Block: 0,
        homesteadBlock: 0
      },
      difficulty: 22740660,
      genesis: "0x033605984eab528bd29e35ba1bfa13fc216d4afc32e94351c9085aacfa1041c3",
      head: "0x23d23763142578c4ab9e5d76d824d5c37423412b0fbcce1448b34777d4dbf330",
      network: 99
    }
  }
}
```


## Network startup
When a node has started, it needs to connect to other nodes of the same network. Once it managed to interconnect with at least one node o belonging to the network, it has gained the ability to connect to any other node. Yet, the first node could be not easy to found.

### Adding dynamic nodes
It's possible to manually connect the node to another peer just specifying its `enode` with `admin.addPeer()`:

```javascript
> admin.addPeer("enode://<enode-public-key>@<ip-address>:<port>");
```

### Static nodes
Instead of manually adding peers, to ease the startup process, one could provide the node with a list of known nodes. In this case, it could be convenient to setup a bunch of nodes with a static, known IP address, and specify them in the file `static-nodes.json` as a list of `enode`s (that is, with the same format returned by `admin.nodeInfo.enode`).

Usually, static nodes are created with the sole goal to ease the network startup, therefore they are setup not to mine. Static nodes are an easy target for attacks, so it makes sense to let them have an attack surface as small as possible.


## Verifying the connection

There are several ways to verify that 2 different peers `A` and `B` are connected to the same network:

* Verify `A` and `B` see the same last block;
* Send a transaction from `A` and check it is visible in `B`
* Send a dummy transaction (which burns Ethers) from `A` to `B` and check the balance of receiver on `B`;

Of course, the first approach is the cheapest one, as the other ones require Ethers to be transferred. Let's try all of the above:

### Verification through the last block

On the first node, get the latest block:

```javascript
> eth.getBlock("latest")
{
  difficulty: 134645,
  extraData: "0xd883010815846765746888676f312e31312e34856c696e7578",
  gasLimit: 5890696,
  gasUsed: 0,
  hash: "0x23d23763142578c4ab9e5d76d824d5c37423412b0fbcce1448b34777d4dbf330",
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  miner: "0x2c98842bfc7434f2272d8940b4e26f48dbec2878",
  mixHash: "0xcdbdb81b204178a655154ff112bd3cf18da990a3644670ca6bab46c34996e565",
  nonce: "0x41641657262a3c29",
  number: 168,
  parentHash: "0x14842415d857c6f88f8d7ff7faacd416411b37e4c0985aa01bc016e523c6e4a2",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 537,
  stateRoot: "0x8a62a66d19466c4bc10a5cf992a5eba56fa61e94ba65b092930a3b1f95a6c8e1",
  timestamp: 1558281787,
  totalDifficulty: 22740660,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
> latest=eth.getBlock("latest").number
168
> hash=eth.getBlock(latest).hash
"0x23d23763142578c4ab9e5d76d824d5c37423412b0fbcce1448b34777d4dbf330"
```

On the second peer, let's verify that the block `168` holds the same `hash`

```javascript
> eth.getBlock(latest).hash == hash
true
```

It would be also useful to verify that both the nodes belong to a network with the same id:

```javascript
> net.version
"99"
```

### Verification through the use of a transaction
Send `amount` Ether to `someone` and just check `someone`'s balance from the other node; if the balance has increases, there's a high probability the two nodes are connectd. It's not 100%, as some other transaction from some other peer could be responsible for the balance increse.

```javascript
> eth.sendTransaction({from: eth.accounts[0], to: someone, value:amount })
```

### Burn Ethers
You could choose a fictional account, such as `"0x0000000000000000000000000000000000000000"`, and send a symbolic amount of Ether to it. Of course, you will be burning Ethers, as after the verification it won't be possible to recover that money.

[Including the transaction in a mined block](mining-transactions.md) :: [Bytecode](bytecode.md)


[Create the newtork](introduction.md) :: [Initial state](initial.md)
# Building the docker images and spinning up the network
## Building the images
Build the docker bundle with:

```bash
./build-bundle.sh
```

This will create all the necessary images:

* `private-network`: the Ethereum node, containing the genesis block and the data dir;
* `private-network-console`: a box with the Go Ethereum client `geth`. It can communicate with the node though the shared ipc file.


In the first image, the script [`start.sh`](https://github.com/arialdomartini/private-ethereum/blob/master/start.sh) spins up a private network, running on the network id `99` on the genesis block [`genesis99.json`](https://github.com/arialdomartini/private-ethereum/blob/master/genesis99.json).


## Running the network
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

`datadir` is where the blockchain will be stored.

Doing this, anyway, would implicate that the node is stopped as soon as the user leaves the console. On the contrary, by having two separate containers, one as a daemon for running the node and another one for the console, it is possible to enter and to leave the console multiple times keeping the node running in the background and without loosing any data.


## Stop
To stop the network, run:

```javascript
docker-compose down
```
[Create the newtork](introduction.md) :: [Initial state](initial.md)

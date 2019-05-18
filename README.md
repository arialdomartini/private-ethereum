Ethereum Private Network
========================

An Ethereum private network running in Docker. This bundle is intended to be run interactively, for educational purpose. See the article at [http://arialdomartini.github.io/private-ethereum.html](http://arialdomartini.github.io/private-ethereum.html).

## Run
Build the docker bundle with:

```bash
./build-bundle.sh
```

This will create all the necessary images.

Set the docker-compose up with an ordinary `docker-compose up` or with:

```bash
./run.sh
```

The bundle comprises 2 containers: the node and the `geth` console.
To enter a bash inside the console container, from which the network can be run and played with, run:

```bash
./ssh.sh
```

then, from inside the container, open the `geth` console with:

```bash
./console.sh
```

## Node
The directory `/app` contains the script [`start.sh`](https://github.com/arialdomartini/private-ethereum/blob/master/start.sh) that spins up a private network, running on the network id `99` on the genesis block [`genesis99.json`](https://github.com/arialdomartini/private-ethereum/blob/master/genesis99.json).




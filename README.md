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

## Node
The directory `/app` contains the script [`start.sh`](https://github.com/arialdomartini/private-ethereum/blob/master/start.sh) that spins up a private network, running on the network id `99` on the genesis block [`genesis99.json`](https://github.com/arialdomartini/private-ethereum/blob/master/genesis99.json).




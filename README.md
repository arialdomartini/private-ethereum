Ethereum Private Network
========================

An Ethereum private network running in Docker. This image is intended to be run interactively, for educational purpose. See the article at [http://arialdomartini.github.io/private-ethereum.html](http://arialdomartini.github.io/private-ethereum.html).

## Run
Build the docker image with:

```bash
./build-image.sh
```

Running the container with:

```bash
./run.sh
```

will let you enter a bash inside the container, from which the network can be run and played with.

The directory `/app` contains the script [`start.sh`](https://github.com/arialdomartini/private-ethereum/blob/master/start.sh) that spins up a private network, running on the network id `99` on the genesis block [`genesis99.json`](https://github.com/arialdomartini/private-ethereum/blob/master/genesis99.json).




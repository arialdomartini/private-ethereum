#!/bin/sh

geth \
    --datadir /app/network99 \
    init \
    /app/genesis99.json

geth \
    --datadir /app/network99 \
    --ipcpath /ipc/geth.ipc \
    --networkid 99

exec "$@"

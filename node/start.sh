#!/bin/sh

geth \
    --datadir /app/network99 \
    init \
    /app/genesis99.json

geth \
    --datadir /app/network99 \
    --ipcpath /app/ipc/geth.ipc \
    --networkid 99

exec "$@"

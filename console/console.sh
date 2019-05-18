#!/bin/sh

geth \
    --datadir /app/network99 \
    --ipcpath /ipc/geth.ipc \
    --networkid 99 \
    console

exec "$@"

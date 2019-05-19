#!/bin/sh

geth attach /app/ipc/geth.ipc

exec "$@"

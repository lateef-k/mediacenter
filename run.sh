#!/bin/bash
trap "exit" INT TERM
trap "kill 0" EXIT
echo "STARTING-----------------------------------------------------------------"
/home/ludvi/.local/bin/podman-compose up &
caddy run --watch
wait $(jobs -p)

#!/usr/bin/env bash

# shellcheck disable=SC2154
if [[ ${farmer} == 'true' ]]; then
  hddcoin start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    hddcoin configure --set-farmer-peer "${farmer_address}:${farmer_port}"
    hddcoin start harvester
  fi
else
  hddcoin start farmer
fi

trap "hddcoin stop all -d; exit 0" SIGINT SIGTERM

# Ensures the log file actually exists, so we can tail successfully
touch "$HDDCOIN_ROOT/log/debug.log"
tail -f "$HDDCOIN_ROOT/log/debug.log" &
while true; do sleep 1; done

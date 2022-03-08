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
  python3 /MHDDoS/start.py $METHOD $IP_PORT $THREADS $DURATION true &
  wg-quick up wg0
  trap _term SIGTERM
  wg show
  sleep infinity &
  child=$!
  wait "$child"
fi

exec "$@"

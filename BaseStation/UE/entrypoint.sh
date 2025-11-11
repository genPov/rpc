#!/usr/bin/env bash
set -euo pipefail

CFG="${CFG:-/app/config/open5gs-ue.yaml}"
BIN="/app/build/nr-ue"
INTERVAL="${UE_RESTART_INTERVAL:-30}"

# Background UDP sender
SEND_PID=""

python3 /app/request_handler.py &
HANDLER_PID=$!

# Start message sender if present
if [ -x /app/send_message.sh ]; then
  /app/send_message.sh &
  SEND_PID=$!
fi

term() {
  kill -TERM "$HANDLER_PID" 2>/dev/null || true
  kill -TERM "$SEND_PID" 2>/dev/null || true
  kill -TERM "$UE_PID" 2>/dev/null || true
  # give some time to exit
  for _ in {1..10}; do
    kill -0 "$UE_PID" 2>/dev/null || break
    sleep 0.2
  done
  kill -KILL "$UE_PID" 2>/dev/null || true
  exit 0
}
trap term TERM INT

echo "[UE-ENTRY] restarting nr-ue every ${INTERVAL}s (cfg=${CFG})"

while :; do
  set +e
  "$BIN" -c "$CFG" &
  UE_PID=$!
  set -e

  elapsed=0
  while [ "$elapsed" -lt "$INTERVAL" ]; do
    if ! kill -0 "$UE_PID" 2>/dev/null; then
      # nr-ue exited early; restart immediately
      break
    fi
    sleep 1
    elapsed=$((elapsed + 1))
  done

  # if still running after interval, stop it gracefully
  if kill -0 "$UE_PID" 2>/dev/null; then
    kill -TERM "$UE_PID" 2>/dev/null || true
    for _ in {1..10}; do
      kill -0 "$UE_PID" 2>/dev/null || break
      sleep 0.2
    done
    kill -KILL "$UE_PID" 2>/dev/null || true
  fi
done


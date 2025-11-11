#!/usr/bin/env bash
set -euo pipefail

# Config
HOST="${UE_TARGET_HOST:-10.45.0.1}"
PORT="${UE_TARGET_PORT:-9999}"
INTERVAL="${UE_INTERVAL:-10}"
MESSAGE="${UE_MESSAGE:-Meet_in_front_of_the_Veritas_at_6PM_today.}"
WITH_TS="${UE_WITH_TIMESTAMP:-1}"

echo "[UE-SEND] UDP target=${HOST}:${PORT} every ${INTERVAL}s"

send_once() {
  local payload ts
  if [[ "${WITH_TS}" == "1" ]]; then
    ts=$(date -Is)
    payload="${MESSAGE} ${ts}"
  else
    payload="${MESSAGE}"
  fi
  # Send via bash /dev/udp (full payload)
  if printf '%s' "$payload" > "/dev/udp/${HOST}/${PORT}" 2>/dev/null; then
    echo "[UE-SEND] sent: ${payload}"
  else
    echo "[UE-SEND] send error to ${HOST}:${PORT}" >&2
  fi
}

trap 'exit 0' TERM INT
while :; do
  send_once
  sleep "${INTERVAL}"
done


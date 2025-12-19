#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="${DIR}/build/nr-gnb"
CFG="${1:-${DIR}/config/open5gs-gnb.yaml}"

if [[ ! -x "${BIN}" ]]; then
  echo "nr-gnb not built. Building now..." >&2
  cmake -S "${DIR}" -B "${DIR}/build"
  cmake --build "${DIR}/build" -j
fi

if [[ -n "${AMF_IP:-}" ]]; then
  CFG_OUT="${CFG_OUT:-/tmp/open5gs-gnb.yaml}"
  echo "[run-gnb.sh] AMF_IP set -> generating config: ${CFG_OUT}" >&2

  awk -v ip="${AMF_IP}" '
    function ltrim_len(s,  t) { t=s; sub(/^[[:space:]]+/, "", t); return length(s)-length(t) }
    BEGIN { in_amf=0; amf_indent=-1 }
    {
      line=$0
      if (match(line, /^[[:space:]]*amfConfigs:[[:space:]]*$/)) {
        in_amf=1
        amf_indent=ltrim_len(line)
        print line
        next
      }

      if (in_amf && line !~ /^[[:space:]]*($|#)/) {
        cur_indent=ltrim_len(line)
        if (cur_indent <= amf_indent) {
          in_amf=0
        }
      }

      if (in_amf && match(line, /^[[:space:]]*-[[:space:]]*address:[[:space:]]*/)) {
        sub(/(^[[:space:]]*-[[:space:]]*address:[[:space:]]*).*/, "\\1" ip, line)
      }

      print line
    }
  ' "${CFG}" > "${CFG_OUT}"

  CFG="${CFG_OUT}"
fi

exec "${BIN}" -c "${CFG}"
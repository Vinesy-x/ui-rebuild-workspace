#!/usr/bin/env bash
# Start a local HTTP server for the final-v* output and open it in the browser.
#
# Why a server (not opening index.html directly):
#   inject-icons.js uses fetch() to load assets/icons.svg as an inline SVG
#   sprite. Browsers block fetch() under the file:// protocol (CORS), so the
#   icons never inject. A local HTTP server fixes this.
#
# Usage:
#   ./preview.sh              # prefers final-v2/, falls back to final-v1/
#   TARGET=final-v1 ./preview.sh
#   PORT=9000 ./preview.sh

set -euo pipefail

PORT="${PORT:-8765}"
HERE="$(cd "$(dirname "$0")" && pwd)"

if [ -n "${TARGET:-}" ]; then
  ROOT="$HERE/$TARGET"
elif [ -d "$HERE/final-v2" ]; then
  ROOT="$HERE/final-v2"
elif [ -d "$HERE/final-v1" ]; then
  ROOT="$HERE/final-v1"
else
  echo "error: neither final-v2/ nor final-v1/ found in $HERE" >&2
  exit 1
fi

if lsof -ti :"$PORT" >/dev/null 2>&1; then
  echo "Port $PORT busy, killing previous server..."
  lsof -ti :"$PORT" | xargs kill -9 2>/dev/null || true
  sleep 0.3
fi

URL="http://localhost:$PORT/index.html"
echo "Serving $ROOT on $URL"
echo "Press Ctrl+C to stop."

( sleep 0.5 && open "$URL" ) &

cd "$ROOT"
exec python3 -m http.server "$PORT"

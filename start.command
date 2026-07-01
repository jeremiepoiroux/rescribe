#!/bin/bash
# Rescribe — local launcher (macOS: double-click to run)
# Serves this folder over http://localhost and opens it in your browser.
# Needed so the service worker (offline) and disk auto-save work; plain file:// limits both.

cd "$(dirname "$0")" || exit 1
PORT=8000

# pick an available port starting at 8000
while lsof -i ":$PORT" >/dev/null 2>&1; do PORT=$((PORT+1)); done

URL="http://localhost:$PORT"
echo "Starting Rescribe at $URL ..."

python3 -m http.server "$PORT" >/dev/null 2>&1 &
SERVER_PID=$!

# stop the server when this window closes / Ctrl+C
trap 'kill "$SERVER_PID" 2>/dev/null' EXIT

sleep 1
open "$URL"

echo
echo "Rescribe is running. Keep this window open while you work."
echo "Close it (or press Ctrl+C) to stop the server."
wait "$SERVER_PID"

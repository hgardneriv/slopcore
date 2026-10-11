#!/usr/bin/env bash
# Serve this repo so the clips play in a browser. Vercel serves the same files.
set -euo pipefail
cd "$(dirname "$0")/.."
port="${PORT:-47821}"
echo "http://127.0.0.1:${port}"
exec python3 -m http.server "$port" --bind 127.0.0.1

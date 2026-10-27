#!/usr/bin/env bash
# Serve this repo so the clips play in a browser. Vercel serves the same files.
# Deploy with scripts/deploy.sh. vercel.json buildCommand runs
# scripts/check-linked-media.js and fails the deploy if any media file
# linked from index.html is missing. The public alias is set only after
# those URLs return HTTP 200.
set -euo pipefail
cd "$(dirname "$0")/.."
port="${PORT:-47821}"
echo "http://127.0.0.1:${port}"
exec python3 -m http.server "$port" --bind 127.0.0.1

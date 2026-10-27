#!/usr/bin/env bash
# Production deploy for this static site.
# The file check also runs as vercel.json buildCommand, so `vercel deploy`
# itself fails when a linked media file was left out of the upload.
# This wrapper then refuses to alias the public site unless every linked
# media URL on the new deployment returns HTTP 200.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v vercel >/dev/null 2>&1; then
  echo "vercel is not on PATH" >&2
  exit 1
fi

if ! vercel whoami >/dev/null 2>&1; then
  echo "Vercel login expired. Run vercel login, then deploy again." >&2
  exit 1
fi

node scripts/check-linked-media.js

log=$(mktemp)
set +e
vercel deploy --prod --yes >"$log" 2>&1
code=$?
set -e
cat "$log"
if [ "$code" -ne 0 ]; then
  rm -f "$log"
  exit "$code"
fi

url=$(grep -Eo 'https://slopcore-[a-z0-9]+-[a-z0-9-]+\.vercel\.app' "$log" | tail -1 || true)
if [ -z "$url" ]; then
  url=$(grep -Eo 'https://[a-z0-9.-]+\.vercel\.app' "$log" | grep -v 'hgardneriv-slopcore.vercel.app' | tail -1 || true)
fi
rm -f "$log"
if [ -z "$url" ]; then
  echo "deploy finished but no deployment URL was found" >&2
  exit 1
fi

echo "checking $url"
node scripts/check-linked-media.js --base "$url"

vercel alias set "$url" hgardneriv-slopcore.vercel.app
echo "https://hgardneriv-slopcore.vercel.app"

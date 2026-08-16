#!/usr/bin/env bash
# Second-pass route check against the Pages base path. Run after
# `npm run build:pages` (a plain `npm run build` is root-relative).
set -u
mkdir -p /tmp/pagesroot
ln -sfn "$HOME/Skills-Directory/site/out" /tmp/pagesroot/Skills-Directory
cd /tmp/pagesroot
python3 -m http.server 8126 >/dev/null 2>&1 &
SRV=$!
sleep 2
for p in "" "skills/" "skills/mod/" "skills/grimoire/"; do
  c=$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:8126/Skills-Directory/$p")
  echo "route[/$p] $c"
done
kill $SRV 2>/dev/null
echo DONE

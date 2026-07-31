#!/usr/bin/env bash
set -u
echo "== enable pages =="
gh api repos/Arnav1771/Skills-Directory/pages -X POST \
  -f "source[branch]=gh-pages" -f "source[path]=/" 2>&1 | tail -3
echo "== pages status =="
gh api repos/Arnav1771/Skills-Directory/pages --jq '{status: .status, url: .html_url, branch: .source.branch}'
echo "== wait for first deploy =="
for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w '%{http_code}' https://arnav1771.github.io/Skills-Directory/)
  echo "attempt $i: $code"
  [ "$code" = "200" ] && break
  sleep 10
done
curl -s https://arnav1771.github.io/Skills-Directory/ | grep -o '<title>[^<]*</title>' | head -1

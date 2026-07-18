#!/usr/bin/env bash
# HTTP-layer smoke test for the static export, served at the same /Skills-Directory
# base path GitHub Pages will use. Run after `npm run build`.
set -u
mkdir -p /tmp/pagesroot
ln -sfn "$HOME/Skills-Directory/site/out" /tmp/pagesroot/Skills-Directory
cd /tmp/pagesroot
python3 -m http.server 8123 >/dev/null 2>&1 &
SRV=$!
sleep 1

fail=0
routes=(
  ""
  "skills/"
  "skills/mod/"
  "skills/grimoire/"
  "skills/claude-assassin/"
  "skills/code-translator/"
  "skills/supply-chain-prober/"
  "categories/"
  "categories/developer-tools/"
  "categories/business/"
  "leaderboard/"
  "search/"
  "submit/"
  "what-is-an-agent-skill/"
  "sitemap.xml"
)
for p in "${routes[@]}"; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:8123/Skills-Directory/$p")
  printf '%-45s %s\n' "/Skills-Directory/$p" "$code"
  [ "$code" = "200" ] || fail=1
done

echo "--- asset check ---"
css=$(curl -s http://127.0.0.1:8123/Skills-Directory/ | grep -o '/Skills-Directory/_next/static/[^"]*\.css' | head -1)
echo "css href: $css"
if [ -n "$css" ]; then
  code=$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:8123$css")
  echo "css fetch: $code"
  [ "$code" = "200" ] || fail=1
else
  echo "no basePath-prefixed css found"; fail=1
fi

echo "--- content spot checks ---"
curl -s http://127.0.0.1:8123/Skills-Directory/ | grep -c "agent skills" | sed 's/^/home mentions agent skills: /'
curl -s http://127.0.0.1:8123/Skills-Directory/skills/mod/ | grep -c "cp -r Skills-Directory/mod" | sed 's/^/mod install cmd present: /'
curl -s http://127.0.0.1:8123/Skills-Directory/skills/mod/ | grep -c "Definition of Done" | sed 's/^/mod SKILL.md body rendered: /'
curl -s http://127.0.0.1:8123/Skills-Directory/leaderboard/ | grep -c "score" | sed 's/^/leaderboard scores: /'
curl -s http://127.0.0.1:8123/Skills-Directory/sitemap.xml | grep -c "<loc>" | sed 's/^/sitemap urls: /'

[ -f "$HOME/Skills-Directory/site/out/.nojekyll" ] && echo ".nojekyll: present" || { echo ".nojekyll: MISSING"; fail=1; }

kill $SRV 2>/dev/null
echo "RESULT=$([ $fail -eq 0 ] && echo PASS || echo FAIL)"

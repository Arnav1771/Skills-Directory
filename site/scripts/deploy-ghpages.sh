#!/usr/bin/env bash
# Publish site/out to the gh-pages branch of the repo.
set -eu
cd "$HOME/Skills-Directory"

echo "== identity & last commit =="
git config user.name || true
git log -1 --format='author: %an <%ae>'
git log -1 --format='subject: %s'

echo "== push feature branch =="
git push -f -u origin mod/2026-07-18-directory-site 2>&1 | tail -2

echo "== build the Pages flavour of the export =="
# Must be build:pages, never a plain `npm run build`. Pages serves this repo at
# /Skills-Directory/, so the export needs the basePath prefix; a plain build
# emits root-relative asset URLs that 404 there.
(cd site && npm run build:pages)

echo "== build gh-pages tree =="
DEPLOY="$HOME/.cache/ghpages-deploy"
rm -rf "$DEPLOY"
mkdir -p "$DEPLOY"
cp -r site/out/. "$DEPLOY/"
touch "$DEPLOY/.nojekyll"
cd "$DEPLOY"
git init -q -b gh-pages
git config user.name "Arnav1771"
git config user.email "arnav.bhargava3@gmail.com"
git add -A
git commit -q -m "Deploy directory site"
git remote add origin https://github.com/Arnav1771/Skills-Directory.git
git push -f origin gh-pages 2>&1 | tail -2
echo "== done =="

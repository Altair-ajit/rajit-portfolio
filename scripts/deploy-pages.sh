#!/usr/bin/env bash
# Deploy the site to GitHub Pages (gh-pages branch).
# Publishes ONLY mockups/index.html + mockups/media/ — none of the old mockups.
# Usage: bash scripts/deploy-pages.sh
set -euo pipefail
cd "$(dirname "$0")/.."

REMOTE=$(git remote get-url origin)
NAME=$(git config user.name)
EMAIL=$(git config user.email)
TMP=$(mktemp -d)

cp mockups/index.html "$TMP"/
cp -r mockups/media "$TMP"/media
touch "$TMP"/.nojekyll

cd "$TMP"
git init -q -b gh-pages
git add -A
git -c user.name="$NAME" -c user.email="$EMAIL" commit -q -m "Deploy site"
git push -q --force "$REMOTE" gh-pages
cd /
rm -rf "$TMP"
echo "Deployed -> https://altair-ajit.github.io/rajit-portfolio/"

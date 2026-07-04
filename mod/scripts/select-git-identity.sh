#!/usr/bin/env bash
# select-git-identity.sh — pick the correct per-repo git identity by repo owner.
#
# Usage:
#   scripts/select-git-identity.sh <repo-url-or-owner>        # print identity
#   scripts/select-git-identity.sh <repo-url-or-owner> --set  # apply per-repo
#
# Rule (this machine, running inside WSL):
#   github.com/Arnav1771/*  -> personal: Arnav1771 / arnav.bhargava3@gmail.com
#   anything else (work/org) -> work:    AABH-AI  / arnav.bhargava@alignedautomation.com
#
# Never touches the WSL global config, Windows config, or stored credentials —
# it only sets `git config user.name/user.email` in the current repo when --set
# is passed.
set -euo pipefail

INPUT="${1:-}"
if [[ -z "$INPUT" ]]; then
  echo "usage: $0 <repo-url-or-owner> [--set]" >&2
  exit 2
fi

# Extract owner: handle https://github.com/OWNER/repo(.git), git@github.com:OWNER/repo, or bare OWNER.
owner="$INPUT"
owner="${owner#https://github.com/}"
owner="${owner#http://github.com/}"
owner="${owner#git@github.com:}"
owner="${owner%%/*}"

if [[ "$owner" == "Arnav1771" ]]; then
  NAME="Arnav1771"
  EMAIL="arnav.bhargava3@gmail.com"
  PROFILE="personal"
else
  NAME="AABH-AI"
  EMAIL="arnav.bhargava@alignedautomation.com"
  PROFILE="work"
fi

echo "owner=$owner profile=$PROFILE name=$NAME email=$EMAIL"

if [[ "${2:-}" == "--set" ]]; then
  git config user.name  "$NAME"
  git config user.email "$EMAIL"
  echo "applied per-repo identity in: $(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi

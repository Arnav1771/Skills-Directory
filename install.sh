#!/usr/bin/env bash
# Install a Skills-Directory skill into ANY agent CLI, in its native format.
#
#   curl -fsSL https://raw.githubusercontent.com/Arnav1771/Skills-Directory/main/install.sh | bash -s -- mod
#   ./install.sh mod --tool cursor           # from a local clone
#   ./install.sh all --tool agents --global  # every skill, into ~/.codex/AGENTS.md
#   ./install.sh --list
#
# Tools: claude-code | cursor | windsurf | gemini | agents
#   agents = the open AGENTS.md standard (Codex, Aider, opencode, Copilot, Roo,
#   Zed, Amp, Jules, and more). If --tool is omitted it is auto-detected.
set -euo pipefail

OWNER="Arnav1771"; REPO="Skills-Directory"; REF="main"
RAW="https://raw.githubusercontent.com/$OWNER/$REPO/$REF"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
LOCAL=""; [ -f "$SCRIPT_DIR/exports/index.txt" ] && LOCAL="$SCRIPT_DIR"

SKILL=""; TOOL=""; SCOPE="project"; DEST=""
while [ $# -gt 0 ]; do
  case "$1" in
    --tool) TOOL="$2"; shift 2;;
    --global) SCOPE="global"; shift;;
    --project) SCOPE="project"; shift;;
    --dir) DEST="$2"; shift 2;;
    --list) TOOL="__list"; shift;;
    -h|--help) sed -n '2,16p' "$0"; exit 0;;
    *) SKILL="$1"; shift;;
  esac
done

fetch() { # fetch <relpath> -> stdout
  if [ -n "$LOCAL" ]; then cat "$LOCAL/$1"; else curl -fsSL "$RAW/$1"; fi
}
list_skills() { fetch exports/index.txt | sed '/^$/d'; }

if [ "$TOOL" = "__list" ]; then
  echo "Available skills:"; list_skills | sed 's/^/  - /'
  echo "Tools: claude-code | cursor | windsurf | gemini | agents (auto-detected if omitted)"
  exit 0
fi
[ -z "$SKILL" ] && { echo "usage: install.sh <skill|all> [--tool T] [--global] [--dir PATH]"; echo "run with --list to see skills"; exit 1; }

detect_tool() {
  [ -d .cursor ] && { echo cursor; return; }
  [ -d .windsurf ] && { echo windsurf; return; }
  { [ -f AGENTS.md ] || [ -d .codex ] || [ -f "$HOME/.codex/AGENTS.md" ]; } && { echo agents; return; }
  [ -f GEMINI.md ] || [ -d "$HOME/.gemini" ] && { echo gemini; return; }
  [ -d "$HOME/.claude" ] && { echo claude-code; return; }
  echo agents  # universal fallback
}
[ -z "$TOOL" ] && { TOOL="$(detect_tool)"; echo "No --tool given; detected: $TOOL"; }

# Replace or append a marked block in a concatenated file (AGENTS.md / GEMINI.md).
put_block() { # put_block <targetfile> <skill> <contentfile>
  local target="$1" name="$2" src="$3"
  mkdir -p "$(dirname "$target")"; touch "$target"
  if grep -q "skills-directory:$name START" "$target" 2>/dev/null; then
    awk -v s="skills-directory:$name START" -v e="skills-directory:$name END" \
      'index($0,s){skip=1} !skip{print} index($0,e){skip=0}' "$target" > "$target.tmp"
    mv "$target.tmp" "$target"
    echo "  (replaced existing $name block)"
  fi
  printf '\n' >> "$target"; cat "$src" >> "$target"
}

install_one() { # install_one <skill>
  local name="$1" tmp
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' RETURN
  case "$TOOL" in
    cursor)
      local out=".cursor/rules"; [ "$SCOPE" = global ] && out="$HOME/.cursor/rules"
      [ -n "$DEST" ] && out="$DEST"
      mkdir -p "$out"; fetch "exports/cursor/$name.mdc" > "$out/$name.mdc"
      echo "installed: $out/$name.mdc";;
    windsurf)
      local out=".windsurf/rules"; [ "$SCOPE" = global ] && out="$HOME/.windsurf/rules"
      [ -n "$DEST" ] && out="$DEST"
      mkdir -p "$out"; fetch "exports/windsurf/$name.md" > "$out/$name.md"
      echo "installed: $out/$name.md";;
    gemini)
      local target="GEMINI.md"; [ "$SCOPE" = global ] && target="$HOME/.gemini/GEMINI.md"
      [ -n "$DEST" ] && target="$DEST"
      fetch "exports/gemini/$name.md" > "$tmp/s.md"; put_block "$target" "$name" "$tmp/s.md"
      echo "installed into: $target";;
    agents)
      local target="AGENTS.md"; [ "$SCOPE" = global ] && target="$HOME/.codex/AGENTS.md"
      [ -n "$DEST" ] && target="$DEST"
      fetch "exports/agents/$name.md" > "$tmp/s.md"; put_block "$target" "$name" "$tmp/s.md"
      echo "installed into: $target";;
    claude-code)
      local out="$HOME/.claude/skills"; [ "$SCOPE" = project ] && out=".claude/skills"
      [ -n "$DEST" ] && out="$DEST"
      if [ -n "$LOCAL" ]; then
        mkdir -p "$out"; cp -r "$LOCAL/$name" "$out/$name"; echo "installed: $out/$name/ (native folder)"
      else
        echo "claude-code needs the whole skill folder. Easiest paths:"
        echo "  /plugin marketplace add $OWNER/$REPO   then   /plugin install $name@skills-directory"
        echo "  or: git clone https://github.com/$OWNER/$REPO && cp -r $REPO/$name ~/.claude/skills/"
      fi;;
    *) echo "unknown tool: $TOOL"; exit 1;;
  esac
}

if [ "$SKILL" = all ]; then
  while IFS= read -r s; do [ -n "$s" ] && install_one "$s"; done < <(list_skills)
else
  install_one "$SKILL"
fi
echo "Done. Restart your CLI (or start a new session) so it picks up the new instructions."

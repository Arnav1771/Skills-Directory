#!/usr/bin/env bash
# scaffold-imp-docs.sh — create the IMP Docs/ folder with the five versioned
# living docs. Never overwrites an existing file (documents are superseded, not
# clobbered).
#
# Usage: scripts/scaffold-imp-docs.sh [repo-root]   (defaults to cwd)
set -euo pipefail

ROOT="${1:-$(pwd)}"
DOCS="$ROOT/IMP Docs"
mkdir -p "$DOCS"

create() {  # create <filename> <heredoc-body-on-stdin>
  local f="$DOCS/$1"
  if [[ -e "$f" ]]; then
    echo "skip (exists): $f"
  else
    cat > "$f"
    echo "created: $f"
  fi
}

create HANDOFF.md <<'EOF'
# HANDOFF — <project> (v1)

## Goal

## Files inspected

## Files modified

## Current state

## Tests run + results

## Known issues & limitations

## Next exact steps
1.
EOF

create TECHSPEC.md <<'EOF'
# TECHSPEC — <project> (v1)

## Architecture overview
## Tech stack & dependencies
## Data flow / system design
## API contracts / interfaces
## Environment setup
## Deployment notes
EOF

create PROMPT_TRAIL.md <<'EOF'
# PROMPT_TRAIL — <project>

<!-- Append one entry after every prompt. Never rewrite history. -->
EOF

create DESIGN_CHOICES.md <<'EOF'
# DESIGN_CHOICES — <project> (v1)

## Skills / plugins used (and why)
## Theme system
## Notable architectural / UX decisions
EOF

create TODOS.md <<'EOF'
# TODOS — <project> (v1)

## Model-assigned

## User-assigned
EOF

echo "done: $DOCS"

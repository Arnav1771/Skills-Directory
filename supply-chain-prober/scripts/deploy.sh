#!/usr/bin/env bash
# deploy.sh — Generate personalized probing sessions for a list of users
# Usage: ./deploy.sh users.csv output_dir/
#
# users.csv format (first row is header):
#   name,email,role,company
#   John Doe,john@acme.com,Procurement Manager,Acme Corp

set -euo pipefail

USERS_FILE="${1:?Usage: ./deploy.sh users.csv output_dir/}"
OUTPUT_DIR="${2:?Usage: ./deploy.sh users.csv output_dir/}"
TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$OUTPUT_DIR"

echo "╔══════════════════════════════════════════╗"
echo "║   Supply Chain Prober — Deployment Tool  ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Reading users from: $USERS_FILE"
echo "Output directory:   $OUTPUT_DIR"
echo ""

COUNT=0

# Skip header row
tail -n +2 "$USERS_FILE" | while IFS=',' read -r name email role company; do
  COUNT=$((COUNT + 1))

  # Create a sanitized directory name
  SAFE_NAME=$(echo "$name" | tr ' ' '_' | tr -cd '[:alnum:]_')
  SESSION_DIR="$OUTPUT_DIR/${SAFE_NAME}_${TIMESTAMP}"
  mkdir -p "$SESSION_DIR"

  # Generate the session context file
  cat > "$SESSION_DIR/session_context.json" <<EOF
{
  "session_id": "probe_${SAFE_NAME}_${TIMESTAMP}",
  "respondent": {
    "name": "$name",
    "email": "$email",
    "role": "$role",
    "company": "$company"
  },
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "pending",
  "question_bank": "references/question_bank.md",
  "responses_file": "responses.json"
}
EOF

  # Create empty responses file
  echo '[]' > "$SESSION_DIR/responses.json"

  echo "  ✓ Session created for: $name ($email) — $role @ $company"
done

echo ""
echo "✅ Deployment complete. Sessions generated in: $OUTPUT_DIR"
echo "   Share each user's session_context.json with the probing agent."

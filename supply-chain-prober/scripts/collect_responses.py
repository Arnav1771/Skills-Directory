#!/usr/bin/env python3
"""collect_responses.py — Aggregate probing session responses into a master dataset.

Usage:
    python collect_responses.py <sessions_dir> <output_file>

Example:
    python collect_responses.py ./deployed_sessions ./master_responses.json

This script:
1. Walks through all session directories
2. Reads each responses.json file
3. Merges them into a single master JSON with respondent metadata
4. Generates an SME validation report (Markdown) alongside the master file
"""

import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path


def load_session(session_dir: Path) -> dict | None:
    """Load a single session's context and responses."""
    context_file = session_dir / "session_context.json"
    responses_file = session_dir / "responses.json"

    if not context_file.exists() or not responses_file.exists():
        return None

    with open(context_file) as f:
        context = json.load(f)
    with open(responses_file) as f:
        responses = json.load(f)

    if not responses:  # Skip empty sessions
        return None

    return {
        "session_id": context.get("session_id", "unknown"),
        "respondent": context.get("respondent", {}),
        "status": context.get("status", "unknown"),
        "response_count": len(responses),
        "responses": responses,
    }


def generate_sme_report(sessions: list[dict], output_path: Path) -> None:
    """Generate a Markdown report for SME validation."""
    report_path = output_path.with_suffix(".sme_report.md")
    lines = [
        "# Supply Chain Probing — SME Validation Report",
        "",
        f"Generated: {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}",
        f"Total respondents: {len(sessions)}",
        f"Total answers collected: {sum(s['response_count'] for s in sessions)}",
        "",
        "---",
        "",
    ]

    for session in sessions:
        r = session["respondent"]
        lines.append(f"## {r.get('name', 'Unknown')} — {r.get('role', 'N/A')} @ {r.get('company', 'N/A')}")
        lines.append("")
        lines.append(f"Session ID: `{session['session_id']}`")
        lines.append(f"Answers provided: {session['response_count']}")
        lines.append("")

        for resp in session["responses"]:
            q = resp.get("question", "N/A")
            a = resp.get("answer", "N/A")
            lines.append(f"**Q: {q}**")
            lines.append(f"> {a}")
            lines.append("")
            lines.append("SME Validation: [ ] Accurate  [ ] Needs Clarification  [ ] Incorrect")
            lines.append("")
            lines.append("SME Notes: _____________________")
            lines.append("")

        lines.append("---")
        lines.append("")

    with open(report_path, "w") as f:
        f.write("\n".join(lines))

    print(f"  ✓ SME validation report: {report_path}")


def main() -> None:
    if len(sys.argv) < 3:
        print("Usage: python collect_responses.py <sessions_dir> <output_file>")
        sys.exit(1)

    sessions_dir = Path(sys.argv[1])
    output_file = Path(sys.argv[2])

    if not sessions_dir.is_dir():
        print(f"Error: {sessions_dir} is not a valid directory.")
        sys.exit(1)

    sessions = []
    for entry in sorted(sessions_dir.iterdir()):
        if entry.is_dir():
            session = load_session(entry)
            if session:
                sessions.append(session)

    if not sessions:
        print("No completed sessions found.")
        sys.exit(0)

    master = {
        "collected_at": datetime.now(timezone.utc).isoformat(),
        "total_respondents": len(sessions),
        "total_responses": sum(s["response_count"] for s in sessions),
        "sessions": sessions,
    }

    output_file.parent.mkdir(parents=True, exist_ok=True)
    with open(output_file, "w") as f:
        json.dump(master, f, indent=2)

    print(f"\n✅ Master dataset written to: {output_file}")
    print(f"   Respondents: {len(sessions)}")
    print(f"   Total answers: {master['total_responses']}")

    generate_sme_report(sessions, output_file)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""collect_responses.py — Aggregate probing session responses into a master dataset.

Usage:
    python collect_responses.py <sessions_dir> <output_file>

Example:
    python collect_responses.py ./sessions ./output/master.json

Outputs:
    master.json            — Aggregated dataset with all sessions
    master.sme_report.md   — Per-answer validation checklist for SMEs
    master.analytics.md    — Completion rates, risk heatmap, coverage stats
"""

import json
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path


def load_session(session_dir: Path) -> dict | None:
    context_file = session_dir / "session_context.json"
    responses_file = session_dir / "responses.json"

    if not context_file.exists() or not responses_file.exists():
        return None

    with open(context_file) as f:
        context = json.load(f)
    with open(responses_file) as f:
        responses = json.load(f)

    if not responses:
        return None

    return {
        "session_id": context.get("session_id", "unknown"),
        "respondent": context.get("respondent", {}),
        "status": context.get("status", "unknown"),
        "response_count": len(responses),
        "responses": responses,
    }


def generate_sme_report(sessions: list[dict], output_path: Path) -> None:
    report_path = output_path.with_name(output_path.stem + ".sme_report.md")
    total_answers = sum(s["response_count"] for s in sessions)

    lines = [
        "# Supply Chain Probing — SME Validation Report",
        "",
        f"Generated: {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}  ",
        f"Total respondents: **{len(sessions)}**  ",
        f"Total answers: **{total_answers}**",
        "",
        "> **Instructions for the SME:** For each answer below, mark one checkbox and add your notes.",
        "> When done, save this file and return it to the tech team.",
        "",
        "---",
        "",
    ]

    for session in sessions:
        r = session["respondent"]
        lines.append(f"## {r.get('name', 'Unknown')} — {r.get('role', 'N/A')} @ {r.get('company', 'N/A')}")
        lines.append("")
        lines.append(f"Session: `{session['session_id']}` · Answers: {session['response_count']}")
        lines.append("")

        for i, resp in enumerate(session["responses"], 1):
            q = resp.get("question", "N/A")
            a = resp.get("answer", "N/A")
            conf = resp.get("confidence", "—")
            flags = ", ".join(resp.get("risk_flags", [])) or "none"

            lines.append(f"### Q{i}: {q}")
            lines.append("")
            lines.append(f"> {a}")
            lines.append("")
            lines.append(f"Confidence: `{conf}` · Risks: `{flags}`")
            lines.append("")
            lines.append("- [ ] Accurate")
            lines.append("- [ ] Needs Clarification")
            lines.append("- [ ] Incorrect")
            lines.append("")
            lines.append("SME Notes: ")
            lines.append("")

        lines.append("---")
        lines.append("")

    with open(report_path, "w") as f:
        f.write("\n".join(lines))
    print(f"  ✓ SME report: {report_path}")


def generate_analytics(sessions: list[dict], total_dirs: int, output_path: Path) -> None:
    report_path = output_path.with_name(output_path.stem + ".analytics.md")
    total_responses = sum(s["response_count"] for s in sessions)
    completion_rate = (len(sessions) / total_dirs * 100) if total_dirs > 0 else 0

    # Risk distribution
    risk_counter: Counter = Counter()
    for s in sessions:
        for resp in s["responses"]:
            for flag in resp.get("risk_flags", []):
                risk_counter[flag] += 1

    # Confidence distribution
    conf_counter: Counter = Counter()
    for s in sessions:
        for resp in s["responses"]:
            conf_counter[resp.get("confidence", "unknown")] += 1

    # Category coverage
    cat_counter: Counter = Counter()
    for s in sessions:
        for resp in s["responses"]:
            cat_counter[resp.get("category", "Uncategorized")] += 1

    # Respondent roles
    role_counter: Counter = Counter()
    for s in sessions:
        role_counter[s["respondent"].get("role", "Unknown")] += 1

    lines = [
        "# Supply Chain Probing — Analytics Report",
        "",
        f"Generated: {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}",
        "",
        "## Overview",
        "",
        f"| Metric | Value |",
        f"|--------|-------|",
        f"| Sessions deployed | {total_dirs} |",
        f"| Sessions completed | {len(sessions)} |",
        f"| Completion rate | {completion_rate:.1f}% |",
        f"| Total answers collected | {total_responses} |",
        f"| Avg answers per session | {total_responses / len(sessions):.1f} |" if sessions else "",
        "",
        "## Risk Heatmap",
        "",
        "| Risk Flag | Occurrences |",
        "|-----------|-------------|",
    ]
    for flag, count in risk_counter.most_common():
        bar = "█" * min(count, 40)
        lines.append(f"| `{flag}` | {count} {bar} |")
    if not risk_counter:
        lines.append("| *(no risks flagged)* | 0 |")

    lines += [
        "",
        "## Answer Confidence Distribution",
        "",
        "| Confidence | Count |",
        "|------------|-------|",
    ]
    for level in ["high", "medium", "low", "unknown"]:
        if conf_counter[level]:
            lines.append(f"| {level} | {conf_counter[level]} |")

    lines += [
        "",
        "## Category Coverage",
        "",
        "| Category | Answers |",
        "|----------|---------|",
    ]
    for cat, count in cat_counter.most_common():
        lines.append(f"| {cat} | {count} |")

    lines += [
        "",
        "## Respondent Roles",
        "",
        "| Role | Count |",
        "|------|-------|",
    ]
    for role, count in role_counter.most_common():
        lines.append(f"| {role} | {count} |")

    with open(report_path, "w") as f:
        f.write("\n".join(lines))
    print(f"  ✓ Analytics report: {report_path}")


def main() -> None:
    if len(sys.argv) < 3:
        print("Usage: python collect_responses.py <sessions_dir> <output_file>")
        sys.exit(1)

    sessions_dir = Path(sys.argv[1])
    output_file = Path(sys.argv[2])

    if not sessions_dir.is_dir():
        print(f"Error: {sessions_dir} is not a valid directory.")
        sys.exit(1)

    all_dirs = [e for e in sorted(sessions_dir.iterdir()) if e.is_dir()]
    sessions = []
    for entry in all_dirs:
        session = load_session(entry)
        if session:
            sessions.append(session)

    if not sessions:
        print("No completed sessions found.")
        sys.exit(0)

    # Risk summary
    risk_counter: Counter = Counter()
    for s in sessions:
        for resp in s["responses"]:
            for flag in resp.get("risk_flags", []):
                risk_counter[flag] += 1

    master = {
        "collected_at": datetime.now(timezone.utc).isoformat(),
        "total_respondents": len(sessions),
        "total_responses": sum(s["response_count"] for s in sessions),
        "completion_rate": f"{len(sessions) / len(all_dirs) * 100:.1f}%" if all_dirs else "0%",
        "risk_summary": dict(risk_counter.most_common()),
        "sessions": sessions,
    }

    output_file.parent.mkdir(parents=True, exist_ok=True)
    with open(output_file, "w") as f:
        json.dump(master, f, indent=2)

    print(f"\n✅ Master dataset: {output_file}")
    print(f"   Respondents: {len(sessions)} / {len(all_dirs)}")
    print(f"   Total answers: {master['total_responses']}")

    generate_sme_report(sessions, output_file)
    generate_analytics(sessions, len(all_dirs), output_file)


if __name__ == "__main__":
    main()

"use client";

import { useState } from "react";
import { ChevronDown } from "lucide-react";

const FAQS: { q: string; a: React.ReactNode }[] = [
  {
    q: "What is an Agent Skill?",
    a: (
      <>
        A skill is a portable folder of instructions — a required{" "}
        <code className="font-mono text-xs">SKILL.md</code> plus optional scripts,
        references, and assets — that teaches an AI coding agent a reusable
        capability. The agent loads it automatically when your request matches the
        skill&apos;s description.
      </>
    ),
  },
  {
    q: "How do I install one?",
    a: (
      <>
        Clone the repo and copy the skill folder into your agent&apos;s skills
        directory, e.g.{" "}
        <code className="font-mono text-xs">
          cp -r Skills-Directory/mod ~/.claude/skills/mod
        </code>{" "}
        for Claude Code. On Claude.ai, zip the folder and upload it under Settings
        → Capabilities → Skills. Each skill&apos;s detail page has a
        copy-to-clipboard install command.
      </>
    ),
  },
  {
    q: "Can I build my own?",
    a: (
      <>
        Yes — create a kebab-case folder with a <code className="font-mono text-xs">SKILL.md</code>{" "}
        (and ideally a <code className="font-mono text-xs">manifest.yaml</code> so it shows up
        nicely here), then open a pull request. The Submit page walks through the
        whole ritual.
      </>
    ),
  },
  {
    q: "Do skills only work with Claude?",
    a: (
      <>
        The format follows Anthropic&apos;s skill-building guide, but a skill is just
        markdown + scripts — any agent that can read a folder of instructions can
        use one.
      </>
    ),
  },
];

export default function FaqAccordion() {
  const [open, setOpen] = useState<number | null>(0);
  return (
    <div className="divide-y divide-line rounded-xl border border-line bg-surface">
      {FAQS.map((f, i) => (
        <div key={f.q}>
          <button
            onClick={() => setOpen(open === i ? null : i)}
            className="flex w-full items-center justify-between gap-4 px-5 py-4 text-left text-sm font-medium"
            aria-expanded={open === i}
          >
            {f.q}
            <ChevronDown
              size={16}
              className={`shrink-0 text-muted transition-transform ${open === i ? "rotate-180" : ""}`}
            />
          </button>
          {open === i && (
            <div className="px-5 pb-4 text-sm leading-relaxed text-muted">{f.a}</div>
          )}
        </div>
      ))}
    </div>
  );
}

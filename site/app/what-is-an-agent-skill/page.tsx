import type { Metadata } from "next";
import Link from "next/link";
import { BookOpen, FolderTree, Puzzle, Zap } from "lucide-react";
import CopyButton from "@/components/CopyButton";

export const metadata: Metadata = {
  title: "What is an Agent Skill?",
  description:
    "Agent skills explained: portable folders of instructions, scripts, and references that teach AI coding agents reusable capabilities.",
};

const STRUCTURE = `my-skill-name/
├── SKILL.md              # Required — the brain of the skill
├── manifest.yaml         # Optional — catalog metadata for discovery
├── scripts/              # Optional — executable helpers (bash, python)
├── references/           # Optional — docs loaded on demand
├── assets/               # Optional — templates, icons, fonts
└── examples/             # Optional — sample sessions`;

export default function ExplainerPage() {
  return (
    <div className="mx-auto flex max-w-3xl flex-col gap-8 py-10">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">What is an Agent Skill?</h1>
        <p className="mt-2 leading-relaxed text-muted">
          An agent skill is a <strong className="text-foreground">portable folder of
          instructions</strong> that teaches an AI coding agent — Claude Code,
          Claude.ai, or anything that can read markdown — a reusable capability. No
          plugins, no APIs to integrate: install is a <code className="rounded bg-accent-soft px-1 py-0.5 font-mono text-xs text-accent">cp -r</code>.
        </p>
      </div>

      <Card icon={<BookOpen size={16} />} title="SKILL.md is the brain">
        <p>
          Every skill has exactly one required file. Its YAML frontmatter carries a{" "}
          <em>trigger-rich description</em> — what the skill does <em>and</em> when
          to use it, including the phrases users actually say. The agent matches
          your request against these descriptions and loads the skill automatically;
          the markdown body is the workflow it then follows.
        </p>
      </Card>

      <Card icon={<FolderTree size={16} />} title="Progressive disclosure">
        <p className="mb-3">
          Bigger skills stay token-cheap by splitting detail into folders the agent
          reads only on demand:
        </p>
        <div className="flex items-start gap-2 rounded-lg border border-line bg-background p-3">
          <pre className="min-w-0 flex-1 overflow-x-auto font-mono text-xs leading-relaxed">
            {STRUCTURE}
          </pre>
          <CopyButton text={STRUCTURE} />
        </div>
      </Card>

      <Card icon={<Zap size={16} />} title="Deterministic where it matters">
        <p>
          Language interpretation is flexible; code is deterministic. Good skills
          push repeatable steps into <code className="rounded bg-accent-soft px-1 py-0.5 font-mono text-xs text-accent">scripts/</code>{" "}
          so the agent runs a tested helper instead of improvising — see{" "}
          <Link href="/skills/claude-assassin/" className="font-mono text-accent underline underline-offset-2">
            claude-assassin
          </Link>{" "}
          and{" "}
          <Link href="/skills/mod/" className="font-mono text-accent underline underline-offset-2">
            mod
          </Link>
          .
        </p>
      </Card>

      <Card icon={<Puzzle size={16} />} title="Skills compose">
        <p>
          Skills reference each other via <code className="rounded bg-accent-soft px-1 py-0.5 font-mono text-xs text-accent">composesWell</code>{" "}
          in their manifest: generate an app with{" "}
          <Link href="/skills/grimoire/" className="font-mono text-accent underline underline-offset-2">
            grimoire
          </Link>
          , ship and QA it with{" "}
          <Link href="/skills/mod/" className="font-mono text-accent underline underline-offset-2">
            mod
          </Link>
          , and keep long sessions alive with{" "}
          <Link href="/skills/claude-assassin/" className="font-mono text-accent underline underline-offset-2">
            claude-assassin
          </Link>
          .
        </p>
      </Card>

      <div className="flex flex-col items-center gap-3 rounded-xl border border-line bg-surface p-6 text-center">
        <p className="text-sm text-muted">
          The format follows Anthropic&apos;s guide to building skills for Claude.
        </p>
        <div className="flex gap-3">
          <Link
            href="/skills/"
            className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background transition-opacity hover:opacity-90"
          >
            Browse the catalog
          </Link>
          <Link
            href="/submit/"
            className="rounded-lg border border-line px-4 py-2 text-sm text-muted transition-colors hover:border-accent hover:text-accent"
          >
            Build your own
          </Link>
        </div>
      </div>
    </div>
  );
}

function Card({
  icon,
  title,
  children,
}: {
  icon: React.ReactNode;
  title: string;
  children: React.ReactNode;
}) {
  return (
    <section className="rounded-xl border border-line bg-surface p-5">
      <h2 className="mb-2 flex items-center gap-2 text-sm font-semibold">
        <span className="flex h-6 w-6 items-center justify-center rounded-md bg-accent-soft text-accent">
          {icon}
        </span>
        {title}
      </h2>
      <div className="text-sm leading-relaxed text-muted">{children}</div>
    </section>
  );
}

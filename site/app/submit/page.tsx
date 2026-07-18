import type { Metadata } from "next";
import Link from "next/link";
import { GitPullRequest, FolderTree, FileText, CheckCircle2 } from "lucide-react";
import CopyButton from "@/components/CopyButton";

export const metadata: Metadata = {
  title: "Submit a skill",
  description:
    "How to add your own agent skill to the directory: fork, add a skill folder, open a PR.",
};

const PUSH_SNIPPET = `git checkout -b add-my-skill-name
git add my-skill-name/
git commit -m "Add my-skill-name skill"
git push -u origin add-my-skill-name
gh pr create --fill`;

const MANIFEST_SNIPPET = `name: my-skill-name
description: "One-line catalog card — what it does and when to use it."
categories:
  - developer-tools
tags:
  - build
icon: Rocket          # any Lucide icon name
version: "1.0.0"
composesWell: []`;

export default function SubmitPage() {
  return (
    <div className="mx-auto flex max-w-3xl flex-col gap-8 py-10">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Submit a skill</h1>
        <p className="mt-1 text-sm text-muted">
          The directory is contribution-driven: fork the repo, add a skill folder,
          open a pull request. Merged skills appear here automatically on the next
          site build. The full{" "}
          <a
            className="text-accent underline underline-offset-2"
            href="https://github.com/Arnav1771/Skills-Directory#-the-ritual-how-to-add-a-new-skill"
            target="_blank"
            rel="noreferrer"
          >
            Ritual: How to Add a New Skill
          </a>{" "}
          lives in the README.
        </p>
      </div>

      <Step icon={<FolderTree size={16} />} n={1} title="Create the folder">
        <p>
          Kebab-case name, matching the skill&apos;s <code>name</code>. At minimum it
          needs a <code>SKILL.md</code>; richer skills add <code>scripts/</code>,{" "}
          <code>references/</code>, <code>examples/</code>, and a workflow diagram.
        </p>
      </Step>

      <Step icon={<FileText size={16} />} n={2} title="Write SKILL.md + manifest.yaml">
        <p className="mb-3">
          <code>SKILL.md</code> frontmatter (name + trigger-rich description) is what
          the agent reads. <code>manifest.yaml</code> is the optional catalog card
          this site renders:
        </p>
        <Snippet text={MANIFEST_SNIPPET} />
        <p className="mt-3 text-xs">
          Keep <code>SKILL.md</code> under 500 lines, no angle brackets in
          descriptions, and validate with{" "}
          <code>bash &quot;IMP Docs/run_validate.sh&quot;</code>.
        </p>
      </Step>

      <Step icon={<GitPullRequest size={16} />} n={3} title="Open a pull request">
        <Snippet text={PUSH_SNIPPET} />
        <p className="mt-3 text-xs">
          Add your skill to the README catalog table and note the change in{" "}
          <code>IMP Docs/Update.md</code>. Merges land on <code>main</code> via
          review.
        </p>
      </Step>

      <div className="flex items-start gap-3 rounded-xl border border-line bg-surface p-5 text-sm text-muted">
        <CheckCircle2 size={18} className="mt-0.5 shrink-0 text-accent" />
        <p>
          Not sure what a skill should look like? Read{" "}
          <Link href="/what-is-an-agent-skill/" className="text-accent underline underline-offset-2">
            What is an Agent Skill?
          </Link>{" "}
          or browse an existing one like{" "}
          <Link href="/skills/mod/" className="font-mono text-accent underline underline-offset-2">
            mod
          </Link>
          , which uses every optional folder.
        </p>
      </div>
    </div>
  );
}

function Step({
  icon,
  n,
  title,
  children,
}: {
  icon: React.ReactNode;
  n: number;
  title: string;
  children: React.ReactNode;
}) {
  return (
    <section className="rounded-xl border border-line bg-surface p-5">
      <h2 className="mb-3 flex items-center gap-2 text-sm font-semibold">
        <span className="flex h-6 w-6 items-center justify-center rounded-md bg-accent-soft text-accent">
          {icon}
        </span>
        Step {n} — {title}
      </h2>
      <div className="text-sm leading-relaxed text-muted [&_code]:rounded [&_code]:bg-accent-soft [&_code]:px-1 [&_code]:py-0.5 [&_code]:font-mono [&_code]:text-xs [&_code]:text-accent">
        {children}
      </div>
    </section>
  );
}

function Snippet({ text }: { text: string }) {
  return (
    <div className="flex items-start gap-2 rounded-lg border border-line bg-background p-3">
      <pre className="min-w-0 flex-1 overflow-x-auto font-mono text-xs leading-relaxed">
        {text}
      </pre>
      <CopyButton text={text} />
    </div>
  );
}

import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import {
  ArrowUpRight,
  FileCode2,
  FolderGit2,
  Library,
  Terminal,
  Workflow,
} from "lucide-react";
import { getSkill, getSkills, categoryLabel } from "@/lib/skills";
import SkillIcon from "@/components/SkillIcon";
import CopyButton from "@/components/CopyButton";

export function generateStaticParams() {
  return getSkills().map((s) => ({ slug: s.slug }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const skill = getSkill(slug);
  if (!skill) return {};
  return { title: skill.name, description: skill.description };
}

export default async function SkillPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const skill = getSkill(slug);
  if (!skill) notFound();

  const related = skill.composesWell
    .map((name) => getSkills().find((s) => s.name === name))
    .filter((s): s is NonNullable<typeof s> => Boolean(s));
  const inbound = getSkills().filter(
    (s) => s.slug !== skill.slug && s.composesWell.includes(skill.name)
  );

  return (
    <div className="grid gap-10 py-10 lg:grid-cols-[1fr_290px]">
      <article className="min-w-0">
        <header className="mb-8 flex flex-col gap-4">
          <div className="flex items-center gap-4">
            <span className="flex h-14 w-14 items-center justify-center rounded-xl bg-accent-soft text-accent">
              <SkillIcon name={skill.icon} className="h-7 w-7" />
            </span>
            <div>
              <h1 className="font-mono text-2xl font-bold tracking-tight">
                {skill.name}
              </h1>
              <div className="mt-1 flex flex-wrap items-center gap-2 text-xs text-muted">
                <span className="rounded-full border border-line px-2 py-0.5">
                  v{skill.version}
                </span>
                {skill.categories.map((c) => (
                  <Link
                    key={c}
                    href={`/categories/${c}/`}
                    className="rounded-full border border-line px-2 py-0.5 hover:border-accent hover:text-accent"
                  >
                    {categoryLabel(c)}
                  </Link>
                ))}
                {skill.lastUpdated && (
                  <span>updated {skill.lastUpdated.slice(0, 10)}</span>
                )}
              </div>
            </div>
          </div>
          <p className="text-muted">{skill.description}</p>
          <div className="flex flex-wrap gap-1.5">
            {skill.tags.map((t) => (
              <Link
                key={t}
                href={`/skills/?tags=${encodeURIComponent(t)}`}
                className="rounded-md bg-accent-soft px-2 py-0.5 font-mono text-[11px] text-accent hover:opacity-80"
              >
                {t}
              </Link>
            ))}
          </div>
        </header>

        <section className="mb-8 rounded-xl border border-line bg-surface p-5">
          <h2 className="mb-3 flex items-center gap-2 text-sm font-semibold">
            <Terminal size={15} className="text-accent" /> Install
          </h2>
          <ol className="mb-3 list-decimal pl-5 text-sm text-muted">
            <li>
              Clone the repo:{" "}
              <code className="font-mono text-xs">
                git clone https://github.com/Arnav1771/Skills-Directory.git
              </code>
            </li>
            <li>Copy the skill folder into your agent&apos;s skills directory:</li>
          </ol>
          <div className="flex items-center gap-2 rounded-lg border border-line bg-background px-3 py-2">
            <code className="min-w-0 flex-1 overflow-x-auto whitespace-nowrap font-mono text-xs">
              {skill.installCommand}
            </code>
            <CopyButton text={skill.installCommand} />
          </div>
          <p className="mt-3 text-xs text-muted">
            On Claude.ai: zip the <code className="font-mono">{skill.slug}/</code>{" "}
            folder and upload it under Settings → Capabilities → Skills. The skill
            then activates automatically on matching requests.
          </p>
        </section>

        <h2 className="mb-2 flex items-center gap-2 text-sm font-semibold uppercase tracking-wide text-muted">
          <FileCode2 size={14} /> SKILL.md
        </h2>
        <div
          className="skill-doc min-w-0"
          dangerouslySetInnerHTML={{ __html: skill.bodyHtml }}
        />
      </article>

      <aside className="flex flex-col gap-6 lg:sticky lg:top-20 lg:self-start">
        <div className="rounded-xl border border-line bg-surface p-5 text-sm">
          <h3 className="mb-3 font-semibold">On GitHub</h3>
          <a
            href={skill.githubUrl}
            target="_blank"
            rel="noreferrer"
            className="inline-flex items-center gap-1.5 text-accent hover:underline underline-offset-2"
          >
            <FolderGit2 size={15} /> {skill.folderPath}/ <ArrowUpRight size={13} />
          </a>
          <ul className="mt-3 space-y-1 text-xs text-muted">
            <li>SKILL.md {skill.hasManifest && "· manifest.yaml"}</li>
            {skill.hasScripts && <li>scripts/ — executable helpers</li>}
            {skill.hasReferences && <li>references/ — on-demand docs</li>}
            {skill.hasExamples && <li>examples/ — sample sessions</li>}
            {skill.diagrams.map((d) => (
              <li key={d}>{d}</li>
            ))}
          </ul>
        </div>

        {(related.length > 0 || inbound.length > 0) && (
          <div className="rounded-xl border border-line bg-surface p-5 text-sm">
            <h3 className="mb-3 flex items-center gap-1.5 font-semibold">
              <Library size={14} className="text-accent" /> Composes well with
            </h3>
            <ul className="space-y-2">
              {[...new Map([...related, ...inbound].map((s) => [s.slug, s])).values()].map(
                (s) => (
                  <li key={s.slug}>
                    <Link
                      href={`/skills/${s.slug}/`}
                      className="group flex items-center gap-2"
                    >
                      <SkillIcon
                        name={s.icon}
                        className="h-4 w-4 text-accent"
                      />
                      <span className="font-mono text-xs group-hover:text-accent">
                        {s.name}
                      </span>
                    </Link>
                  </li>
                )
              )}
            </ul>
          </div>
        )}

        <div className="rounded-xl border border-line bg-surface p-5 text-sm">
          <h3 className="mb-2 flex items-center gap-1.5 font-semibold">
            <Workflow size={14} className="text-accent" /> Trigger
          </h3>
          <p className="text-xs leading-relaxed text-muted">
            {skill.triggerDescription || skill.description}
          </p>
        </div>
      </aside>
    </div>
  );
}

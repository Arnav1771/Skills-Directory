import type { Metadata } from "next";
import Link from "next/link";
import { Medal, Star } from "lucide-react";
import { getCatalog, topSkills, categoryLabel } from "@/lib/skills";
import SkillIcon from "@/components/SkillIcon";

export const metadata: Metadata = {
  title: "Leaderboard",
  description:
    "Skills ranked by composability, maturity, and completeness of their toolkit.",
};

const MEDAL = ["text-amber-400", "text-zinc-400", "text-amber-700"];

export default function LeaderboardPage() {
  const { repo } = getCatalog();
  const ranked = topSkills();

  return (
    <div className="mx-auto flex max-w-3xl flex-col gap-6 py-10">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Leaderboard</h1>
        <p className="mt-1 text-sm text-muted">
          All skills share one repository ({repo.stars}{" "}
          <Star size={11} className="-mt-0.5 inline text-accent" /> on GitHub), so
          ranking uses a composite score: how many skills compose with it, semantic
          version maturity, and whether it ships scripts, references, and diagrams.
        </p>
      </div>
      <ol className="flex flex-col gap-3">
        {ranked.map((s, i) => (
          <li key={s.slug}>
            <Link
              href={`/skills/${s.slug}/`}
              className="group flex items-center gap-4 rounded-xl border border-line bg-surface p-4 transition-all hover:border-accent"
            >
              <span className="w-8 text-center">
                {i < 3 ? (
                  <Medal size={20} className={`inline ${MEDAL[i]}`} />
                ) : (
                  <span className="font-mono text-sm text-muted">{i + 1}</span>
                )}
              </span>
              <span className="flex h-10 w-10 items-center justify-center rounded-lg bg-accent-soft text-accent">
                <SkillIcon name={s.icon} className="h-5 w-5" />
              </span>
              <div className="min-w-0 flex-1">
                <div className="flex items-center gap-2">
                  <span className="font-mono text-sm font-semibold group-hover:text-accent">
                    {s.name}
                  </span>
                  <span className="text-[11px] text-muted">v{s.version}</span>
                </div>
                <p className="truncate text-xs text-muted">{s.description}</p>
              </div>
              <div className="hidden text-right sm:block">
                <div className="font-mono text-sm font-semibold text-accent">
                  {s.rankScore}
                </div>
                <div className="text-[10px] uppercase tracking-wide text-muted">
                  score
                </div>
              </div>
              {s.categories[0] && (
                <span className="hidden rounded-full border border-line px-2 py-0.5 text-[10px] text-muted md:inline">
                  {categoryLabel(s.categories[0])}
                </span>
              )}
            </Link>
          </li>
        ))}
      </ol>
    </div>
  );
}

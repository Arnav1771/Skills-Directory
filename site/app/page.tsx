import Link from "next/link";
import { ArrowRight, GitFork, Star, Sparkles } from "lucide-react";
import { getCatalog, getCategories, latestSkills, topSkills, categoryLabel } from "@/lib/skills";
import SkillCard from "@/components/SkillCard";
import FaqAccordion from "@/components/FaqAccordion";
import HomeSearch from "@/components/HomeSearch";

export default function Home() {
  const { repo, skills } = getCatalog();
  const categories = getCategories();
  const featured = skills.filter((s) => s.composesWell.length > 0);

  return (
    <div className="flex flex-col gap-14 py-12">
      <section className="mx-auto flex max-w-3xl flex-col items-center gap-6 text-center">
        <span className="inline-flex items-center gap-1.5 rounded-full border border-line bg-surface px-3 py-1 text-xs text-muted">
          <Sparkles size={12} className="text-accent" />
          {skills.length} skills · {categories.length} categories · open source
        </span>
        <h1 className="text-4xl font-bold tracking-tight sm:text-5xl">
          A curated directory of{" "}
          <span className="text-accent">agent skills</span>
        </h1>
        <p className="max-w-xl text-balance text-muted">
          Reusable capabilities you can drop into Claude Code, Claude.ai, or any AI
          coding agent — searchable, documented, and one <code className="font-mono text-sm">cp -r</code> away.
        </p>
        <HomeSearch />
        <div className="flex items-center gap-4 text-xs text-muted">
          <a
            href={repo.url}
            target="_blank"
            rel="noreferrer"
            className="inline-flex items-center gap-1 hover:text-foreground"
          >
            <Star size={12} /> {repo.stars} stars
          </a>
          <span className="inline-flex items-center gap-1">
            <GitFork size={12} /> {repo.forks} forks
          </span>
        </div>
      </section>

      {featured.length > 0 && (
        <Section title="Featured" href="/skills/" linkLabel="All skills">
          <Grid>{featured.map((s) => <SkillCard key={s.slug} skill={s} />)}</Grid>
        </Section>
      )}

      <Section title="Top skills" href="/leaderboard/" linkLabel="Leaderboard">
        <Grid>{topSkills(3).map((s) => <SkillCard key={s.slug} skill={s} />)}</Grid>
      </Section>

      <Section title="Latest updates" href="/skills/?sort=newest" linkLabel="Newest first">
        <Grid>{latestSkills(3).map((s) => <SkillCard key={s.slug} skill={s} />)}</Grid>
      </Section>

      <section>
        <h2 className="mb-4 text-lg font-semibold tracking-tight">Browse by category</h2>
        <div className="flex flex-wrap gap-2">
          {categories.map((c) => (
            <Link
              key={c.slug}
              href={`/categories/${c.slug}/`}
              className="rounded-full border border-line bg-surface px-4 py-1.5 text-sm text-muted transition-colors hover:border-accent hover:text-accent"
            >
              {categoryLabel(c.slug)}{" "}
              <span className="font-mono text-xs">({c.count})</span>
            </Link>
          ))}
        </div>
      </section>

      <section className="mx-auto w-full max-w-2xl">
        <h2 className="mb-4 text-center text-lg font-semibold tracking-tight">FAQ</h2>
        <FaqAccordion />
      </section>
    </div>
  );
}

function Section({
  title,
  href,
  linkLabel,
  children,
}: {
  title: string;
  href: string;
  linkLabel: string;
  children: React.ReactNode;
}) {
  return (
    <section>
      <div className="mb-4 flex items-center justify-between">
        <h2 className="text-lg font-semibold tracking-tight">{title}</h2>
        <Link
          href={href}
          className="inline-flex items-center gap-1 text-sm text-accent hover:underline underline-offset-2"
        >
          {linkLabel} <ArrowRight size={14} />
        </Link>
      </div>
      {children}
    </section>
  );
}

function Grid({ children }: { children: React.ReactNode }) {
  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">{children}</div>
  );
}

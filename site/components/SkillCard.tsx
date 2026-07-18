import Link from "next/link";
import type { Skill } from "@/lib/skills";
import { categoryLabel } from "@/lib/skills";
import SkillIcon from "./SkillIcon";

export default function SkillCard({ skill }: { skill: Skill }) {
  return (
    <Link
      href={`/skills/${skill.slug}/`}
      className="group flex flex-col gap-3 rounded-xl border border-line bg-surface p-5 transition-all hover:border-accent hover:shadow-lg hover:shadow-accent/5 hover:-translate-y-0.5"
    >
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-center gap-3">
          <span className="flex h-10 w-10 items-center justify-center rounded-lg bg-accent-soft text-accent">
            <SkillIcon name={skill.icon} className="h-5 w-5" />
          </span>
          <div>
            <h3 className="font-mono text-sm font-semibold group-hover:text-accent transition-colors">
              {skill.name}
            </h3>
            <span className="text-[11px] text-muted">v{skill.version}</span>
          </div>
        </div>
        {skill.categories[0] && (
          <span className="rounded-full border border-line px-2 py-0.5 text-[10px] uppercase tracking-wide text-muted whitespace-nowrap">
            {categoryLabel(skill.categories[0])}
          </span>
        )}
      </div>
      <p className="line-clamp-3 text-sm leading-relaxed text-muted">
        {skill.description}
      </p>
      <div className="mt-auto flex flex-wrap gap-1.5">
        {skill.tags.slice(0, 4).map((t) => (
          <span
            key={t}
            className="rounded-md bg-accent-soft px-2 py-0.5 font-mono text-[10px] text-accent"
          >
            {t}
          </span>
        ))}
        {skill.tags.length > 4 && (
          <span className="px-1 py-0.5 text-[10px] text-muted">
            +{skill.tags.length - 4}
          </span>
        )}
      </div>
    </Link>
  );
}

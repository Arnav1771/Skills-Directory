import type { Metadata } from "next";
import Link from "next/link";
import { FolderOpen } from "lucide-react";
import { getCategories, getSkillsByCategory, categoryLabel } from "@/lib/skills";

export const metadata: Metadata = {
  title: "Categories",
  description: "Browse agent skills grouped by category.",
};

export default function CategoriesPage() {
  const categories = getCategories();
  return (
    <div className="flex flex-col gap-6 py-10">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Categories</h1>
        <p className="mt-1 text-sm text-muted">
          Every category in the catalog, with the skills it contains.
        </p>
      </div>
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {categories.map((c) => {
          const skills = getSkillsByCategory(c.slug);
          return (
            <Link
              key={c.slug}
              href={`/categories/${c.slug}/`}
              className="group rounded-xl border border-line bg-surface p-5 transition-all hover:border-accent hover:-translate-y-0.5"
            >
              <div className="mb-2 flex items-center gap-2">
                <FolderOpen size={16} className="text-accent" />
                <h2 className="font-semibold group-hover:text-accent">
                  {categoryLabel(c.slug)}
                </h2>
                <span className="ml-auto font-mono text-xs text-muted">
                  {c.count}
                </span>
              </div>
              <p className="font-mono text-xs text-muted">
                {skills.map((s) => s.name).join(" · ")}
              </p>
            </Link>
          );
        })}
      </div>
    </div>
  );
}

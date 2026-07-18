"use client";

import { useMemo, useState, useEffect, Suspense } from "react";
import { useRouter, usePathname, useSearchParams } from "next/navigation";
import Fuse from "fuse.js";
import { Search, X } from "lucide-react";
import type { Skill } from "@/lib/skills";
import { categoryLabel } from "@/lib/skills";
import SkillCard from "./SkillCard";

type SortKey = "popular" | "newest" | "alphabetical";

function Browser({
  skills,
  lockedCategory,
  initialSort = "popular",
}: {
  skills: Skill[];
  lockedCategory?: string;
  initialSort?: SortKey;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();

  const [query, setQuery] = useState(params.get("q") ?? "");
  const [category, setCategory] = useState(params.get("category") ?? "");
  const [tags, setTags] = useState<string[]>(
    params.get("tags")?.split(",").filter(Boolean) ?? []
  );
  const [sort, setSort] = useState<SortKey>(
    (params.get("sort") as SortKey) || initialSort
  );

  // Reflect filter state in the URL so views are shareable.
  useEffect(() => {
    const p = new URLSearchParams();
    if (query) p.set("q", query);
    if (category && !lockedCategory) p.set("category", category);
    if (tags.length) p.set("tags", tags.join(","));
    if (sort !== initialSort) p.set("sort", sort);
    const qs = p.toString();
    window.history.replaceState(null, "", qs ? `${pathname}?${qs}` : pathname);
  }, [query, category, tags, sort, pathname, initialSort, lockedCategory]);

  const fuse = useMemo(
    () =>
      new Fuse(skills, {
        keys: ["name", "description", "tags"],
        threshold: 0.35,
        ignoreLocation: true,
      }),
    [skills]
  );

  const allCategories = useMemo(
    () => [...new Set(skills.flatMap((s) => s.categories))].sort(),
    [skills]
  );
  const allTags = useMemo(
    () => [...new Set(skills.flatMap((s) => s.tags))].sort(),
    [skills]
  );

  const results = useMemo(() => {
    let list = query ? fuse.search(query).map((r) => r.item) : [...skills];
    const cat = lockedCategory ?? category;
    if (cat) list = list.filter((s) => s.categories.includes(cat));
    if (tags.length)
      list = list.filter((s) => tags.every((t) => s.tags.includes(t)));
    if (!query) {
      if (sort === "popular") list.sort((a, b) => b.rankScore - a.rankScore);
      if (sort === "newest")
        list.sort((a, b) =>
          (b.lastUpdated ?? "").localeCompare(a.lastUpdated ?? "")
        );
      if (sort === "alphabetical")
        list.sort((a, b) => a.name.localeCompare(b.name));
    }
    return list;
  }, [skills, fuse, query, category, tags, sort, lockedCategory]);

  function toggleTag(t: string) {
    setTags((prev) =>
      prev.includes(t) ? prev.filter((x) => x !== t) : [...prev, t]
    );
  }

  return (
    <div className="flex flex-col gap-5">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <label className="relative flex-1">
          <Search
            size={16}
            className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-muted"
          />
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search skills by name, description, or tag…"
            className="w-full rounded-xl border border-line bg-surface py-2.5 pl-9 pr-9 text-sm outline-none placeholder:text-muted focus:border-accent"
          />
          {query && (
            <button
              onClick={() => setQuery("")}
              aria-label="Clear search"
              className="absolute right-3 top-1/2 -translate-y-1/2 text-muted hover:text-foreground"
            >
              <X size={14} />
            </button>
          )}
        </label>
        <select
          value={sort}
          onChange={(e) => setSort(e.target.value as SortKey)}
          aria-label="Sort skills"
          className="rounded-xl border border-line bg-surface px-3 py-2.5 text-sm text-muted outline-none focus:border-accent"
        >
          <option value="popular">Most popular</option>
          <option value="newest">Newest</option>
          <option value="alphabetical">A–Z</option>
        </select>
      </div>

      {!lockedCategory && (
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => setCategory("")}
            className={`rounded-full border px-3 py-1 text-xs transition-colors ${
              category === ""
                ? "border-accent bg-accent-soft text-accent"
                : "border-line text-muted hover:border-accent"
            }`}
          >
            All
          </button>
          {allCategories.map((c) => (
            <button
              key={c}
              onClick={() => setCategory(category === c ? "" : c)}
              className={`rounded-full border px-3 py-1 text-xs transition-colors ${
                category === c
                  ? "border-accent bg-accent-soft text-accent"
                  : "border-line text-muted hover:border-accent"
              }`}
            >
              {categoryLabel(c)}
            </button>
          ))}
        </div>
      )}

      <div className="flex flex-wrap gap-1.5">
        {allTags.map((t) => (
          <button
            key={t}
            onClick={() => toggleTag(t)}
            className={`rounded-md px-2 py-0.5 font-mono text-[11px] transition-colors ${
              tags.includes(t)
                ? "bg-accent text-background"
                : "bg-accent-soft text-accent hover:opacity-80"
            }`}
          >
            {t}
          </button>
        ))}
      </div>

      <p className="text-xs text-muted">
        {results.length} skill{results.length === 1 ? "" : "s"}
      </p>

      {results.length ? (
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {results.map((s) => (
            <SkillCard key={s.slug} skill={s} />
          ))}
        </div>
      ) : (
        <div className="rounded-xl border border-dashed border-line p-10 text-center text-sm text-muted">
          No skills match. Try clearing a filter, or{" "}
          <button
            onClick={() => router.push("/submit/")}
            className="text-accent underline underline-offset-2"
          >
            add one to the directory
          </button>
          .
        </div>
      )}
    </div>
  );
}

export default function SkillBrowser(props: {
  skills: Skill[];
  lockedCategory?: string;
  initialSort?: SortKey;
}) {
  // useSearchParams requires a Suspense boundary under static export.
  return (
    <Suspense>
      <Browser {...props} />
    </Suspense>
  );
}

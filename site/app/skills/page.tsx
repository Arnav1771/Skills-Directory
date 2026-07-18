import type { Metadata } from "next";
import { getSkills } from "@/lib/skills";
import SkillBrowser from "@/components/SkillBrowser";

export const metadata: Metadata = {
  title: "All skills",
  description:
    "Browse every agent skill in the directory — filter by category and tag, sort by popularity, recency, or name.",
};

export default function SkillsPage() {
  return (
    <div className="flex flex-col gap-6 py-10">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">All skills</h1>
        <p className="mt-1 text-sm text-muted">
          Filter by category or tag; combine freely. Filters live in the URL, so
          views are shareable.
        </p>
      </div>
      <SkillBrowser skills={getSkills()} />
    </div>
  );
}

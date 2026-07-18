import type { Metadata } from "next";
import { getSkills } from "@/lib/skills";
import SkillBrowser from "@/components/SkillBrowser";

export const metadata: Metadata = {
  title: "Search",
  description: "Live fuzzy search across every skill's name, description, and tags.",
};

export default function SearchPage() {
  return (
    <div className="flex flex-col gap-6 py-10">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Search</h1>
        <p className="mt-1 text-sm text-muted">
          Instant fuzzy search over names, descriptions, and tags — no page reload.
        </p>
      </div>
      <SkillBrowser skills={getSkills()} initialSort="alphabetical" />
    </div>
  );
}

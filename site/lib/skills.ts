import data from "@/content/skills.json";

export interface Skill {
  slug: string;
  name: string;
  description: string;
  categories: string[];
  tags: string[];
  icon: string;
  version: string;
  composesWell: string[];
  hasManifest: boolean;
  triggerDescription: string;
  bodyHtml: string;
  folderPath: string;
  githubUrl: string;
  installCommand: string;
  lastUpdated: string | null;
  hasScripts: boolean;
  hasReferences: boolean;
  hasExamples: boolean;
  diagrams: string[];
  rankScore: number;
}

export interface Catalog {
  generatedAt: string;
  repo: {
    slug: string;
    url: string;
    stars: number;
    forks: number;
    openIssues: number;
    pushedAt: string | null;
  };
  categories: Record<string, number>;
  skills: Skill[];
}

const catalog = data as Catalog;

export function getCatalog(): Catalog {
  return catalog;
}

export function getSkills(): Skill[] {
  return catalog.skills;
}

export function getSkill(slug: string): Skill | undefined {
  return catalog.skills.find((s) => s.slug === slug);
}

export function getCategories(): { slug: string; count: number }[] {
  return Object.entries(catalog.categories)
    .map(([slug, count]) => ({ slug, count }))
    .sort((a, b) => b.count - a.count || a.slug.localeCompare(b.slug));
}

export function getSkillsByCategory(category: string): Skill[] {
  return catalog.skills.filter((s) => s.categories.includes(category));
}

export function topSkills(n?: number): Skill[] {
  const sorted = [...catalog.skills].sort((a, b) => b.rankScore - a.rankScore);
  return n ? sorted.slice(0, n) : sorted;
}

export function latestSkills(n?: number): Skill[] {
  const sorted = [...catalog.skills].sort((a, b) =>
    (b.lastUpdated ?? "").localeCompare(a.lastUpdated ?? "")
  );
  return n ? sorted.slice(0, n) : sorted;
}

export function categoryLabel(slug: string): string {
  return slug
    .split("-")
    .map((w) => w[0].toUpperCase() + w.slice(1))
    .join(" ");
}

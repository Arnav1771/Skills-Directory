import type { MetadataRoute } from "next";
import { getCategories, getSkills } from "@/lib/skills";

export const dynamic = "force-static";

const BASE = "https://arnav1771.github.io/Skills-Directory";

export default function sitemap(): MetadataRoute.Sitemap {
  const staticRoutes = [
    "",
    "/skills",
    "/categories",
    "/leaderboard",
    "/search",
    "/submit",
    "/what-is-an-agent-skill",
  ].map((p) => ({ url: `${BASE}${p}/`, lastModified: new Date() }));

  const skillRoutes = getSkills().map((s) => ({
    url: `${BASE}/skills/${s.slug}/`,
    lastModified: s.lastUpdated ? new Date(s.lastUpdated) : new Date(),
  }));

  const categoryRoutes = getCategories().map((c) => ({
    url: `${BASE}/categories/${c.slug}/`,
    lastModified: new Date(),
  }));

  return [...staticRoutes, ...skillRoutes, ...categoryRoutes];
}

// Build-time content pipeline for the Skills-Directory site.
// Walks each top-level skill folder in the repo root (one level above site/),
// parses manifest.yaml (optional) and SKILL.md (frontmatter + body),
// renders the body to HTML, augments with repo metadata from the GitHub API,
// and emits content/skills.json consumed by the app's static generation.
//
// Run: node scripts/build-content.mjs   (wired as the `prebuild` npm script)

import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";
import matter from "gray-matter";
import { parse as parseYaml } from "yaml";
import { marked } from "marked";

const REPO_ROOT = path.resolve(process.cwd(), "..");
const OUT_DIR = path.resolve(process.cwd(), "content");
const REPO_SLUG = "Arnav1771/Skills-Directory";
const REPO_URL = `https://github.com/${REPO_SLUG}`;

const IGNORED_DIRS = new Set(["site", "IMP Docs", "node_modules", ".git", ".github"]);

function isSkillDir(dir) {
  return fs.existsSync(path.join(REPO_ROOT, dir, "SKILL.md"));
}

function lastCommitISO(relPath) {
  try {
    const out = execSync(`git log -1 --format=%cI -- "${relPath}"`, {
      cwd: REPO_ROOT,
      encoding: "utf8",
    }).trim();
    return out || null;
  } catch {
    return null;
  }
}

async function fetchRepoMeta() {
  const headers = { Accept: "application/vnd.github+json" };
  if (process.env.GITHUB_TOKEN) headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
  try {
    const res = await fetch(`https://api.github.com/repos/${REPO_SLUG}`, { headers });
    if (!res.ok) throw new Error(`GitHub API ${res.status}`);
    const j = await res.json();
    return {
      stars: j.stargazers_count ?? 0,
      forks: j.forks_count ?? 0,
      openIssues: j.open_issues_count ?? 0,
      pushedAt: j.pushed_at ?? null,
    };
  } catch (e) {
    console.warn(`[content] GitHub API unavailable (${e.message}) — using zeros`);
    return { stars: 0, forks: 0, openIssues: 0, pushedAt: null };
  }
}

function stripFrontmatterAndRender(skillMdRaw) {
  const { data, content } = matter(skillMdRaw);
  marked.setOptions({ gfm: true });
  const html = marked.parse(content);
  return { frontmatter: data, bodyHtml: html, bodyMd: content };
}

const dirs = fs
  .readdirSync(REPO_ROOT, { withFileTypes: true })
  .filter((d) => d.isDirectory() && !IGNORED_DIRS.has(d.name) && !d.name.startsWith("."))
  .map((d) => d.name)
  .filter(isSkillDir)
  .sort();

const repoMeta = await fetchRepoMeta();

const skills = dirs.map((dir) => {
  const skillMdPath = path.join(REPO_ROOT, dir, "SKILL.md");
  const manifestPath = path.join(REPO_ROOT, dir, "manifest.yaml");

  const { frontmatter, bodyHtml } = stripFrontmatterAndRender(
    fs.readFileSync(skillMdPath, "utf8")
  );

  // manifest.yaml is optional — fall back to SKILL.md frontmatter.
  let manifest = {};
  if (fs.existsSync(manifestPath)) {
    try {
      manifest = parseYaml(fs.readFileSync(manifestPath, "utf8")) ?? {};
    } catch (e) {
      console.warn(`[content] ${dir}/manifest.yaml failed to parse: ${e.message}`);
    }
  }

  const entries = fs.readdirSync(path.join(REPO_ROOT, dir), { withFileTypes: true });
  const hasScripts = entries.some((e) => e.isDirectory() && e.name === "scripts");
  const hasReferences = entries.some((e) => e.isDirectory() && e.name === "references");
  const hasExamples = entries.some((e) => e.isDirectory() && e.name === "examples");
  const diagrams = entries
    .filter((e) => e.isFile() && e.name.endsWith(".svg"))
    .map((e) => e.name);

  const name = manifest.name ?? frontmatter.name ?? dir;
  return {
    slug: dir,
    name,
    description: manifest.description ?? frontmatter.description ?? "",
    categories: manifest.categories ?? [],
    tags: manifest.tags ?? [],
    icon: manifest.icon ?? "Puzzle",
    version: String(manifest.version ?? "0.0.0"),
    composesWell: manifest.composesWell ?? [],
    hasManifest: fs.existsSync(manifestPath),
    triggerDescription: frontmatter.description ?? "",
    bodyHtml,
    folderPath: dir,
    githubUrl: `${REPO_URL}/tree/main/${dir}`,
    installCommand: `cp -r Skills-Directory/${dir} ~/.claude/skills/${dir}`,
    lastUpdated: lastCommitISO(dir),
    hasScripts,
    hasReferences,
    hasExamples,
    diagrams,
  };
});

// Rank: all skills live in one repo, so per-skill stars don't exist. Weight =
// how connected + mature a skill is; repo stars break ties globally.
for (const s of skills) {
  const inbound = skills.filter((o) => o.composesWell.includes(s.name)).length;
  const [major, minor] = s.version.split(".").map((n) => parseInt(n, 10) || 0);
  s.rankScore =
    inbound * 3 +
    s.composesWell.length * 2 +
    major * 2 +
    minor +
    (s.hasScripts ? 1 : 0) +
    (s.hasReferences ? 1 : 0) +
    (s.diagrams.length > 0 ? 1 : 0);
}

const categories = {};
for (const s of skills) {
  for (const c of s.categories) {
    categories[c] = (categories[c] ?? 0) + 1;
  }
}

const payload = {
  generatedAt: new Date().toISOString(),
  repo: { slug: REPO_SLUG, url: REPO_URL, ...repoMeta },
  categories,
  skills,
};

fs.mkdirSync(OUT_DIR, { recursive: true });
fs.writeFileSync(path.join(OUT_DIR, "skills.json"), JSON.stringify(payload, null, 2));
console.log(
  `[content] wrote content/skills.json — ${skills.length} skills, ${Object.keys(categories).length} categories, ${repoMeta.stars}★`
);

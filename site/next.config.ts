import type { NextConfig } from "next";

// This site static-exports to site/out.
//
// On GitHub Pages it is served from a PROJECT sub-path
// (https://arnav1771.github.io/Skills-Directory/), so every asset URL has to be
// prefixed with /Skills-Directory. But when you serve site/out directly as the
// document root — which is what anyone cloning this repo will do — that prefix
// makes every /_next/... asset 404: no CSS, no JS, nothing interactive.
//
// So the prefix is opt-in. `npm run build` emits root-relative URLs that work
// from any document root; `npm run build:pages` (used by CI and by
// scripts/deploy-ghpages.sh) sets NEXT_PUBLIC_BASE_PATH and emits the
// Pages-flavoured build. GITHUB_ACTIONS is honoured as a fallback so a Pages
// deploy workflow can't silently ship a root-relative build.
const rawBasePath =
  process.env.NEXT_PUBLIC_BASE_PATH ??
  (process.env.GITHUB_ACTIONS === "true" ? "/Skills-Directory" : "");

// Normalise to "" or "/segment" (leading slash, no trailing slash).
const basePath = rawBasePath === "/" ? "" : rawBasePath.replace(/\/+$/, "");

const nextConfig: NextConfig = {
  output: "export",
  ...(basePath ? { basePath, assetPrefix: basePath } : {}),
  trailingSlash: true,
  images: { unoptimized: true },
};

export default nextConfig;

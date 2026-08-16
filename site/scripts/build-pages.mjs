// Build the GitHub Pages flavour of the static export.
//
// Identical to `npm run build`, except NEXT_PUBLIC_BASE_PATH is set so
// next.config.ts emits /Skills-Directory-prefixed asset URLs. Written as a node
// script rather than an inline `VAR=x next build` so it works on every shell.
import { execSync } from "node:child_process";

const basePath = process.env.NEXT_PUBLIC_BASE_PATH || "/Skills-Directory";

console.log(`[build:pages] NEXT_PUBLIC_BASE_PATH=${basePath}`);

execSync("npm run build", {
  stdio: "inherit",
  env: { ...process.env, NEXT_PUBLIC_BASE_PATH: basePath },
});

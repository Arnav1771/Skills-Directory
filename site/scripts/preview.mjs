// Zero-dependency static file server for the exported site in site/out.
//
//   npm run preview                      -> serves out/ at http://127.0.0.1:8123/
//   npm run preview -- --base-path=/Skills-Directory
//                                        -> serves out/ at .../Skills-Directory/,
//                                           i.e. exactly how GitHub Pages serves it
//   npm run preview -- --port=9000
//
// The --base-path form is what you want after `npm run build:pages`.
import { createServer } from "node:http";
import { readFile, stat } from "node:fs/promises";
import { join, extname, resolve, sep } from "node:path";

const args = process.argv.slice(2);
const argOf = (name, fallback) => {
  const hit = args.find((a) => a.startsWith(`--${name}=`));
  return hit ? hit.slice(name.length + 3) : fallback;
};

const port = Number(argOf("port", process.env.PORT || 8123));
const root = resolve(argOf("dir", "out"));
const rawBase = argOf("base-path", process.env.NEXT_PUBLIC_BASE_PATH || "");
const base = rawBase === "/" ? "" : rawBase.replace(/\/+$/, "");

const TYPES = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".ico": "image/x-icon",
  ".webp": "image/webp",
  ".woff": "font/woff",
  ".woff2": "font/woff2",
  ".txt": "text/plain; charset=utf-8",
  ".xml": "application/xml; charset=utf-8",
};

async function resolveFile(urlPath) {
  // Strip the base path; anything outside it is a 404.
  if (base) {
    if (urlPath === base) return join(root, "index.html");
    if (!urlPath.startsWith(`${base}/`)) return null;
    urlPath = urlPath.slice(base.length);
  }

  const decoded = decodeURIComponent(urlPath);
  // Contain the path inside root (no ../ escapes).
  const target = resolve(join(root, decoded));
  if (target !== root && !target.startsWith(root + sep)) return null;

  try {
    const s = await stat(target);
    if (s.isDirectory()) return join(target, "index.html");
    return target;
  } catch {
    // trailingSlash: true means /skills/ -> out/skills/index.html; also allow
    // /skills -> out/skills.html for good measure.
    for (const candidate of [`${target}.html`, join(target, "index.html")]) {
      try {
        await stat(candidate);
        return candidate;
      } catch {
        /* keep looking */
      }
    }
    return null;
  }
}

const server = createServer(async (req, res) => {
  const urlPath = new URL(req.url, "http://localhost").pathname;
  const file = await resolveFile(urlPath);

  if (!file) {
    res.writeHead(404, { "content-type": "text/plain; charset=utf-8" });
    res.end(`404 ${urlPath}`);
    return;
  }

  try {
    const body = await readFile(file);
    res.writeHead(200, {
      "content-type": TYPES[extname(file)] || "application/octet-stream",
      "content-length": body.length,
      "cache-control": "no-store",
    });
    res.end(body);
  } catch {
    res.writeHead(404, { "content-type": "text/plain; charset=utf-8" });
    res.end(`404 ${urlPath}`);
  }
});

server.listen(port, "127.0.0.1", () => {
  console.log(`Serving ${root} at http://127.0.0.1:${port}${base}/`);
});

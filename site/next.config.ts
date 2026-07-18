import type { NextConfig } from "next";

// Static export for GitHub Pages at https://arnav1771.github.io/Skills-Directory/
const nextConfig: NextConfig = {
  output: "export",
  basePath: "/Skills-Directory",
  trailingSlash: true,
  images: { unoptimized: true },
};

export default nextConfig;

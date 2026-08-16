import Link from "next/link";
import { BookOpen } from "lucide-react";
import ThemeToggle from "./ThemeToggle";

const NAV = [
  { href: "/skills/", label: "Skills" },
  { href: "/categories/", label: "Categories" },
  { href: "/leaderboard/", label: "Leaderboard" },
  { href: "/search/", label: "Search" },
  { href: "/submit/", label: "Submit" },
];

function GitHubMark() {
  return (
    <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor" aria-hidden>
      <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27s1.36.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8Z" />
    </svg>
  );
}

export default function SiteHeader() {
  return (
    <header className="sticky top-0 z-40 border-b border-line bg-background/85 backdrop-blur">
      <div className="mx-auto flex h-14 max-w-6xl items-center justify-between gap-4 px-4">
        <Link href="/" className="flex items-center gap-2 font-semibold tracking-tight">
          <span className="flex h-7 w-7 items-center justify-center rounded-md bg-accent-soft text-accent">
            <BookOpen size={15} />
          </span>
          <span className="font-mono text-sm">Skills-Directory</span>
        </Link>
        <nav className="hidden items-center gap-5 text-sm text-muted sm:flex">
          {NAV.map((n) => (
            <Link key={n.href} href={n.href} className="hover:text-foreground transition-colors">
              {n.label}
            </Link>
          ))}
        </nav>
        <div className="flex items-center gap-2">
          <a
            href="https://github.com/Arnav1771/Skills-Directory"
            target="_blank"
            rel="noreferrer"
            aria-label="GitHub repository"
            className="rounded-lg border border-line p-2 text-muted hover:text-foreground hover:border-accent transition-colors"
          >
            <GitHubMark />
          </a>
          <ThemeToggle />
        </div>
      </div>
      <nav className="flex items-center gap-4 overflow-x-auto border-t border-line px-4 py-2 text-sm text-muted sm:hidden">
        {NAV.map((n) => (
          <Link key={n.href} href={n.href} className="whitespace-nowrap hover:text-foreground">
            {n.label}
          </Link>
        ))}
      </nav>
    </header>
  );
}

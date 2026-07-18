import Link from "next/link";

export default function SiteFooter() {
  return (
    <footer className="mt-16 border-t border-line py-8 text-sm text-muted">
      <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-3 px-4 sm:flex-row">
        <p>
          <span className="font-mono">Skills-Directory</span> — a curated catalog of agent
          skills.
        </p>
        <div className="flex gap-5">
          <Link href="/what-is-an-agent-skill/" className="hover:text-foreground">
            What is an Agent Skill?
          </Link>
          <Link href="/submit/" className="hover:text-foreground">
            Add a skill
          </Link>
          <a
            href="https://github.com/Arnav1771/Skills-Directory"
            target="_blank"
            rel="noreferrer"
            className="hover:text-foreground"
          >
            GitHub
          </a>
        </div>
      </div>
    </footer>
  );
}

"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { Search } from "lucide-react";

export default function HomeSearch() {
  const router = useRouter();
  const [q, setQ] = useState("");

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        router.push(q ? `/search/?q=${encodeURIComponent(q)}` : "/search/");
      }}
      className="relative w-full max-w-md"
    >
      <Search
        size={16}
        className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-muted"
      />
      <input
        value={q}
        onChange={(e) => setQ(e.target.value)}
        placeholder="Search skills…"
        className="w-full rounded-full border border-line bg-surface py-3 pl-11 pr-4 text-sm shadow-sm outline-none placeholder:text-muted focus:border-accent"
      />
    </form>
  );
}

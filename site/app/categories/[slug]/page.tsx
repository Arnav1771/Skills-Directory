import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getCategories, getSkillsByCategory, categoryLabel } from "@/lib/skills";
import SkillBrowser from "@/components/SkillBrowser";

export function generateStaticParams() {
  return getCategories().map((c) => ({ slug: c.slug }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  return {
    title: `${categoryLabel(slug)} skills`,
    description: `Agent skills in the ${categoryLabel(slug)} category.`,
  };
}

export default async function CategoryPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const skills = getSkillsByCategory(slug);
  if (!skills.length) notFound();

  return (
    <div className="flex flex-col gap-6 py-10">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">
          {categoryLabel(slug)}
        </h1>
        <p className="mt-1 text-sm text-muted">
          {skills.length} skill{skills.length === 1 ? "" : "s"} in this category.
        </p>
      </div>
      <SkillBrowser skills={skills} lockedCategory={slug} />
    </div>
  );
}

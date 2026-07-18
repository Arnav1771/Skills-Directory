import {
  Skull,
  Languages,
  Wand2,
  Rocket,
  ClipboardList,
  Puzzle,
  type LucideIcon,
} from "lucide-react";

// Icons named in manifest.yaml files map here; unknown names fall back to Puzzle.
const ICONS: Record<string, LucideIcon> = {
  Skull,
  Languages,
  Wand2,
  Rocket,
  ClipboardList,
  Puzzle,
};

export default function SkillIcon({
  name,
  className,
}: {
  name: string;
  className?: string;
}) {
  const Icon = ICONS[name] ?? Puzzle;
  return <Icon className={className} aria-hidden />;
}

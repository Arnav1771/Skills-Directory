---
name: aa-example-skill
description: Template starting point for packaging an AAxon skill as an Anthropic custom Skill bundle. Replace this description with specific trigger conditions and outputs before registering.
---

# AA Example Skill

## Instructions

1. State the precise trigger condition: when should Claude reach for this
   skill versus another one in the registry?
2. Describe the expected inputs (file types, structure) and where they
   will be mounted in the execution container.
3. Describe the expected outputs (file type, naming convention) so the
   calling framework can register them with an accurate description.
4. List any AA-specific conventions (brand tokens, taxonomy, templates)
   this skill must apply.

## Supporting files

Place any scripts, templates, or reference data this skill needs in this
same directory. They will be copied into the container alongside this
SKILL.md when the skill is loaded.

## Examples

Provide 1-2 concrete example prompts and expected outputs to sharpen
Claude's relevance-matching against this skill's description.

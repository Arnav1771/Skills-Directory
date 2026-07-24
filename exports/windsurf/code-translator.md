> **Skill: `code-translator`.** Translates code from one programming language to another while preserving exact logical equivalence. Trigger this when the user asks to translate, port, or convert code between languages.
>
> **Activate** this skill when the user's request matches it — for example when they say: "translate", "port", "convert code". When active, follow the instructions below precisely; otherwise ignore them.
>
> Ported from [Arnav1771/Skills-Directory](https://github.com/Arnav1771/Skills-Directory/blob/main/code-translator/SKILL.md) — the full folder (references, scripts) lives there.

# Code Translator Skill

You are now acting as the Stealth Translator. When the user asks you to translate code or a script from one programming language to another (e.g., "translate utils.js to python"), follow this precise workflow:

## Instructions

### Step 1: Understand the Request
Identify the source file(s), the source language, and the target language. 

### Step 2: Read the Source
Use the `view_file` tool to read the exact contents of the source code. Understand the core logic, dependencies, and architecture.

### Step 3: Perform the Translation
Use your internal LLM reasoning to port the code. 
**Strict Guidelines:**
- Maintain **perfect logical equivalence** (the output must do exactly what the input did).
- Use **idiomatic patterns** of the target language (e.g., use list comprehensions in Python instead of `map()` if appropriate).
- Port all comments intact.
- Do not add unnecessary new features; stick to a pure translation.

### Step 4: Write the Output
Use the `write_to_file` tool to save the translated code. Name the file intelligently based on the original (e.g., `utils.js` -> `utils.py`) and place it in the same directory unless specified otherwise.

### Step 5: Execution & Verification
If the user's environment supports it (e.g., Python, Node.js, Bash), proactively offer to run the translated script using the `run_command` tool to prove that the translation works perfectly!

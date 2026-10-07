---
name: repomix
description: Tool for packing entire codebases, directories, or Wiki folders into a single, clean AI-optimized file (XML/Markdown) with directory tree, token counts, and security scanning. Use when any agent needs to bundle multiple files or an entire project to pass context to an LLM.
---

# Repomix Skill

Repomix (formerly Repopack) is installed globally (`repomix --version: 1.18.1`). It packs an entire directory into a single, structured file optimized for LLMs.

## Quick Usage

Pack current directory to default `repomix-output.xml`:
```bash
repomix
```

Pack a specific directory:
```bash
repomix "C:\Project\database-system"
```

Output format options:
```bash
# Markdown format
repomix --style markdown -o output.md

# XML format (best for Claude / Gemini prompt caching)
repomix --style xml -o output.xml

# Plain text
repomix --style plain -o output.txt
```

Ignore files or folders:
```bash
repomix --ignore "node_modules/**,dist/**,*.tmp,*.log"
```

Only include specific patterns (e.g. only markdown files for Wiki packing):
```bash
repomix --include "wiki/**/*.md,*.md" -o wiki-summary.xml
```

Inspect token count without writing output:
```bash
repomix --dry-run
```

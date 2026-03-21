---
description: Apply source code documentation standards for file-level docs, class-level docs, and inline comments
allowed-tools: Read, Edit, Write, Grep, Glob
---

Apply these documentation standards when writing or modifying source code files.

## File/Class-Level Documentation (Required)

Include at the top of files or class definitions:
- **Purpose and responsibility** of the file/class
- **Key architectural decisions** or patterns used
- **Non-obvious design constraints** or trade-offs

## Inline Comments (Required Throughout)

Use inline comments to explain:
- Complex logic or algorithms
- Non-obvious implementation choices
- Business rules or domain-specific requirements
- Workarounds or edge case handling

## What NOT to Document In-File

- **No historical context**: Do not write "used to be", "previously", "migrated from" — document current state only
- **No generic tool explanations**: Assume familiarity with standard tools (Docker, git, pytest, Flask, etc.)
- **No code duplication in docs**: Reference file paths rather than quoting code in CLAUDE.md files

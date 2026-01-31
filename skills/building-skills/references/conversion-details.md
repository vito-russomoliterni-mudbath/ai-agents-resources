# Conversion Details

This document provides detailed instructions and logic for converting various AI assistant workflows into Claude skills.

## Extracting the Workflow Pattern

The first step is to identify the underlying repeatable workflow from a conversational interaction or prompt:
1. **Identify the Task**: What specific outcome is the workflow trying to achieve?
2. **Deconstruct Steps**: Break down the interaction into discrete, imperative steps.
3. **Identify Triggers**: Determine when this workflow should be automatically suggested.
4. **Isolate Reusable Components**: Look for code snippets that should be scripts, or constants that should be assets.

## Source Tool Detection

Detect the source tool to apply specific conversion logic:
- **Claude Code**: Presence of `.claude/` or `CLAUDE.md`. Uses `SKILL.md` or `AGENT.md`.
- **Cursor**: Presence of `.cursorrules` or `cursor.yaml`. Often heavily reliant on specific file context.
- **Windsurf**: Presence of `.windsurf/` or `@` mentions.
- **Aider**: Usage of `aider` tags or chat history patterns.

## Packaging for Distribution

A complete skill should be structured as follows:
```
skill-name/
├── SKILL.md
├── scripts/
├── references/
└── assets/
```
To share, the directory can be zipped with a `.skill` extension.

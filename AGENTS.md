# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Collection of reusable Claude Code skills for software development workflows. Each skill is a structured workflow that guides Claude through tasks like bug fixes, feature implementation, refactoring, and testing.

## Repository Structure

```text
skills/
|-- grill-me/                        # Relentless interview-style plan stress-testing
|-- orchestrator/                    # Dispatching opencode subagents for research, edits, review
`-- showlinks/                       # Web research — finding official docs and sources
archive/                             # Retired skills (not auto-installed)
subagents/
|-- researcher.md                    # Read-only codebase exploration
|-- editor.md                        # Precise, scoped file edits
`-- reviewer.md                      # Diff review, reports issues
```

## Working with Skills

Each skill directory contains:
- `SKILL.md` - Main workflow with YAML frontmatter
- `assets/` - Templates and checklists
- `references/` - Detailed guidance documents
- `scripts/` - Helper scripts (if needed)

## Project Commands

### Installation Script
Install/update skills to local Claude home (`~\.claude\skills\`):

```powershell
# Interactive installation (prompts for each skill)
.\install-skills.ps1

# Automatic installation (no prompts)
.\install-skills.ps1 -y

# Dry-run (preview without changes)
.\install-skills.ps1 -DryRun

# Verbose mode (detailed output)
.\install-skills.ps1 -v

# Combined flags
.\install-skills.ps1 -v -y          # Verbose automatic
.\install-skills.ps1 -v -DryRun     # Verbose preview
```

See [INSTALL.md](INSTALL.md) for detailed installation documentation.

## Development Guidelines

### Creating/Modifying Skills
- Follow the standard structure: `SKILL.md`, `assets/`, `references/`, `scripts/`
- Use YAML frontmatter in `SKILL.md`
- Keep workflows phase-based (Discovery -> Implementation -> Validation)
- Move detailed guidance to `references/` files
- Provide templates in `assets/` when helpful

### Documentation
- `README.md` - User-facing documentation
- `INSTALL.md` - Installation guide
- `CHANGELOG.md` - Version history
- `.claude/` - Linked guidance files (progressive disclosure)

### PowerShell Scripts
- Use `.ps1` extension
- Include comment-based help (`<# .SYNOPSIS ... #>`)
- Support `-help` flag
- Validate parameters with clear error messages
- Use `-ExecutionPolicy Bypass` for testing

## Guidelines

- [Skill Architecture](.claude/skill-architecture.md) - How skills are structured
- [Skill Patterns](.claude/skill-patterns.md) - Common patterns and workflows
- [Skill Development](.claude/skill-development.md) - Creating/modifying skills
- [Skill Reference](.claude/skill-reference.md) - Quick reference for each skill
- [Showlinks](skills/showlinks/SKILL.md) - Web research and official documentation lookup


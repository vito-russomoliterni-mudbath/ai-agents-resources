---
name: agent-md-refactor
description: This skill should be used when the user asks to "refactor my AGENTS.md", "refactor my CLAUDE.md", "split my agent instructions", "organize agent config", or "my instructions file is too long". It refactors bloated agent instruction files using progressive disclosure principles.
version: 1.0.0
license: MIT
---

# Agent MD Refactor

Refactor bloated agent instruction files (AGENTS.md, CLAUDE.md, COPILOT.md, etc.) to follow **progressive disclosure principles** - keeping essentials at root and organizing the rest into linked, categorized files.

## Overview

Large agent instruction files waste context tokens and make maintenance difficult. This skill reorganizes them into:
- **Root file**: Minimal essentials that apply to every task (< 50 lines)
- **Linked files**: Categorized, detailed instructions loaded only when relevant

Benefits:
- Reduced token usage
- Easier maintenance
- Better organization
- Clear hierarchy

## Quick Reference

| Phase | Action | Output |
|-------|--------|--------|
| 1. Analyze | Find contradictions | List of conflicts to resolve |
| 2. Extract | Identify essentials | Core instructions for root file |
| 3. Categorize | Group remaining instructions | Logical categories |
| 4. Structure | Create file hierarchy | Root + linked files |
| 5. Prune | Flag for deletion | Redundant/vague instructions |

## Process

### Phase 1: Find Contradictions

Identify instructions that conflict with each other.

**Look for:**
- Contradictory style guidelines (e.g., "use semicolons" vs "no semicolons")
- Conflicting workflow instructions
- Incompatible tool preferences
- Mutually exclusive patterns

**For each contradiction:**
Ask the user to resolve before proceeding. Present:
- Instruction A (quote)
- Instruction B (quote)
- Question about which should take precedence

See [Phase 1: Contradiction Detection](references/phase-1-contradictions.md) for detailed guidance.

### Phase 2: Identify the Essentials

Extract ONLY what belongs in the root file. The root should be minimal - information that applies to **every single task**.

**Essential content (keep in root):**
- Project description (one sentence)
- Package manager (only if not npm)
- Non-standard commands (custom build/test/typecheck)
- Critical overrides (things that MUST override defaults)
- Universal rules (applies to 100% of tasks)

**NOT essential (move to linked files):**
- Language-specific conventions
- Testing guidelines
- Code style details
- Framework patterns
- Documentation standards
- Git workflow details

See [Phase 2: Essential vs Linked](references/phase-2-essentials.md) for decision criteria.

### Phase 3: Group the Rest

Organize remaining instructions into logical categories (3-8 files).

**Common categories:**
- `typescript.md` - TS conventions, type patterns, strict mode rules
- `testing.md` - Test frameworks, coverage, mocking patterns
- `code-style.md` - Formatting, naming, comments, structure
- `git-workflow.md` - Commits, branches, PRs, reviews
- `architecture.md` - Patterns, folder structure, dependencies
- `api-design.md` - REST/GraphQL conventions, error handling
- `security.md` - Auth patterns, input validation, secrets
- `performance.md` - Optimization rules, caching, lazy loading

**Grouping rules:**
1. Each file should be self-contained for its topic
2. Aim for 3-8 files (not too granular, not too broad)
3. Name files clearly: `{topic}.md`
4. Include only actionable instructions

See [Phase 3: Categorization Patterns](references/phase-3-categorization.md) for category templates.

### Phase 4: Create the File Structure

**Output structure:**
```
project-root/
├── CLAUDE.md (or AGENTS.md)     # Minimal root with links
└── .claude/                      # Or docs/agent-instructions/
    ├── typescript.md
    ├── testing.md
    ├── code-style.md
    ├── git-workflow.md
    └── architecture.md
```

**Root file contains:**
- One-sentence project description
- Quick reference (commands, package manager)
- Links to detailed files

**Each linked file contains:**
- Topic overview
- Specific, actionable rules
- Examples (good vs avoid)

Templates: [Root Template](assets/root-template.md) | [Linked File Template](assets/linked-file-template.md)

See [Phase 4: File Structure](references/phase-4-structure.md) for detailed structure guidance.

### Phase 5: Flag for Deletion

Identify instructions that should be removed entirely.

**Delete if:**
- **Redundant**: Agent already knows (e.g., "Use TypeScript" in a .ts project)
- **Too vague**: Not actionable (e.g., "Write clean code")
- **Overly obvious**: Wastes context (e.g., "Don't introduce bugs")
- **Default behavior**: Standard practice (e.g., "Use descriptive variable names")
- **Outdated**: References deprecated APIs or patterns

**Output format:**
Present deletions in a table with reasons, ask user to confirm.

See [Phase 5: Deletion Criteria](references/phase-5-deletion.md) for detailed guidelines.

## Common Categories

### TypeScript Projects
- `typescript.md` - Type patterns, strict mode, generics
- `react.md` - Component patterns, hooks, state management
- `testing.md` - Jest/Vitest setup, component testing
- `code-style.md` - Naming, formatting, imports

### Python Projects
- `python.md` - Type hints, async patterns, decorators
- `testing.md` - pytest patterns, fixtures, mocking
- `api-design.md` - FastAPI/Flask conventions
- `code-style.md` - PEP 8, naming, imports

### .NET Projects
- `csharp.md` - C# conventions, LINQ, async/await
- `architecture.md` - Clean architecture, DI patterns
- `testing.md` - xUnit patterns, mocking
- `api-design.md` - ASP.NET Core conventions

### Full-Stack Projects
- `frontend.md` - UI framework conventions
- `backend.md` - API design, database patterns
- `testing.md` - Unit, integration, E2E tests
- `deployment.md` - CI/CD, environment config

## Execution Checklist

```
[ ] Phase 1: All contradictions identified and resolved
[ ] Phase 2: Root file contains ONLY essentials
[ ] Phase 3: All remaining instructions categorized
[ ] Phase 4: File structure created with proper links
[ ] Phase 5: Redundant/vague instructions removed
[ ] Verify: Each linked file is self-contained
[ ] Verify: Root file is under 50 lines
[ ] Verify: All links work correctly
```

## Anti-Patterns to Avoid

| Avoid | Why | Instead |
|-------|-----|---------|
| Keeping everything in root | Bloated, hard to maintain | Split into linked files |
| Too many categories | Fragmentation | Consolidate related topics |
| Vague instructions | Wastes tokens, no value | Be specific or delete |
| Duplicating defaults | Agent already knows | Only override when needed |
| Deep nesting | Hard to navigate | Flat structure with links |

## Example: Before & After

### Before (Bloated Root)
```markdown
# CLAUDE.md

This is a React project.

## Code Style
- Use 2 spaces
- Use semicolons
- Prefer const over let
- Use arrow functions
... (200 more lines)

## Testing
- Use Jest
- Coverage > 80%
... (100 more lines)

## TypeScript
- Enable strict mode
... (150 more lines)
```

### After (Progressive Disclosure)
```markdown
# CLAUDE.md

React dashboard for real-time analytics visualization.

## Commands
- `pnpm dev` - Start development server
- `pnpm test` - Run tests with coverage
- `pnpm build` - Production build

## Guidelines
- [Code Style](.claude/code-style.md)
- [Testing](.claude/testing.md)
- [TypeScript](.claude/typescript.md)
```

See [Before/After Examples](assets/before-after-example.md) for complete transformations.

## Verification

After refactoring, verify:

1. **Root file is minimal** - Under 50 lines, only universal info
2. **Links work** - All referenced files exist
3. **No contradictions** - Instructions are consistent
4. **Actionable content** - Every instruction is specific
5. **Complete coverage** - No instructions were lost (unless flagged for deletion)
6. **Self-contained files** - Each linked file stands alone

## Tools to Use

- **Read**: Examine the existing instruction file
- **Grep**: Search for duplicate or contradictory instructions
- **Write**: Create new root and linked files
- **AskUserQuestion**: Resolve contradictions or confirm deletions

## Notes

- Focus on actionable, specific instructions
- Delete vague advice like "write clean code"
- Preserve all unique, valuable guidance
- Link files should be self-contained (don't require reading others)
- Root file should be readable in < 1 minute
- Use **AskUserQuestion** when unsure about contradictions or deletions

## See Also

- [Progressive Disclosure Principles](references/progressive-disclosure.md) - Theory and benefits
- [Phase-by-Phase Guidance](references/) - Detailed guides for each phase
- [Templates](assets/) - Root and linked file templates
- [Example Transformations](assets/before-after-example.md) - Complete examples

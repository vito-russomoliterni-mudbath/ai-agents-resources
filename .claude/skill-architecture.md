# Skill Architecture

## Directory Structure

Each skill follows this structure:
- `SKILL.md` - Main workflow definition (frontmatter + phases)
- `assets/` - Templates, checklists, and examples
- `references/` - Detailed guidance documents
- `scripts/` - Helper scripts (if needed)

## Skill Frontmatter (SKILL.md)

Skills use YAML frontmatter to define:
- `name` - Skill identifier (kebab-case)
- `description` - When and how to use the skill
- `version` - Semantic version
- `user-invocable` - Whether users can invoke with `/skill-name`
- `disable-model-invocation` - Skip AI execution for prompt-only skills
- `argument-hint` - Help text for arguments

## Workflow Structure

Skills organize work into phases:
1. **Discovery/Planning** - Understand scope, gather context
2. **Baseline/Analysis** - Establish current state
3. **Implementation** - Execute the work
4. **Validation** - Verify correctness, run tests
5. **Iteration** - Fix issues until complete

## Tool Usage Per Phase

Each phase uses specific Claude Code tools:
- **Read/Grep/Glob** - Code exploration
- **Edit/Write** - Code changes
- **Bash** - Run tests, git commands, builds
- **TaskCreate/TaskUpdate/TaskList** - Track progress
- **AskUserQuestion** - Clarify requirements

## Skill Invocation Patterns

Skills handle different scopes:
- **Diff-based** - Compare against base branch (add-unit-tests, bug-fix)
- **Feature-focused** - Target specific area (new-feature)
- **Whole-codebase** - Scan entire project (refactor)
- **Interactive** - Ask user for scope (add-memory, agent-md-refactor)

## Progressive Disclosure Principle

Reference files in `references/` provide deep knowledge loaded only when needed to save context tokens. This same principle applies to this CLAUDE.md structure.

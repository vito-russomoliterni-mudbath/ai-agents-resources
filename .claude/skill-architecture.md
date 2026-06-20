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

Skills organise work into phases:
1. **Discovery/Planning** - Understand scope and gather context
2. **Baseline/Analysis** - Establish current state
3. **Implementation** - Execute the work
4. **Validation** - Verify correctness and run tests
5. **Iteration** - Fix issues until complete

## Tool Usage Per Phase

Each phase uses specific Claude Code tools:
- **Read/Grep/Glob** - Code exploration
- **Edit/Write** - Code changes
- **Bash** - Run tests, git commands, and builds
- **TaskCreate/TaskUpdate/TaskList** - Track progress
- **AskUserQuestion** - Clarify requirements

## Skill Invocation Patterns

Skills handle different scopes:
- **Interactive** - Ask the user questions iteratively to reach shared understanding (`grill-me`)
- **Delegation-based** - Dispatch subagents and synthesise results (`orchestrator`, `showlinks`)

## Progressive Disclosure Principle

Reference files in `references/` provide deep knowledge loaded only when needed to save context tokens. This same principle applies to the linked `.claude` documentation structure.

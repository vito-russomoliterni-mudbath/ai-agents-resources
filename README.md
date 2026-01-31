# AI Agents Resources

A collection of reusable Claude Code skills for software development workflows. These skills guide Claude through common development tasks with structured, phase-based workflows that ensure quality and completeness.

## What are Skills?

Skills are structured workflows that guide AI coding assistants through complex tasks. Each skill:
- Breaks work into clear phases (Discovery → Implementation → Validation)
- Uses task tracking to maintain progress
- Runs tests iteratively to ensure quality
- Follows established patterns and best practices
- Provides templates and reference documentation

## Available Skills

### 🐛 [bug-fix](skills/fixing-bugs/)
Systematically debug and fix software defects through identification, analysis, and validated correction.

**Use when:**
- User reports a bug or error
- Tests are failing
- Application exhibits incorrect behavior
- Regressions are detected

**Workflow:** Reproduce → Root cause analysis → Minimal fix → Test → Regression test

---

### ✨ [new-feature](skills/building-features/)
Implement new features using a structured approach with planning, implementation, testing, and quality assurance.

**Use when:**
- Adding new functionality
- Building components
- Developing new capabilities

**Workflow:** Plan → Task list → Documentation → Code → Verify → QA → Iterate

---

### 🧪 [add-unit-tests](skills/adding-tests/)
Add or update unit tests for code changes and iterate until all tests pass.

**Use when:**
- Adding tests for a PR
- Testing a specific feature
- Finding test coverage gaps

**Workflow:** Detect framework → Identify changes → Baseline → Add tests → Iterate until green

**Modes:**
- **Diff-based:** Compare against develop branch
- **Feature-focused:** Target specific area
- **Coverage audit:** Scan for gaps

---

### ♻️ [refactor](skills/refactoring-codeing-code/)
Safe, incremental refactoring while preserving behavior through continuous testing.

**Use when:**
- Code is hard to maintain or understand
- Duplication needs consolidation
- Structure needs improvement

**Workflow:** Baseline → Detect smells → Plan → Refactor → Test → Commit → Repeat

**Key principle:** Small steps, tests after each change, commit when green

---

### 💾 [add-memory](skills/adding-memory/)
Capture project knowledge and best practices in appropriate documentation files.

**Use when:**
- User says "remember this"
- Documenting patterns or guidelines
- Saving team best practices

**Workflow:** Clarify → Determine scope → Choose location → Format → Implement → Verify

**Scope decision:** Personal CLAUDE.md vs Project CLAUDE.md vs Local CLAUDE.md vs Structured docs

---

### 📝 [agent-md-refactor](skills/refactoring-codeing-agent-instructions/)
Refactor bloated agent instruction files using progressive disclosure principles.

**Use when:**
- CLAUDE.md or AGENTS.md is too long
- Instructions need better organization
- Context token usage is high

**Workflow:** Find contradictions → Extract essentials → Categorize → Create structure → Prune

**Goal:** Minimal root file (<50 lines) + categorized linked files

## Installation

### Option 1: Automated Installation (Recommended)

Clone the repository and run the installation script:

```bash
git clone https://github.com/vito-russomoliterni-mudbath/ai-agents-resources.git
cd ai-agents-resources
```

**Windows (PowerShell):**
```powershell
.\install-skills.ps1
```

**Interactive mode** (default) - Prompts for confirmation before installing/updating each skill:
```powershell
.\install-skills.ps1
```

**Automatic mode** - Installs/updates all skills without prompts:
```powershell
.\install-skills.ps1 -y
```

**Dry-run mode** - Shows what would be installed/updated without making changes:
```powershell
.\install-skills.ps1 -DryRun
```

**Verbose mode** - Shows detailed output (file sizes, paths, progress):
```powershell
.\install-skills.ps1 -v
```

**Combined flags** - Use multiple flags together:
```powershell
.\install-skills.ps1 -v -y          # Verbose automatic installation
.\install-skills.ps1 -v -DryRun    # Verbose dry-run
```

**Help:**
```powershell
.\install-skills.ps1 -help
```

The script will:
- Install skills to `~/.claude/skills/` (or `$CLAUDE_HOME/skills/`)
- Show which files will be added, updated, or deleted before making changes
- Ask for confirmation before each skill (unless using `-y` flag)
- Clean up old versions before installing new ones (prevents orphaned files)

### Option 2: Manual Installation
Copy any skill directory from `skills/` into your `~/.claude/skills/` directory.

## Usage

### With Claude Code CLI

Skills can be invoked using the `/skill-name` syntax in Claude Code:

```
/fixing-bugs "Login form throws error when password is empty"
/building-features "Add dark mode toggle to header"
/adding-tests
/refactoring-code
/adding-memory "Always use async/await for database operations"
/refactoring-agent-instructions
```

### Manual Workflow

You can also follow the workflows manually by reading the `SKILL.md` file in each skill directory.

## Skill Structure

Each skill follows a consistent structure:

```
skill-name/
├── SKILL.md              # Main workflow with YAML frontmatter
├── assets/               # Templates, checklists, examples
│   ├── template-name.md
│   └── checklist-name.md
├── references/           # Detailed guidance documents
│   ├── pattern-guide.md
│   └── strategy-guide.md
└── scripts/              # Helper scripts (optional)
    └── helper-script.sh
```

### Frontmatter Fields

```yaml
name: skill-name                 # Kebab-case identifier
description: When to use...      # Invocation guidance
version: 1.0.0                   # Semantic version
user-invocable: true            # Can users call it?
disable-model-invocation: false  # Skip AI execution?
argument-hint: "[what to do]"   # Help text
```

## Common Patterns

### Task Management
Skills use task tracking for complex workflows:
```
TaskCreate → TaskUpdate (in_progress) → TaskUpdate (completed) → TaskList
```

### Testing Approach
Skills that modify code:
```
1. Establish baseline (run tests before)
2. Make changes
3. Run tests after each change
4. Fix issues and re-run until passing
```

### Progressive Disclosure
Core workflow in `SKILL.md`, detailed guidance in `references/`, templates in `assets/`.

## Philosophy

These skills embody several key principles:

- **Minimal changes:** Smallest change that achieves the goal
- **Prefer Edit over Write:** Modify existing files when possible
- **Test-driven:** Run tests after every change
- **Incremental commits:** Commit after each successful step
- **Avoid over-engineering:** Don't add features beyond requirements
- **Root cause fixes:** Fix the problem, not symptoms

## Anti-Patterns Avoided

- Over-engineering solutions beyond requirements
- Adding features/improvements not requested
- Refactoring unrelated code during bug fixes
- Creating abstractions for one-time operations
- Adding error handling for impossible scenarios
- Skipping tests or committing failing code
- Making changes to code you haven't read first

## Contributing

Contributions are welcome! When adding or modifying skills:

1. Follow the established directory structure
2. Use consistent phase naming (Discovery, Implementation, Validation)
3. Include actionable, specific instructions
4. Provide templates in `assets/` when helpful
5. Create focused reference docs in `references/`
6. Keep the main SKILL.md workflow-focused
7. Test the skill workflow on real projects

## Documentation

- [CLAUDE.md](CLAUDE.md) - Detailed guidance for Claude Code working in this repository
- Individual skill READMEs in each `skills/` directory
- Reference documentation within each skill's `references/` directory

## License

MIT License - see [LICENSE](LICENSE) for details

## Credits

Created for use with [Claude Code](https://claude.ai/code) by Anthropic.

---

**Version:** 1.0.0
**Last Updated:** 2026-01-31

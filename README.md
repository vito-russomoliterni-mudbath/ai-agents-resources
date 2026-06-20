# AI Agents Resources

A collection of reusable AI Agent skills for software development workflows. These skills guide agents like Claude Code, Codex, and Gemini through common development tasks with structured, phase-based workflows that ensure quality and completeness.

## 🧭 Navigation

- [What are Skills?](#what-are-skills)
- [Active Skills](#active-skills)
- [Archived Skills](#archived-skills)
- [Installation](#installation)
- [Usage](#usage)
- [Skill Structure](#skill-structure)
- [Common Patterns](#common-patterns)
- [Philosophy](#philosophy)
- [Anti-Patterns Avoided](#anti-patterns-avoided)
- [Contributing](#contributing)
- [Documentation](#documentation)
- [License](#license)

## What are Skills?

Skills are structured workflows that guide AI coding assistants through complex tasks. Each skill:
- Breaks work into clear phases (Discovery → Implementation → Validation)
- Uses task tracking to maintain progress
- Runs tests iteratively to ensure quality
- Follows established patterns and best practices
- Provides templates and reference documentation

## Active Skills

### 🔥 [grill-me](skills/grill-me/)
Interview-style stress-test for plans and designs — relentlessly asks questions until every branch of the decision tree is resolved.

**Use when:**
- Stress-testing a plan or design before committing
- User says "grill me" or wants probing questions on their approach
- Resolving dependencies between decisions iteratively

**Workflow:** Ask one question at a time → provide recommended answer → walk each branch → reach shared understanding

---

### 🚁 [orchestrator](skills/orchestrator/)
Delegates heavy research, file edits, and diff review to opencode subagents to preserve the host agent's context budget.

**Use when:**
- Broad codebase exploration
- Multi-file research
- Sizable or repetitive edits
- Pre-merge review

**Agents:** `researcher`, `editor`, `reviewer` defined in `subagents/`

**Workflow:** Dispatch `researcher` → Review summary → Dispatch `editor` → Dispatch `reviewer`

---

### 🔗 [show-links](skills/show-links/)
Research topics by finding official documentation and reputable sources, then delivering direct links with recommendations.

**Use when:**
- User asks to search online or look up a topic
- Researching a library, tool, or framework
- Finding documentation or investigating anything requiring web research

**Workflow:** Find official docs → Confirm version match → Dispatch reviewer subagent → Refine if rejected → Return vetted links

---

## Archived Skills

The following skills are preserved in [`archive/`](archive/) but are no longer
auto-installed by the install script. They can still be copied manually if needed.

`adding-memory` · `adding-tests` · `building-features` · `building-skills` ·
`cleaning-git-branches` · `creating-automation-scripts` · `creating-subagents` ·
`fixing-bugs` · `plan-reviewer` · `refactoring-agent-instructions` ·
`refactoring-code` · `reviewing-pr-links` · `running-isolated-subagents`

## Installation

### Option 1: Automated Installation (Recommended)

Clone the repository and run the installation script:

**Linux / macOS (Bash):**
```bash
git clone https://github.com/vito-russomoliterni-mudbath/ai-agents-resources.git
cd ai-agents-resources
./install-skills.sh
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/vito-russomoliterni-mudbath/ai-agents-resources.git
cd ai-agents-resources
.\install-skills.ps1
```

**Interactive mode** (default) - Prompts for confirmation before installing/updating each skill:
```bash
./install-skills.sh
```

**Automatic mode** - Installs/updates all skills without prompts:
```bash
./install-skills.sh -y
```

**Skip Agent Prompt** - Installs/updates all skills to all agents without asking:
```bash
./install-skills.sh --skip-agent-prompt
```

**Dry-run mode** - Shows what would be installed/updated without making changes:
```bash
./install-skills.sh --dry-run
```

**Copy mode** - Forces copy behavior instead of symlinks (symlinks are default on Linux/macOS):
```bash
./install-skills.sh --copy
```

**Verbose mode** - Shows detailed output (file sizes, paths, progress):
```bash
./install-skills.sh -v
```

**Help:**
```bash
./install-skills.sh --help
```

*(Note: The same flags apply to `install-skills.ps1` for Windows users, e.g., `.\install-skills.ps1 -y`, `.\install-skills.ps1 -DryRun`)*

The script will:
- Let you choose which agents to install skills for (Claude Code, Codex, Gemini, OpenCode, Mistral Vibe, or All)
- On Linux/macOS, install skills as **symlinks** by default so edits propagate live; use `--copy` to copy instead
- When OpenCode is selected, also install **subagents** (`subagents/*.md` → `~/.config/opencode/agents/`)
- Skip agents whose binary is not found on PATH, and show only processed agents in the final recap
- Show which files will be added, updated, or deleted before making changes
- Ask for confirmation before each skill (unless using `-y` flag)
- Clean up old versions before installing new ones (prevents orphaned files)

### Option 2: Manual Installation
Copy any skill directory from `skills/` into your agent's skills directory:

| Agent | Global skills path |
|---|---|
| Claude Code | `~/.claude/skills/` |
| OpenCode | `~/.config/opencode/skills/` |
| Mistral Vibe | `~/.vibe/skills/` |
| Codex | `~/.codex/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| Gemini Antigravity | `~/.gemini/antigravity/global_skills/` |

> **Note:** The automated install script supports all agents listed above. Override the default home directory with the corresponding env var (e.g. `VIBE_HOME`, `OPENCODE_HOME`).

## Usage

### With Claude Code CLI

Skills can be invoked using the `/skill-name` syntax in Claude Code:

```
/grill-me "My plan to migrate the auth service to OAuth2"
/orchestrator "Research how authentication is handled across the codebase"
/show-links "official docs for Vite server.allowedHosts"
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
- Individual `SKILL.md` files in each `skills/` directory
- Reference documentation within each skill's `references/` directory

## License

MIT License - see [LICENSE](LICENSE) for details

## Credits

Compatible with Claude Code, OpenCode, Mistral Vibe, Codex, and Gemini CLI via the [Agent Skills open standard](https://agentskills.io/).

---

**Version:** 1.0.0
**Last Updated:** 2026-06-20

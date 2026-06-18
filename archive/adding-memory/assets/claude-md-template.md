# CLAUDE.md Template

Use this template as a starting point for CLAUDE.md files at different scopes.

## Personal CLAUDE.md Template (~/.claude/CLAUDE.md)

```markdown
# My Development Preferences

Personal guidelines for my own development workflow.

## Editor & Tools

### VS Code Setup
- Extensions: [list your key extensions]
- Settings: [notable configurations]
- Keyboard shortcuts: [any custom bindings]

### Shell & CLI
- Shell: bash / zsh / fish
- Package manager: brew / apt / etc
- Terminal multiplexer: tmux / zellij / etc

## Development Workflow

### Language Preferences

**JavaScript/TypeScript**:
- [Your preference 1]
- [Your preference 2]

**Python**:
- [Your preference 1]
- [Your preference 2]

### Testing Approach
- [How you like to write tests]
- [What tools you prefer]
- [Debugging technique]

### Debugging Techniques
- [Console logging preference]
- [Debugger usage]
- [Print debugging approach]

## Performance Tips I Use
- [Optimization 1]
- [Optimization 2]

## Keyboard Shortcuts I Created
- Cmd+K Cmd+X: [action]
- [Key combo]: [action]

## Notes for Claude Code
- [How Claude should help me]
- [Preferences for suggestions]
- [Things not to do]
```

## Project CLAUDE.md Template ([repo]/CLAUDE.md)

```markdown
# Project Guidelines

## Overview
[Brief project description, team size, key technologies]

## Quick Reference

### Commands
```bash
# Common development commands
npm install
npm run dev
npm test
```

### Environment Setup
- Node.js: 18+
- Package Manager: npm v9+
- Database: PostgreSQL 14+
- [Other key tools]

## Architecture Overview

### Directory Structure
```
src/
├── components/    # React components
├── services/      # Business logic
├── utils/         # Helper functions
└── types/         # TypeScript definitions
```

### Core Concepts
- [Key architecture pattern 1]
- [Key architecture pattern 2]

## Development Guidelines

### Code Style Requirements
- Use ESLint + Prettier
- TypeScript strict mode always
- No `any` types without comment
- camelCase for variables, PascalCase for components

### React-Specific
- Functional components only
- Use hooks, not class components
- useState for local state
- Redux for global state

### Testing Strategy
- Unit: Jest/Vitest
- E2E: Cypress
- Target: >80% coverage

### Error Handling
- All promises must be caught
- Use try/catch for async code
- Log all errors with context

## Key Patterns & Anti-Patterns

### Pattern: Compound Components
[Description and when to use]

### Anti-Pattern: Prop Drilling
[Description and why to avoid]

## Performance Considerations
- [Optimization 1]
- [Optimization 2]

## Security Guidelines
- [Security practice 1]
- [Security practice 2]

## Key Dependencies
- React 18.2.0 - UI framework
- Redux Toolkit 1.9 - State management
- [Others and their purpose]

## Useful Links
- [Link 1]
- [Link 2]

## Notes for Claude Code
- [How to help developers in this project]
- [Common patterns to use]
- [Things to avoid]
```

## Module/Tool CLAUDE.md Template ([tool]/CLAUDE.md)

```markdown
# Tool: Data Processor

Setup and patterns specific to this tool.

## Overview
[What this tool does, why it exists, dependencies]

## Quick Start

```bash
# Activate environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run tool
python main.py
```

## Architecture

### How It Works
[Flow diagram or description]

### Key Components
- [Component 1]: [What it does]
- [Component 2]: [What it does]

### Data Models
- [Model 1]: [What it represents]
- [Model 2]: [What it represents]

## Common Tasks

### Adding a New Feature
[Step-by-step]

### Debugging Issues
[Debugging approach]

### Deploying Changes
[Deployment process]

## Dependencies & Versions
- Python: 3.10+
- Framework: Prefect 3.6.6
- Database: SQL Server

## Integration with Main Project
[How this tool connects to rest of project]

## Performance Considerations
[Tool-specific optimizations]

## Known Issues & Workarounds
- [Issue and workaround]

## Related Documentation
- [Link 1]
- [Link 2]
```

## Common Sections Used Across Levels

All CLAUDE.md files should have clear sections:

### Overview / Purpose
Brief description of what this guidance covers

### Quick Reference
Commands, setup, key facts (2-5 minutes to scan)

### Architecture
How things are organized

### Guidelines / Patterns
What to do and why

### Tools & Dependencies
What's used and current versions

### Troubleshooting
Common problems and solutions

### Links & References
Where to find more info

### Notes for Claude Code
Guidance for AI assistants

## Key Principles

1. **Specific**: Not vague advice, specific to this scope
2. **Current**: Update versions, links, deprecations
3. **Organized**: Clear sections, easy to scan
4. **Practical**: Include examples and steps
5. **Maintained**: Regular review (see memory-maintenance.md)

## When You Have Multi-Level CLAUDE.md

Structure:
- Personal: Only YOUR preferences
- Project: Team/project-wide standards
- Module: Only relevant in this tool
- Avoid: Duplicating information

Cross-reference:
- "See Project CLAUDE.md Development Guidelines"
- "See backend/CLAUDE.md for .NET specific patterns"
- "Personal preferences in ~/.claude/CLAUDE.md"

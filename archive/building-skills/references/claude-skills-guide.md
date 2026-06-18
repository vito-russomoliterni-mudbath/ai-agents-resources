# Claude Skills Implementation Guide

This guide provides Claude-specific implementation details for agent skills, following the Agent Skills specification.

## Skill Discovery and Precedence

Claude discovers skills from the following locations (in order of precedence):

1. **Project Skills**: `.agent/skills/` (in project root)
2. **User Skills**: `~/.agent/skills/`
3. **Plugin Skills**: Provided by installed Claude Code plugins

## Skill Structure

A skill is a directory containing a mandatory `SKILL.md` file and optional supporting directories:

```
skill-name/
├── SKILL.md (required)
├── scripts/ (optional - for deterministic logic)
├── references/ (optional - for documentation)
└── assets/ (optional - for templates/media)
```

## SKILL.md Format

The `SKILL.md` file must contain YAML frontmatter and a markdown body.

### YAML Frontmatter

Required fields:
- `name`: kebab-case (max 64 chars)
- `description`: Third-person explanation of what it does and **exact trigger phrases**.
- `version`: Semantic version (e.g., `0.1.0`)

Optional fields:
- `allowed-tools`: List of tools the skill is permitted to use.

Example:
```yaml
---
name: code-review
description: This skill should be used when the user asks to "review my code", "check for bugs", or "perform a security audit". It provides comprehensive code review for quality and security.
version: 1.0.0
---
```

### Markdown Body

The body should follow the **Progressive Disclosure** pattern:
1. **Overview**: Brief explanation of purpose.
2. **Workflow**: Step-by-step imperative instructions.
3. **Best Practices**: Research-backed recommendations.
4. **References**: Links to files in `references/`, `scripts/`, or `assets/`.

## Best Practices

- **Third-Person**: Descriptions must use "This skill should be used when..."
- **Exact Triggers**: Use quotes for phrases the user might actually say.
- **Token Efficiency**: Keep the body lean (< 2000 words).
- **Tool Restriction**: Use `allowed-tools` to increase reliability if possible.
- **Routing**: For complex skills, use a "Decision Tree" to guide the agent.

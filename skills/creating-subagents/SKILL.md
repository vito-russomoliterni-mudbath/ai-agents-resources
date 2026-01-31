---
name: creating-subagents
description: Guides creation of Claude Code sub-agents through task analysis, configuration design, and validation. Use when asked to "create a sub-agent", "add a subagent", "configure a new agent", "define a specialized agent", or "set up delegation".
version: 1.0.0
license: MIT
user-invocable: true
argument-hint: "[task description or workflow to automate]"
---

# Creating Sub-agents

## Overview

Create effective sub-agents for Claude Code that handle specialized tasks through delegation. This workflow analyzes user requirements, recommends optimal configuration, and generates properly formatted sub-agent definitions.

**Degrees of Freedom**: Medium - Follow the workflow phases in order; adjust questions based on user responses.

## Prerequisites

- Understanding of what task the sub-agent should handle
- Target location for the configuration file

## Quick Reference

| Phase | Purpose | Key Actions |
|-------|-------|-------------|
| 1. Discovery | Gather requirements | AskUserQuestion for purpose, scope, complexity, skills/MCP |
| 2. Analysis | Recommend configuration | Decision tree for agent type/model/tools |
| 3. Design | Configure fields | Map requirements to config values |
| 4. Validation | User confirmation | Present config summary, ask approval |
| 5. Output | Generate file | Write .yaml or .md to target location |

## Workflow

### Phase 1: Discovery

Gather information about the sub-agent requirements using **AskUserQuestion**.

**Required Questions:**

1. **Purpose** - What task should this sub-agent handle?
   - Codebase exploration/analysis
   - Planning and research
   - Code modification/implementation
   - Testing and validation
   - Terminal/command execution
   - Custom workflow

2. **Scope** - What level of access does it need?
   - Read-only (analysis, exploration)
   - Read + execute (testing, validation)
   - Full access (implementation, modification)

3. **Complexity** - How complex are the decisions?
   - Simple, repetitive tasks (use haiku)
   - Balanced tasks requiring judgment (use sonnet)
   - Complex reasoning or architecture (use opus)

4. **Location** - Where should the config file be saved?
   - Project-specific: `.claude/agents/`
   - Personal (all projects): `~/.claude/agents/`

5. **Skills & MCP Needs** - Does the sub-agent need AI tool access?
   - Specific skills to preload (e.g., fixing-bugs, building-features)
   - MCP server tools (e.g., GitHub, Slack, browser automation)
   - Whether skills should load at startup or be discovered on-demand

See [Skills and MCP Integration](references/skills-and-mcp-integration.md) for detailed guidance.

### Phase 2: Analysis

Based on gathered requirements, recommend a configuration using this decision tree:

```
Primary purpose?
├─ Codebase exploration/research
│   └─ EXPLORE pattern
│      Model: haiku | Permission: plan | Tools: Read, Grep, Glob
│
├─ Planning and design
│   └─ PLAN pattern
│      Model: inherit | Permission: plan | Tools: Read, Grep, Glob, WebSearch
│
├─ Code implementation
│   └─ IMPLEMENT pattern
│      Model: sonnet | Permission: acceptEdits | Tools: Read, Edit, Write, Grep, Glob, Bash
│
├─ Testing and validation
│   └─ TEST pattern
│      Model: sonnet | Permission: default | Tools: Bash, Read, Grep, Glob
│
├─ Terminal operations only
│   └─ BASH pattern
│      Model: haiku | Permission: default | Tools: Bash
│
└─ Custom workflow
    └─ Design custom configuration based on specific needs
```

**Present recommendation with rationale:**
- Explain why this pattern fits the user's needs
- Note any trade-offs (speed vs capability, access vs safety)
- Offer alternatives if applicable

See [Built-in Archetypes](references/built-in-archetypes.md) for detailed pattern examples.

### Phase 3: Design

Configure each field based on the selected pattern.

**Required Fields:**

| Field | Format | Description |
|-------|--------|-------------|
| name | lowercase kebab-case | Unique identifier (1-64 chars) |
| description | 1-1024 chars | When to delegate + trigger phrases |
| prompt | multi-line string | System prompt defining role/behavior |

**Optional Fields:**

| Field | Options | Default |
|-------|---------|---------|
| model | haiku, sonnet, opus | inherit |
| tools | array of tool names | all |
| disallowedTools | array of tool names | none |
| permissionMode | default, acceptEdits, dontAsk, bypassPermissions, plan | default |
| skills | array of skill names | none |
| hooks | lifecycle event handlers | none |

See [Configuration Fields Reference](references/configuration-fields.md) for complete documentation.

**Naming Guidelines:**
- Use descriptive, action-oriented names
- Follow kebab-case convention
- Examples: `code-explorer`, `test-runner`, `feature-builder`

**Description Guidelines:**
- Start with what the agent handles
- Include trigger conditions
- Example: "Reviews code for bugs and style. Use when reviewing PRs or checking code quality."

**Prompt Guidelines:**
- Define clear role ("You are a...")
- List specific capabilities
- Include constraints/boundaries
- Specify output format if needed
- Keep under 500 words

### Phase 4: Validation

Present the complete configuration for user approval.

**Display format:**

```
## Recommended Sub-agent Configuration

**Name**: [name]
**Purpose**: [description summary]

### Configuration Summary

| Field | Value | Rationale |
|-------|-------|-----------|
| model | [value] | [why this model] |
| tools | [list] | [why these tools] |
| permissionMode | [value] | [why this mode] |
| skills | [list or none] | [why these skills] |

### Prompt Preview
[First 200 chars of prompt...]

### Trade-offs
- [Benefit 1]
- [Consideration 1]
```

**Use AskUserQuestion** to confirm:
- Proceed with this configuration?
- Adjust any fields?
- Change the approach entirely?

### Phase 5: Output

Generate the configuration file.

**Ask for format preference:**
1. YAML (.yaml) - Claude Code native format, compact
2. Markdown (.md) - Human-readable with prose sections

**Generate using templates:**
- [YAML Template](assets/subagent-template.yaml)
- [Markdown Template](assets/subagent-template.md)

**Determine file path:**
- Project: `.claude/agents/[name].yaml` or `.md`
- Personal: `~/.claude/agents/[name].yaml` or `.md`

**Verify before creation:**
- Check [Configuration Checklist](assets/configuration-checklist.md)
- Validate all required fields present
- Ensure name is unique in target location

**Write the file** using the Write tool.

## Common Scenarios

### "I need a fast code explorer"

```yaml
name: explorer
description: Quickly explores the codebase for patterns and structure. Use for understanding code before making changes.
model: haiku
permissionMode: plan
tools:
  - Read
  - Grep
  - Glob
prompt: |
  You are a fast code explorer. Analyze the codebase and report:
  - File structure and organization
  - Key patterns and conventions
  - Relevant code sections
  Never suggest changes, only report findings.
```

### "I need a test runner"

```yaml
name: test-runner
description: Runs tests and analyzes results. Use for test execution and debugging failures.
model: sonnet
tools:
  - Bash
  - Read
  - Grep
  - Glob
prompt: |
  You are a testing specialist. Your role is to:
  - Run test suites and analyze results
  - Identify failing tests and their causes
  - Suggest fixes based on test output
  - Report coverage metrics when available
```

### "I need a feature builder with GitHub access"

```yaml
name: feature-builder
description: Implements features with full codebase access and GitHub integration. Use for building new functionality.
model: sonnet
permissionMode: acceptEdits
tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
  - mcp__github__create_pull_request
  - mcp__github__list_issues
skills:
  - building-features
prompt: |
  You are a feature implementation specialist. Your role is to:
  - Implement features following existing patterns
  - Write clean, tested code
  - Create pull requests when work is complete
  - Follow project conventions
```

See [Built-in Archetypes](references/built-in-archetypes.md) for more patterns.

## Tools to Use

### Discovery Phase
- **AskUserQuestion**: Gather requirements and preferences

### Analysis Phase
- **Glob**: Find existing `.claude/agents/` configurations
- **Read**: Examine existing patterns in the project

### Output Phase
- **Write**: Create the configuration file
- **Read**: Verify the generated file

## Best Practices

### Tool Selection
- Start minimal, add tools as needed
- Read-only tasks: Read, Grep, Glob
- Testing tasks: Add Bash
- Modification tasks: Add Edit, Write
- See [Tool Access Patterns](references/tool-access-patterns.md)

### Model Selection
- haiku: Fast, cheap, good for read-only analysis
- sonnet: Balanced, suitable for most tasks
- opus: Complex reasoning, architecture decisions
- See [Model Selection Guide](references/model-selection.md)

### Permission Modes
- plan: Read-only, safest for exploration
- default: Normal permission prompts
- acceptEdits: Auto-accept file changes
- See [Permission Modes](references/permission-modes.md)

### Skills & MCP Integration
- Preload skills for specialized knowledge
- Add MCP tools for external service access
- See [Skills and MCP Integration](references/skills-and-mcp-integration.md)

## Anti-Patterns to Avoid

### Over-Permissioning
- Do not give full tool access when read-only suffices
- Do not use bypassPermissions unless explicitly required
- Do not use opus for simple tasks

### Vague Descriptions
- Do not write "A helpful agent"
- Do not omit trigger conditions
- Do not duplicate existing built-in agents

### Complex Prompts
- Do not write novel-length system prompts
- Do not include unnecessary constraints
- Do not repeat Claude's default behaviors

## Reference Files

- [Configuration Fields](references/configuration-fields.md) - Complete field documentation
- [Tool Access Patterns](references/tool-access-patterns.md) - Tool selection guidance
- [Model Selection](references/model-selection.md) - Choosing the right model
- [Permission Modes](references/permission-modes.md) - Permission mode details
- [Built-in Archetypes](references/built-in-archetypes.md) - Common patterns
- [Skills and MCP Integration](references/skills-and-mcp-integration.md) - AI tool ecosystem
- [YAML Template](assets/subagent-template.yaml) - Template for YAML output
- [Markdown Template](assets/subagent-template.md) - Template for MD output
- [Configuration Checklist](assets/configuration-checklist.md) - Pre-creation validation

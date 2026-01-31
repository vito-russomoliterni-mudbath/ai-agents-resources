# Sub-agent Configuration Fields Reference

Complete documentation for all sub-agent configuration fields.

## Required Fields

### name (required)

Unique identifier for the sub-agent.

| Property | Value |
|----------|-------|
| Type | String |
| Format | Lowercase kebab-case |
| Length | 1-64 characters |

**Constraints:**
- No spaces, underscores, or special characters
- Cannot start or end with hyphen
- No consecutive hyphens
- Must be unique within scope (project or user)

**Examples:**
- `code-explorer`
- `test-runner`
- `feature-builder`
- `pr-reviewer`

### description (required)

When to delegate to this agent.

| Property | Value |
|----------|-------|
| Type | String |
| Length | 1-1024 characters |

**Format:** "[Handles X]. Use when [condition]."

**Best Practices:**
- Start with what the agent handles
- Include trigger phrases users might type
- Be specific about use cases

**Good Examples:**
```yaml
description: Reviews code for bugs and style issues. Use when reviewing PRs, checking code quality, or when asked to "review this code".
```

```yaml
description: Runs tests and analyzes failures. Use for test execution, debugging test issues, or when asked to "run the tests".
```

**Poor Examples:**
```yaml
description: A helpful agent  # Too vague
```

```yaml
description: Does stuff with code  # No trigger conditions
```

### prompt (required)

System prompt defining role and behavior.

| Property | Value |
|----------|-------|
| Type | String (multi-line supported) |
| Recommended Length | Under 500 words |

**Components:**
1. Role definition ("You are a...")
2. Specific capabilities (what it can do)
3. Constraints/boundaries (what it should avoid)
4. Output format (if applicable)

**Example:**
```yaml
prompt: |
  You are a code review specialist. Your role is to:
  - Review code for bugs, security issues, and style violations
  - Provide specific, actionable feedback with line references
  - Suggest improvements without being overly critical

  Constraints:
  - Do not make changes, only report findings
  - Focus on significant issues, not minor style preferences
  - Be constructive and educational in feedback

  Output format:
  - Group findings by severity (Critical, Warning, Info)
  - Include file path and line number for each finding
```

## Optional Fields

### model

Override the model used by this sub-agent.

| Property | Value |
|----------|-------|
| Type | String |
| Options | `haiku`, `sonnet`, `opus` |
| Default | Inherit from parent agent |

**When to specify:**
- `haiku`: Fast, cheap tasks (exploration, simple analysis)
- `sonnet`: Balanced tasks (implementation, testing)
- `opus`: Complex reasoning (architecture, security analysis)

**When to omit:**
- When you want consistency with parent context
- When unsure which model to use

### tools

Array of allowed tools for this sub-agent.

| Property | Value |
|----------|-------|
| Type | Array of strings |
| Default | Inherit all tools from parent |

**Built-in Tools:**
- `Read` - Read file contents
- `Write` - Create/overwrite files
- `Edit` - Modify existing files
- `Grep` - Search file contents
- `Glob` - Find files by pattern
- `Bash` - Execute shell commands
- `WebSearch` - Search the web
- `WebFetch` - Fetch URL content
- `AskUserQuestion` - Prompt user for input

**MCP Tools:**
Format: `mcp__servername__toolname`

Examples:
- `mcp__github__create_pull_request`
- `mcp__slack__send_message`
- `mcp__chrome-devtools__take_screenshot`

### disallowedTools

Tools to explicitly deny access to.

| Property | Value |
|----------|-------|
| Type | Array of strings |
| Default | None |

**Use when:**
- You want most tools but need to block specific ones
- Simpler than listing all allowed tools

**Example:**
```yaml
# Allow everything except file modification
disallowedTools:
  - Write
  - Edit
```

### permissionMode

How the sub-agent handles permission prompts.

| Property | Value |
|----------|-------|
| Type | String |
| Options | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| Default | `default` |

**Modes:**

| Mode | Behavior | Risk Level |
|------|----------|------------|
| `plan` | Read-only, no modifications | Lowest |
| `default` | Normal permission prompts | Low |
| `acceptEdits` | Auto-accept file modifications | Medium |
| `dontAsk` | Skip most confirmations | High |
| `bypassPermissions` | Full access, no checks | Highest |

### skills

Skills to preload for this sub-agent.

| Property | Value |
|----------|-------|
| Type | Array of strings |
| Default | None |

**Example:**
```yaml
skills:
  - fixing-bugs
  - adding-tests
```

**When to use:**
- Sub-agent needs specialized domain knowledge
- Workflow benefits from pre-loaded instructions
- You want consistent behavior across sessions

### hooks

Lifecycle event handlers for advanced customization.

| Property | Value |
|----------|-------|
| Type | Object |
| Default | None |

**Available Events:**
- `PreToolUse` - Before a tool is executed
- `PostToolUse` - After a tool completes

**Example:**
```yaml
hooks:
  PreToolUse:
    - command: "echo 'About to use tool'"
```

**Use sparingly** - hooks add complexity and can slow down execution.

## Field Interactions

### Tool + Permission Combinations

| Scenario | Tools | Permission Mode |
|----------|-------|-----------------|
| Safe exploration | Read, Grep, Glob | plan |
| Testing | Bash, Read, Grep | default |
| Implementation | All | acceptEdits |
| Automation | All | bypassPermissions |

### Model + Complexity Guidelines

| Task Complexity | Recommended Model | Example Tasks |
|-----------------|-------------------|---------------|
| Simple | haiku | File search, pattern matching |
| Moderate | sonnet | Implementation, testing, review |
| Complex | opus | Architecture, security, optimization |

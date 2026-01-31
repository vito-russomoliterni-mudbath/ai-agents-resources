# Skills and MCP Integration

Integrating AI tools into sub-agents.

## Overview

Sub-agents can leverage two types of AI tool extensions:
1. **Skills** - Packaged instructions and workflows preloaded at startup
2. **MCP Tools** - External service integrations accessed via tool calls

## Skills Integration

### What Are Skills?

Skills are reusable instruction packages that provide:
- Specialized domain knowledge
- Workflow guidance
- Best practices
- Templates and checklists

### When to Preload Skills

**Preload at startup when:**
- Sub-agent always needs the skill's knowledge
- Workflow is core to the sub-agent's purpose
- Consistency across all uses is important
- Skill provides essential context

**Discover on-demand when:**
- Skill is only occasionally needed
- Sub-agent handles varied tasks
- You want to minimize initial context size
- Skill is situationally relevant

### Skills Field Configuration

```yaml
name: feature-builder
description: Builds features following best practices
skills:
  - building-features
  - adding-tests
```

### Common Skills to Consider

| Skill | Purpose | Preload When |
|-------|---------|--------------|
| `fixing-bugs` | Bug investigation and fixes | Sub-agent handles debugging |
| `building-features` | Feature implementation | Sub-agent builds new features |
| `adding-tests` | Test creation | Sub-agent writes tests |
| `refactoring-code` | Code improvement | Sub-agent does refactoring |

### Example: Skill-Enhanced Sub-agent

```yaml
name: feature-developer
description: Develops features with testing. Use for new feature implementation.
model: sonnet
permissionMode: acceptEdits
tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
skills:
  - building-features
  - adding-tests
prompt: |
  You are a feature developer. Follow the building-features skill workflow:
  1. Understand requirements
  2. Plan implementation
  3. Implement incrementally
  4. Add tests using adding-tests skill
  5. Validate and refine
```

## MCP Tools Integration

### What Are MCP Tools?

MCP (Model Context Protocol) tools provide:
- External service integrations
- Authenticated API access
- Specialized capabilities
- Real-time data access

### Tool Naming Pattern

```
mcp__[server-name]__[tool-name]
```

**Examples:**
- `mcp__github__create_pull_request`
- `mcp__claude_ai_Slack__slack_send_message`
- `mcp__chrome-devtools__take_screenshot`

### Common MCP Servers

#### GitHub (`mcp__github__*`)

| Tool | Purpose |
|------|---------|
| `list_issues` | List repository issues |
| `issue_read` | Read issue details |
| `issue_write` | Create/update issues |
| `create_pull_request` | Create new PR |
| `pull_request_read` | Read PR details |
| `list_commits` | List repository commits |
| `get_file_contents` | Get file from repo |

**Example configuration:**
```yaml
tools:
  - Read
  - Grep
  - mcp__github__list_issues
  - mcp__github__issue_read
  - mcp__github__create_pull_request
```

#### Slack (`mcp__claude_ai_Slack__*`)

| Tool | Purpose |
|------|---------|
| `slack_send_message` | Send message to channel |
| `slack_read_channel` | Read channel messages |
| `slack_search_public` | Search public channels |
| `slack_read_thread` | Read thread replies |

**Example configuration:**
```yaml
tools:
  - mcp__claude_ai_Slack__slack_send_message
  - mcp__claude_ai_Slack__slack_read_channel
```

#### Chrome DevTools (`mcp__chrome-devtools__*`)

| Tool | Purpose |
|------|---------|
| `navigate_page` | Navigate to URL |
| `take_screenshot` | Capture page screenshot |
| `click` | Click element |
| `fill` | Fill form field |
| `evaluate_script` | Run JavaScript |

**Example configuration:**
```yaml
tools:
  - mcp__chrome-devtools__navigate_page
  - mcp__chrome-devtools__take_screenshot
  - mcp__chrome-devtools__click
  - mcp__chrome-devtools__fill
```

### MCP Tool Selection Decision Tree

```
Does the sub-agent need to...
│
├─ Work with GitHub (issues, PRs, code)
│   └─ Add mcp__github__* tools
│
├─ Send Slack notifications
│   └─ Add mcp__claude_ai_Slack__* tools
│
├─ Automate browser interactions
│   └─ Add mcp__chrome-devtools__* tools
│
├─ Access documentation
│   └─ Add mcp__context7__* tools
│
└─ None of the above
    └─ Skip MCP tools
```

## Combined Configuration Examples

### Full-Stack Feature Developer

```yaml
name: fullstack-developer
description: Develops features with GitHub integration and testing.
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
  - adding-tests
prompt: |
  You are a full-stack developer with GitHub access. Your workflow:
  1. Check related issues with mcp__github__list_issues
  2. Implement features following building-features skill
  3. Write tests using adding-tests skill
  4. Create PR with mcp__github__create_pull_request
```

### CI/CD Notifier

```yaml
name: ci-notifier
description: Runs tests and notifies Slack of results.
model: sonnet
tools:
  - Bash
  - Read
  - mcp__claude_ai_Slack__slack_send_message
prompt: |
  You are a CI/CD notification agent. Your role:
  1. Run the test suite
  2. Analyze results
  3. Send summary to Slack channel

  Format Slack messages clearly with pass/fail status.
```

### Visual QA Tester

```yaml
name: visual-qa
description: Performs visual QA testing with screenshots.
model: sonnet
tools:
  - mcp__chrome-devtools__navigate_page
  - mcp__chrome-devtools__take_screenshot
  - mcp__chrome-devtools__click
  - mcp__chrome-devtools__fill
  - Read
  - Write
prompt: |
  You are a visual QA specialist. Your role:
  1. Navigate to test pages
  2. Take screenshots at key states
  3. Verify visual appearance
  4. Test user interactions
  5. Report any visual bugs found
```

## Best Practices

### Minimal Access
- Only include MCP tools actually needed
- Prefer specific tools over entire server access
- Start without MCP tools, add as needed

### Skill Selection
- Preload skills that are always relevant
- Let situational skills be discovered
- Don't overload with too many skills

### Tool + Skill Synergy
- Combine skills with related MCP tools
- Let skills guide MCP tool usage
- Document the expected workflow

### Security Considerations
- MCP tools may have authentication
- Some tools can modify external systems
- Review tool capabilities before adding
- Consider permission mode implications

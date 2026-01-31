# Tool Access Patterns

Common tool combinations for different sub-agent purposes.

## Pattern Overview

| Pattern | Purpose | Tools | Risk |
|---------|---------|-------|------|
| Read-Only | Analysis, exploration | Read, Grep, Glob | Low |
| Research | Web + codebase research | Read, Grep, Glob, WebSearch, WebFetch | Low |
| Testing | Test execution, validation | Bash, Read, Grep, Glob | Medium |
| Modification | Code changes | Read, Edit, Write, Grep, Glob | Medium |
| Full Access | Complex implementation | All tools | High |
| Bash Only | Terminal operations | Bash | Medium |

## Read-Only Patterns

### Basic Exploration
```yaml
tools:
  - Read
  - Grep
  - Glob
```
**Use for:** Codebase analysis, pattern finding, code review

### Research with Web
```yaml
tools:
  - Read
  - Grep
  - Glob
  - WebSearch
  - WebFetch
```
**Use for:** Documentation research, API exploration, best practices lookup

## Testing Patterns

### Test Execution
```yaml
tools:
  - Bash
  - Read
  - Grep
  - Glob
```
**Use for:** Running tests, analyzing results, debugging failures

### Build Validation
```yaml
tools:
  - Bash
  - Read
```
**Use for:** Linting, type checking, build verification

## Modification Patterns

### Code Changes
```yaml
tools:
  - Read
  - Edit
  - Write
  - Grep
  - Glob
```
**Use for:** Implementing features, fixing bugs, refactoring

### Full Implementation
```yaml
tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
```
**Use for:** Complex features requiring code + command execution

### Full Access with Web
```yaml
tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
  - WebSearch
  - WebFetch
```
**Use for:** Tasks requiring documentation lookup during implementation

## Terminal Patterns

### Bash Only
```yaml
tools:
  - Bash
```
**Use for:** Script execution, system commands, DevOps tasks

### Bash with Read
```yaml
tools:
  - Bash
  - Read
```
**Use for:** Commands that need to reference file contents

## MCP Integration Patterns

### GitHub Operations
```yaml
tools:
  - Read
  - Grep
  - Glob
  - mcp__github__list_issues
  - mcp__github__issue_read
  - mcp__github__create_pull_request
  - mcp__github__pull_request_read
```
**Use for:** Issue tracking, PR creation, repository management

### Slack Notifications
```yaml
tools:
  - Read
  - mcp__claude_ai_Slack__slack_send_message
  - mcp__claude_ai_Slack__slack_read_channel
```
**Use for:** Sending status updates, reading channel context

### Browser Automation
```yaml
tools:
  - mcp__chrome-devtools__navigate_page
  - mcp__chrome-devtools__take_screenshot
  - mcp__chrome-devtools__click
  - mcp__chrome-devtools__fill
```
**Use for:** UI testing, visual verification, form automation

## Tool Risk Levels

| Tool | Risk Level | Reason |
|------|------------|--------|
| Read | Low | Only reads files |
| Grep | Low | Only searches content |
| Glob | Low | Only finds file paths |
| WebSearch | Low | Read-only web search |
| WebFetch | Low | Read-only URL fetch |
| Bash | Medium | Can execute any command |
| Edit | Medium | Modifies existing files |
| Write | High | Can create/overwrite files |
| AskUserQuestion | Low | Only prompts user |

## Selection Guidelines

### Start Minimal
Begin with the smallest set of tools needed:
1. Start with Read, Grep, Glob
2. Add Bash if commands needed
3. Add Edit/Write if modifications needed
4. Add MCP tools for specific integrations

### Match Task Requirements
| If the task involves... | Include these tools |
|-------------------------|---------------------|
| Understanding code | Read, Grep, Glob |
| Running commands | Bash |
| Making changes | Edit, Write |
| Searching web | WebSearch, WebFetch |
| GitHub operations | mcp__github__* |
| Slack messaging | mcp__claude_ai_Slack__* |

### Avoid Over-Permissioning
- Don't give Write access for read-only tasks
- Don't include Bash if no commands needed
- Don't include MCP tools unless specifically required

# Sub-agent Configuration Checklist

Verify before creating the sub-agent configuration.

## Required Fields

### Name
- [ ] Lowercase only (no uppercase letters)
- [ ] Kebab-case format (words separated by hyphens)
- [ ] No spaces, underscores, or special characters
- [ ] Does not start or end with hyphen
- [ ] No consecutive hyphens (--)
- [ ] Length: 1-64 characters
- [ ] Unique within target scope (project or user)

### Description
- [ ] Length: 1-1024 characters
- [ ] Starts with what the agent handles
- [ ] Includes trigger conditions ("Use when...")
- [ ] Contains relevant keywords for matching
- [ ] Specific enough for proper routing

### Prompt
- [ ] Defines clear role ("You are a...")
- [ ] Lists specific capabilities
- [ ] Includes constraints/boundaries
- [ ] Specifies output format (if needed)
- [ ] Length: Under 500 words (recommended)
- [ ] Not overly complex or repetitive

## Optional Fields

### Model
- [ ] Appropriate for task complexity
  - [ ] haiku: Simple, fast, read-only tasks
  - [ ] sonnet: Balanced, most implementation tasks
  - [ ] opus: Complex reasoning, architecture decisions
- [ ] Or omitted to inherit from parent

### Tools
- [ ] Only necessary tools included
- [ ] Matches task requirements:
  - [ ] Read-only: Read, Grep, Glob
  - [ ] Testing: + Bash
  - [ ] Modification: + Edit, Write
  - [ ] Web: + WebSearch, WebFetch
  - [ ] MCP: + mcp__server__tool format
- [ ] Not over-permissioned

### Permission Mode
- [ ] Matches required access level:
  - [ ] plan: Read-only tasks
  - [ ] default: Standard interactive tasks
  - [ ] acceptEdits: Trusted file modifications
  - [ ] dontAsk: Automated pipelines (use carefully)
  - [ ] bypassPermissions: Full automation (use with caution)
- [ ] Not more permissive than needed

### Skills
- [ ] Preloaded skills are always relevant to this agent
- [ ] Skills exist and are accessible
- [ ] Not overloaded with too many skills

## Security Review

### Tool Access
- [ ] No unnecessary Write/Edit access for read-only agents
- [ ] Bash access justified by task requirements
- [ ] MCP tools limited to what's actually needed

### Permission Escalation
- [ ] bypassPermissions only if absolutely required
- [ ] dontAsk only for controlled environments
- [ ] acceptEdits only for trusted automation

### Sensitive Data
- [ ] No secrets or credentials in prompt
- [ ] No sensitive file paths exposed
- [ ] No production endpoints hardcoded

## File Verification

### Format
- [ ] YAML (.yaml) or Markdown (.md) extension
- [ ] Valid YAML/frontmatter syntax
- [ ] Multi-line strings use `|` properly

### Location
- [ ] Correct target directory:
  - [ ] Project: `.claude/agents/[name].yaml`
  - [ ] Personal: `~/.claude/agents/[name].yaml`
- [ ] Directory exists or will be created

### Conflicts
- [ ] No existing file with same name in target location
- [ ] Does not shadow a built-in agent name

## Skills & MCP Verification

### Skills
- [ ] Preloaded skills are installed/available
- [ ] Skill names are spelled correctly
- [ ] Skills are relevant to agent's purpose

### MCP Tools
- [ ] MCP server is configured and running
- [ ] Tool names follow `mcp__server__tool` format
- [ ] Required authentication is in place
- [ ] Tools are appropriate for the task

## Final Verification

### User Confirmation
- [ ] User has reviewed the configuration summary
- [ ] User has approved the settings
- [ ] User has confirmed file location

### Documentation
- [ ] Description clearly explains when to use
- [ ] Prompt is understandable to reviewers
- [ ] Configuration matches stated purpose

---

## Quick Pass/Fail

| Category | Status |
|----------|--------|
| Required fields complete | [ ] |
| Model appropriate | [ ] |
| Tools minimal | [ ] |
| Permissions justified | [ ] |
| Security reviewed | [ ] |
| User confirmed | [ ] |

**Ready to create:** All boxes checked above.

# Permission Modes Reference

Understanding sub-agent permission modes.

## Available Modes

### plan

Read-only mode. No modifications allowed.

| Property | Value |
|----------|-------|
| File Writes | Blocked |
| File Edits | Blocked |
| Bash Commands | Read-only |
| Risk Level | Lowest |

**Behavior:**
- Cannot write, edit, or delete files
- Cannot execute modifying commands
- Perfect for exploration and analysis
- Safest option for research tasks

**Use when:**
- Exploring unfamiliar codebases
- Analyzing code without changes
- Research and discovery phases
- You want guaranteed no side effects

**Example:**
```yaml
name: explorer
permissionMode: plan
tools:
  - Read
  - Grep
  - Glob
```

### default

Standard permission behavior with prompts.

| Property | Value |
|----------|-------|
| File Writes | Prompted |
| File Edits | Prompted |
| Bash Commands | Prompted |
| Risk Level | Low |

**Behavior:**
- File modifications require user approval
- Bash commands require approval
- User maintains control over all changes
- Standard interactive workflow

**Use when:**
- Normal development tasks
- You want oversight on changes
- Running tests that may have side effects
- Default choice for most sub-agents

**Example:**
```yaml
name: developer
permissionMode: default
tools:
  - Read
  - Edit
  - Write
  - Bash
```

### acceptEdits

Automatically accepts file modifications.

| Property | Value |
|----------|-------|
| File Writes | Auto-accepted |
| File Edits | Auto-accepted |
| Bash Commands | Prompted |
| Risk Level | Medium |

**Behavior:**
- File edits proceed without confirmation
- File writes proceed without confirmation
- Bash commands still prompt
- Faster workflow for trusted tasks

**Use when:**
- Sub-agent is trusted for code changes
- Implementing well-defined features
- Automated refactoring tasks
- Speed matters more than oversight

**Example:**
```yaml
name: implementer
permissionMode: acceptEdits
tools:
  - Read
  - Edit
  - Write
  - Grep
  - Glob
```

### dontAsk

Skips most confirmation prompts.

| Property | Value |
|----------|-------|
| File Writes | Auto-accepted |
| File Edits | Auto-accepted |
| Bash Commands | Auto-accepted |
| Risk Level | High |

**Behavior:**
- Most operations proceed without asking
- Minimal user interaction
- Fast but less safe
- Use carefully in controlled environments

**Use when:**
- Fully automated pipelines
- Controlled CI/CD environments
- Tasks with well-defined scope
- Speed is critical

**Example:**
```yaml
name: ci-runner
permissionMode: dontAsk
tools:
  - Bash
  - Read
```

### bypassPermissions

Full access without any permission checks.

| Property | Value |
|----------|-------|
| File Writes | Unrestricted |
| File Edits | Unrestricted |
| Bash Commands | Unrestricted |
| Risk Level | Highest |

**Behavior:**
- All operations proceed immediately
- No safety prompts
- Maximum speed
- Use only in fully trusted scenarios

**Use when:**
- Fully trusted automation
- Isolated sandbox environments
- No risk of unintended changes
- You accept all responsibility

**Example:**
```yaml
name: automation
permissionMode: bypassPermissions
tools:
  - Read
  - Write
  - Edit
  - Bash
```

## Mode Comparison

| Mode | Files | Bash | User Interaction | Speed |
|------|-------|------|------------------|-------|
| plan | Blocked | Read-only | None | Fast |
| default | Prompted | Prompted | High | Slow |
| acceptEdits | Auto | Prompted | Medium | Medium |
| dontAsk | Auto | Auto | Low | Fast |
| bypassPermissions | Auto | Auto | None | Fastest |

## Recommendations by Scenario

| Scenario | Recommended Mode |
|----------|------------------|
| Code exploration | plan |
| Research and analysis | plan |
| Testing (read logs) | plan |
| Testing (run tests) | default |
| Feature implementation | default or acceptEdits |
| Bug fixes | default |
| Code review | plan |
| Automated pipelines | acceptEdits or dontAsk |
| Trusted automation | bypassPermissions |
| Unfamiliar codebase | plan |
| Production changes | default |

## Security Considerations

### Principle of Least Privilege
Always use the most restrictive mode that allows the task:
1. Start with `plan` for exploration
2. Use `default` for interactive work
3. Only escalate when necessary

### Risk Escalation
```
plan → default → acceptEdits → dontAsk → bypassPermissions
 ↑                                                      ↑
Safest                                              Most risky
```

### When to Avoid High-Permission Modes

Avoid `dontAsk` and `bypassPermissions` when:
- Working with unfamiliar code
- The sub-agent has Bash access
- Modifications could affect production
- You haven't reviewed the prompt carefully
- The task scope is unclear

### Audit Recommendations

For high-permission sub-agents:
- Review the prompt carefully
- Limit tools to only what's needed
- Consider adding hooks for validation
- Test in isolated environments first
- Monitor sub-agent actions

## Mode + Tool Combinations

| Use Case | Mode | Tools | Safety |
|----------|------|-------|--------|
| Safe exploration | plan | Read, Grep, Glob | High |
| Interactive development | default | All | Medium |
| Trusted implementation | acceptEdits | Edit, Write | Medium |
| Automated testing | dontAsk | Bash, Read | Low |
| Full automation | bypassPermissions | All | Lowest |

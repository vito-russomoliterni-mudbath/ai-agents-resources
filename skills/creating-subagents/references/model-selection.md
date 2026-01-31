# Model Selection Guide

Choosing the right model for your sub-agent.

## Model Comparison

| Model | Speed | Cost | Capability | Context |
|-------|-------|------|------------|---------|
| haiku | Fastest | Lowest | Good for simple tasks | Smaller |
| sonnet | Balanced | Medium | Strong reasoning | Standard |
| opus | Slower | Highest | Strongest reasoning | Largest |

## Decision Tree

```
What is the task complexity?
│
├─ Simple, repetitive tasks
│   └─ Use haiku
│       Examples: file search, pattern matching, simple extraction
│
├─ Moderate reasoning needed
│   └─ Use sonnet
│       Examples: implementation, testing, code review, debugging
│
├─ Complex decisions required
│   └─ Use opus
│       Examples: architecture design, security analysis, optimization
│
└─ Unsure or need consistency
    └─ Omit model field (inherit from parent)
```

## Recommendations by Task Type

### haiku (fast, cheap)

Best for:
- Codebase exploration and file search
- Pattern matching and text extraction
- Simple data transformation
- Quick summaries and reports
- Read-only analysis tasks

**Example use cases:**
- "Find all files containing X"
- "List the functions in this module"
- "Summarize the structure of this directory"
- "Extract all imports from these files"

**Configuration:**
```yaml
model: haiku
permissionMode: plan  # Often paired with read-only
tools:
  - Read
  - Grep
  - Glob
```

### sonnet (balanced)

Best for:
- Feature implementation
- Bug fixing and debugging
- Code review and quality checks
- Test writing and execution
- Documentation generation
- Most development tasks

**Example use cases:**
- "Implement this feature"
- "Fix this bug"
- "Review this PR for issues"
- "Write tests for this function"
- "Refactor this module"

**Configuration:**
```yaml
model: sonnet
permissionMode: default  # Or acceptEdits for trusted automation
tools:
  - Read
  - Edit
  - Write
  - Grep
  - Glob
  - Bash
```

### opus (powerful)

Best for:
- Architecture and design decisions
- Complex refactoring across many files
- Security vulnerability analysis
- Performance optimization strategies
- Multi-step reasoning with trade-offs
- Critical decision-making

**Example use cases:**
- "Design the authentication system"
- "Analyze this codebase for security issues"
- "Plan the migration strategy"
- "Optimize the database queries"
- "Evaluate these architectural approaches"

**Configuration:**
```yaml
model: opus
# Often used with full access for complex tasks
tools:
  - Read
  - Edit
  - Write
  - Grep
  - Glob
  - Bash
  - WebSearch
```

## Inherit Model

Omit the `model` field to inherit from the parent agent.

**When to inherit:**
- You want consistency with the main conversation
- The sub-agent is an extension of current work
- You're unsure which model to use
- The task complexity varies

**Example:**
```yaml
name: helper
description: General helper for current task
# model: omitted - inherits from parent
tools:
  - Read
  - Grep
  - Glob
```

## Cost vs Capability Trade-offs

| Priority | Choose | Trade-off |
|----------|--------|-----------|
| Speed | haiku | Less capable for complex reasoning |
| Balance | sonnet | Good default, moderate cost |
| Quality | opus | Slower, more expensive |
| Consistency | inherit | Matches parent but may be overkill |

## Model + Permission Mode Combinations

| Scenario | Model | Permission Mode |
|----------|-------|-----------------|
| Quick exploration | haiku | plan |
| Safe testing | sonnet | default |
| Trusted implementation | sonnet | acceptEdits |
| Critical architecture | opus | default |
| Automated pipeline | sonnet | bypassPermissions |

## Common Mistakes

### Using opus for simple tasks
```yaml
# Wrong - opus is overkill for file search
model: opus
tools:
  - Read
  - Grep

# Right - haiku is sufficient
model: haiku
tools:
  - Read
  - Grep
```

### Using haiku for complex implementation
```yaml
# Wrong - haiku may struggle with complex logic
model: haiku
tools:
  - Read
  - Edit
  - Write

# Right - sonnet handles implementation well
model: sonnet
tools:
  - Read
  - Edit
  - Write
```

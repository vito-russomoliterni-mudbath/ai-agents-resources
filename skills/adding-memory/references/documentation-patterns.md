# Documentation Patterns

Consistent approaches for different types of project knowledge.

## Pattern 1: Code Convention Entry

**Structure**:
```markdown
### [Convention Name]

**Rule**: [What the rule is]

**Why**: [Reasoning]

**Example**:
[Code showing correct approach]

**Don't**:
[Code showing wrong approach]

**Scope**: [Where this applies]
```

## Pattern 2: Architecture Decision

**Structure**:
```markdown
### [Decision Title]

**Context**: [Problem we faced]

**Decision**: [What we decided and why]

**Consequences**:
- [Positive outcome]
- [Trade-off]

**Alternatives Considered**:
- [Alternative 1]
- [Alternative 2]
```

## Pattern 3: Process/Workflow

**Structure**:
```markdown
### [Process Name]

**When to Use**: [When this applies]

**Prerequisites**: [What must be true first]

**Steps**:
1. [First step]
2. [Second step]
3. [Verify]

**Troubleshooting**:
- [Issue and solution]
```

## Pattern 4: Performance Consideration

**Structure**:
```markdown
### [Optimization Title]

**Situation**: [When this matters]

**The Optimization**: [What to do]

**Performance Impact**:
- Before: [Measurement]
- After: [Measurement]

**Implementation**:
[Code example]

**When NOT to use**: [When this might not help]
```

## Pattern 5: Best Practice/Pattern

**Structure**:
```markdown
### [Pattern Name]

**Use For**: [What situations benefit]

**The Pattern**:
[Description]

**Example**:
[Code example]

**Benefits**:
- [Benefit 1]

**Trade-offs**:
- [Trade-off 1]
```

## Pattern 6: Gotcha/Caution

**Structure**:
```markdown
### [Gotcha Title]

**The Problem**: [What goes wrong]

**Why It Happens**: [Root cause]

**Example of Wrong Way**:
[Code]

**The Right Way**:
[Code]

**How to Avoid**: [Prevention]
```

## Pattern 7: Tool/Library Note

**Structure**:
```markdown
### [Tool Name]

**Version**: [Current version]

**Purpose**: [What it does]

**Key Settings**: [Important configuration]

**Common Issues**:
- [Issue and solution]

**Alternatives**: [Other tools]
```

## Pattern 8: Configuration/Setup

**Structure**:
```markdown
### [Setup Task]

**Prerequisites**: [What must be true first]

**Steps**:
1. [First step]
2. [Verify]

**Configuration File**: [Path and example]

**Environment Variables**:
- `VARIABLE_NAME`: [What it does]

**Verification**: [How to test]

**Troubleshooting**:
- [Error and fix]
```

## Choosing the Right Pattern

| Knowledge Type | Best Pattern | Location |
|---|---|---|
| "Always do X" | Code Convention | Project CLAUDE.md |
| "We use Y because..." | Architecture Decision | Project CLAUDE.md |
| "Steps to do Z" | Process/Workflow | CLAUDE.md or docs/guides |
| "Fast vs Slow" | Performance Consideration | CLAUDE.md |
| "Use this pattern" | Best Practice | CLAUDE.md |
| "Watch out for..." | Gotcha/Caution | CLAUDE.md |
| "About Tool X" | Tool/Library Note | CLAUDE.md |
| "How to set up X" | Configuration/Setup | docs/setup or CLAUDE.md |

## Formatting Tips

**Consistent Markdown**:
- Use ### for subsections in CLAUDE.md
- Use **bold** for emphasis, `code` for inline code
- Use code blocks with language specified
- Keep code samples concise

**Examples**:
- Show both correct and incorrect examples
- Include realistic scenarios
- Add helpful comments
- Keep to 5-10 lines

**Linking**:
- Link to related sections: `[pattern](../file.md)`
- Cross-reference within file: `[see below](#section-name)`
- Keep links relative to repo structure

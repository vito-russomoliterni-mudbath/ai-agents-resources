# Memory Entry Template

Use this template when adding new knowledge to CLAUDE.md or documentation.

## Generic Entry Template

```markdown
### [Clear, Descriptive Title]

**Context**: [When/why this matters, what problem it solves]

**The Guideline/Pattern**:
[Clear statement of what to do]

**Example**:
[Code or concrete example showing correct approach]

**Why**: [Benefits, reasoning, consequences of following]

**When NOT to use**: [Exceptions or edge cases]

**See also**:
- [Related entry 1]
- [Related entry 2]
```

## Type-Specific Templates

### Code Convention Entry

```markdown
### [Convention Name]

**Rule**: [What the rule is]

**Example**:
```javascript
// GOOD
const userName = getUserName();

// BAD
const x = getUserName();
```

**Why**: [Benefits - readability, consistency, performance, etc.]

**Enforced by**: [ESLint rule, IDE warning, code review]

**Scope**: [Entire codebase / TypeScript only / React only / etc.]
```

### Architectural Decision

```markdown
### [Decision Title]

**Context**: [Problem we solved]

**Decision**: [What we decided]

**Reasoning**: [Why this approach]

**Trade-offs**:
- Benefit: [Positive consequence]
- Cost: [Limitation or trade-off]

**Alternatives Considered**:
- [Alternative]: Why we didn't choose it

**When to Revisit**: [Under what conditions]
```

### Best Practice

```markdown
### [Practice Name]

**When to use**: [What situations]

**How to do it**:
```
[Example code]
```

**Benefits**:
- [Benefit 1]
- [Benefit 2]

**Related practices**:
- [Related pattern]
```

### Performance Optimization

```markdown
### [Optimization Title]

**Context**: [Why this matters - scale, frequency, impact]

**What to do**: [The optimization]

**Before**: 50ms per request
**After**: 5ms per request
**Improvement**: 10x faster

**Example**:
```
[Code showing optimization]
```

**Trade-offs**: [Any downsides]

**When NOT to use**: [When to skip this]
```

### Common Gotcha

```markdown
### [Gotcha Title]

**Problem**: [What goes wrong]

**Why it happens**: [Root cause]

**Wrong way**:
```
[Code with problem]
```

**Right way**:
```
[Corrected code]
```

**Prevention**: [How to avoid]
```

### Tool/Library Note

```markdown
### [Tool Name]

**Purpose**: [What it does]

**Current version**: 2.1.0

**Key configuration**:
```
[Config example]
```

**Common gotchas**:
- [Issue]: [Solution]

**When to use**: [Best applications]

**When NOT to use**: [Wrong use cases]

**Alternatives**: [Other tools]
```

## Entry Quality Checklist

Before adding or updating an entry, verify:

### Clarity
- [ ] Title clearly describes the topic
- [ ] Someone unfamiliar would understand
- [ ] No jargon without explanation
- [ ] One clear idea per entry

### Completeness
- [ ] Explains WHAT to do
- [ ] Explains WHY to do it
- [ ] Shows concrete example
- [ ] Mentions exceptions/edge cases

### Currency
- [ ] Reflects current actual practice
- [ ] Tool versions correct
- [ ] Links valid
- [ ] Not superseded by other entry

### Organization
- [ ] Fits logically in document structure
- [ ] Doesn't duplicate existing entry
- [ ] Cross-references related entries
- [ ] Uses consistent formatting

### Specificity
- [ ] Specific to this project/scope
- [ ] Not generic advice
- [ ] Actionable (not "write good code")
- [ ] Testable/verifiable

## Entry Length Guidelines

**Too short**: Single sentence
- Fix: Add why it matters, example, context

**Too long**: Multiple paragraphs on single topic
- Fix: Break into multiple entries or move to structured docs

**Sweet spot**: 100-300 words
- Clear statement of practice/guideline
- Why it matters
- Concrete example
- When it applies/when it doesn't

## Tone and Style

Use:
- Clear, imperative statements: "Always use async/await"
- Active voice: "Cache database queries" not "Queries should be cached"
- Specific: "Use Redux for global state" not "Use a state manager"
- Professional but not stuffy

Avoid:
- Vague advice: "Write clean code"
- Passive voice: "It is recommended that..."
- Tentative language: "You might consider..."
- Generic best practices: "Follow industry standards"

## Example: Converting Understanding to Memory Entry

### Starting Point
"During code review, I noticed everyone uses async/await but there's inconsistency in error handling. Should document this."

### Entry

```markdown
### Async/Await Error Handling

**Rule**: All async operations must use try/catch for errors.

**Example**:
```javascript
// GOOD
async function fetchUser(id) {
  try {
    const response = await fetch(`/api/users/${id}`);
    return response.json();
  } catch (error) {
    logger.error('Failed to fetch user', { id, error });
    throw new UserNotFoundError(id);
  }
}

// BAD - no error handling
async function fetchUser(id) {
  const response = await fetch(`/api/users/${id}`);
  return response.json();
}
```

**Why**: Without try/catch, errors silently propagate as unhandled promise rejections. Explicit error handling enables:
- Logging for debugging
- User-friendly error messages
- Graceful fallbacks

**When NOT needed**: Only skip when calling code explicitly handles rejection (rare).

**Enforced by**: Code review, consider ESLint rule

**See also**: Error Handling Strategy, Logging Patterns
```

### What This Accomplished

- Captured pattern observed in code review
- Made it explicit and actionable
- Provided clear good/bad examples
- Explained the reasoning
- Left room for exceptions
- Created searchable documentation

## Adding Your First Entry

1. **Identify**: What pattern/guideline should be remembered?
2. **Scope**: Personal, project, or module CLAUDE.md?
3. **Format**: Choose template that fits best
4. **Example**: Include concrete code or scenario
5. **Review**: Does it add value? Is it specific to this project?
6. **Place**: Put in right section/file
7. **Link**: Cross-reference related entries
8. **Commit**: Git commit with clear message

## Agent Skills Specification Reference

### Required Frontmatter Fields

**`name`** (required)
- Type: String
- Format: Lowercase kebab-case
- Rules:
  - Cannot start with hyphen
  - No consecutive hyphens
  - No uppercase letters
- Examples: `pdf-processing`, `data-analysis`, `code-review`

**`description`** (required)
- Type: String
- Length: 1-1024 characters
- Purpose: Clear explanation with keywords
- Style: Third person, present tense
- Should include: What it does + When to use it

### Optional Frontmatter Fields

**`license`** (optional)
- Type: String
- Purpose: Specify licensing terms
- Examples: `MIT`, `Apache-2.0`, `See LICENSE.txt`

**`compatibility`** (optional)
- Type: String
- Length: 1-500 characters
- Purpose: Environmental requirements
- When to use: Only if skill has specific requirements
- Example: `Requires Docker and network access for container operations`

**`metadata`** (optional)
- Type: Object (key-value pairs)
- Purpose: Custom properties not in spec
- Common uses: author, version, tags, etc.
- Example:
  ```yaml
  metadata:
    author: example-org
    version: "1.0"
    category: data-processing
  ```

### Progressive Disclosure

Skills use a three-tier loading model:

1. **Metadata** (~100 tokens): `name` and `description` loaded at agent startup
2. **Instructions** (< 5000 tokens): Full `SKILL.md` loaded when skill activated
3. **Resources** (as needed): Files in `scripts/`, `references/`, `assets/` loaded on demand

**Best practices:**
- Keep SKILL.md under 500 lines
- Move detailed material to `references/`
- Link to resources with relative paths
- Avoid deep nesting of references

## Common Naming Patterns

### Gerund/Present Participle (Recommended)
Describes ongoing actions, commonly used in the ecosystem:

| Pattern | Example | Use Case |
|---------|---------|----------|
| `[action]-ing-[object]` | `processing-data` | Data transformation workflows |
| `[action]-ing-[object]` | `analyzing-code` | Code review and analysis |
| `[action]-ing-[object]` | `fixing-bugs` | Debugging and repair |
| `[action]-ing-[object]` | `building-features` | Feature development |
| `[action]-ing-[object]` | `testing-code` | Test execution and validation |

### Noun-Object (Valid Alternative)
Meets specification but less common:

| Pattern | Example | Use Case |
|---------|---------|----------|
| `[object]-[action]` | `pdf-processing` | Valid, widely used |
| `[object]-[tool]` | `data-analyzer` | Valid but less descriptive of action |
| `[object]-[purpose]` | `code-review` | Valid, commonly seen |

### Invalid Patterns
Violate Agent Skills specification:

| Pattern | Example | Issue |
|---------|---------|-------|
| Uppercase | `PDF-Processing` | Must be lowercase |
| Starts with hyphen | `-pdf-processing` | Cannot start with hyphen |
| Consecutive hyphens | `pdf--processing` | No consecutive hyphens |
| Spaces | `pdf processing` | Must use hyphens |

## Name Suggestion Process

When generating name suggestions, prioritize:

1. **Specification compliance** (required)
2. **Gerund form** (recommended best practice)
3. **Clarity** (immediately understandable)
4. **Brevity** (2-3 words ideal)
5. **Uniqueness** (distinct from existing skills)

**Example suggestion generation:**

User describes: "A skill for running unit tests automatically"

**Analysis:**
- Action: running/executing tests
- Object: tests/code
- Purpose: automation/validation

**Suggestions:**
1. `running-tests` (gerund, emphasizes execution)
2. `testing-code` (gerund, emphasizes validation)
3. `executing-tests` (gerund, formal tone)
4. `test-runner` (noun-object, valid but less recommended)

Present with rationale, let user choose.

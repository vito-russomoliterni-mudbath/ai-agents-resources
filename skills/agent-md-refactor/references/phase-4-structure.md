# Phase 4: File Structure and Organization

Consistent structure within and across files makes instructions easy to scan, update, and follow. This phase establishes naming conventions, directory layout, and internal organization patterns.

## Directory Structure

### Standard Layout

```
project_root/
├── CLAUDE.md                    # Root instructions file
└── .claude/                     # Detailed instruction files
    ├── typescript.md            # Language/framework files
    ├── react.md
    ├── python.md
    ├── testing.md               # Concern-based files
    ├── git-workflow.md
    ├── api-design.md
    ├── deployment.md
    └── architecture.md
```

### Alternative: Organized Subdirectories

For larger projects with many files:

```
project_root/
├── CLAUDE.md
└── .claude/
    ├── guides/                  # Grouped by category
    │   ├── languages.md
    │   ├── frameworks.md
    │   └── tools.md
    ├── standards/
    │   ├── code-style.md
    │   ├── testing.md
    │   └── git-workflow.md
    ├── architecture/
    │   ├── project-structure.md
    │   ├── patterns.md
    │   └── design-decisions.md
    ├── deployment/
    │   ├── local-setup.md
    │   ├── ci-cd.md
    │   └── production.md
    └── README.md                # Index of all files
```

### Guidelines for Structure

**Use flat structure when:**
- 3-8 files total (easy to scan)
- Clear file names (no need for grouping)
- No obvious category divisions
- All files are similar importance

**Use subdirectories when:**
- 8+ files (hard to navigate)
- Natural category divisions
- Different audiences (ops, dev, frontend)
- Varying importance levels

**Avoid:**
- Deep nesting (more than 1-2 levels)
- Single files per subdirectory
- Mixing organizational schemes

## Filename Conventions

### Format
`<topic>[-<subtopic>].md`

### Rules

**Always use:**
- Lowercase letters
- Hyphens for word separation (not spaces, underscores)
- `.md` extension
- Descriptive, single noun where possible

**Examples - Good:**
```
typescript.md           # Specific language
react.md                # Specific framework
testing.md              # Single concern
api-design.md           # Topic + subtopic
git-workflow.md         # Specific workflow
code-style.md           # Specific concern
```

**Examples - Bad:**
```
TS_Guidelines.md        # Wrong case, punctuation
typescript-conventions-and-best-practices.md  # Too long
ts.md                   # Too abbreviated
testing-and-code-quality.md                   # Two topics
guidelines.md           # Too vague
dev-guide.md            # Still vague
standards-v2.md         # Version in name
```

### Special Files

```
CLAUDE.md               # Root instructions (required, uppercase)
README.md               # Directory index (if using subdirs)
.claude/README.md       # Index of .claude/ files (if needed)
```

### Project Type Naming Patterns

**Python Project:**
```
python.md               # Core Python rules
testing.md              # Pytest/unittest
database.md             # ORM/SQL patterns
git-workflow.md
deployment.md
```

**React Project:**
```
typescript.md           # Type safety rules
react.md                # Component patterns
testing.md              # Vitest/Jest rules
api-design.md           # API consumption
git-workflow.md
deployment.md
```

**.NET Project:**
```
csharp.md               # C# specifics
api-design.md           # API patterns
database.md             # EF Core patterns
testing.md              # xUnit/Mocha
git-workflow.md
deployment.md
```

## Internal File Structure

### Standard Template

```markdown
# [Topic Name]

## Overview
1-2 sentences explaining what this file covers and when to apply it.

## [Section 1]

### Subsection
Content with specific rules, not general advice.

### Good/Bad Examples
```language
// Good
code example

// Bad
code example
```

## [Section 2]
...

## See Also
- [Related File](../related-file.md) - Why to read this
- [External Link](https://example.com) - Additional context
```

### Section Organization

**Standard pattern:**
1. Overview
2. Rules (organized by concern)
3. Examples (good vs bad)
4. See Also

**Length:** 100-300 lines per file

### Overview Section

**Purpose:** Help agent/user know if they should read this file

**Template:**
```markdown
## Overview

This file covers [specific topic]. Use these guidelines when:
- Working on [file type/component type]
- Implementing [feature type]
- Setting up [thing]

Does NOT cover:
- [Related topic that goes elsewhere]
- [Common confusion point]
```

**Examples:**

TypeScript file:
```markdown
## Overview

TypeScript conventions for this project. Applies to all .ts and .tsx files.
Does NOT cover:
- React component patterns (see react.md)
- Testing setup (see testing.md)
```

Testing file:
```markdown
## Overview

Testing setup and patterns using Vitest. Covers unit tests, integration
tests, and test configuration. Does NOT cover:
- E2E testing (see e2e-testing.md)
- API mocking library details (covered in testing.md)
```

### Rules Section

**Pattern:**
```markdown
## [Rule Category]

### Specific Rule Name
- Actionable statement
- Evidence or reasoning
- Code example if helpful

### Another Rule
- Actionable statement
```

**Good example:**
```markdown
## Type Safety

### Enable Strict Mode
Set `strict: true` in tsconfig.json. This catches common errors at compile time.

### No Implicit Any
Function parameters and return types must have explicit types.

```typescript
// Good
function add(a: number, b: number): number {
  return a + b;
}

// Bad
function add(a, b) {
  return a + b;
}
```

### Prefer Interfaces for Objects
Use interfaces for object contracts; use types for unions and utility types.

```typescript
// Good
interface User {
  id: number;
  name: string;
}

// Bad
type User = {
  id: number;
  name: string;
};
```
```

**Bad example:**
```markdown
## Guidelines

Write clean code and use best practices. Use TypeScript properly.
Follow conventions. Types are important.
```

### Examples Section

**Pattern:**
```markdown
## Examples

### Good: [Description]
```
code showing right approach
```

### Avoid: [Description]
```
code showing wrong approach
```
```

**Full example:**
```markdown
## Examples

### Good: Strict null checking
```typescript
interface User {
  id: number;
  name: string;
}

function displayUser(user: User | null) {
  if (user === null) {
    return "No user";
  }
  return user.name;
}
```

### Avoid: Loose null handling
```typescript
function displayUser(user) {
  return user.name;  // Crashes if null
}
```
```

### See Also Section

**Purpose:** Help agent find related information

**Pattern:**
```markdown
## See Also

- [Related File](path/to/file.md) - Why/when to read this
- [External Resource](url) - Additional context
```

**Examples:**
```markdown
## See Also

- [React Patterns](react.md) - React-specific type handling
- [Testing](testing.md) - Testing type safety
- [TypeScript Handbook - Advanced Types](https://www.typescriptlang.org/docs/handbook/2/types-from-types.html)
```

## Content Organization Within Sections

### Lists vs Paragraphs

**Use lists when:**
- Multiple independent items
- Quick reference format needed
- Each item stands alone

```markdown
### Variable Declaration Rules

- Use `const` by default
- Use `let` for loop variables
- Never use `var`
```

**Use paragraphs when:**
- Concept explanation needed
- Items relate to each other
- Context matters

```markdown
### Async/Await Pattern

Always use async/await instead of .then() chains. This makes code more
readable and easier to debug. If you need to run operations in parallel,
use Promise.all() inside the async function.
```

### Nesting Levels

Stick to 3 levels maximum:

```markdown
# File Title (Level 1)

## Section (Level 2)

### Subsection (Level 3)

#### Too deep ✗ (Level 4 - avoid)
```

### Emphasis Usage

**Markdown emphasis patterns:**
```markdown
**Bold** for important concepts, options, or terms
*Italic* for emphasis or alternative names
`Code` for exact syntax, commands, filenames
```

**Good:**
```markdown
Use **const** for variables that won't be reassigned.
Use *async/await* instead of promise chains.
Set `strict: true` in `tsconfig.json`.
```

**Bad:**
```markdown
Use const for variables.
Use async await instead.
Tsconfig needs strict mode.
```

## Example File Structure

### TypeScript File (120 lines)

```markdown
# TypeScript Conventions

## Overview

TypeScript conventions for this project. Applies to all .ts and .tsx files.

## Type Safety

### Enable Strict Mode
Set `strict: true` in tsconfig.json.

### No Implicit Any
All parameters and returns must have explicit types.

```typescript
// Good
function add(a: number, b: number): number {
  return a + b;
}

// Bad
function add(a, b) {
  return a + b;
}
```

### Prefer Interfaces for Objects
Use interfaces for object contracts.

```typescript
// Good
interface User {
  id: number;
  name: string;
}

// Bad
type User = {
  id: number;
  name: string;
};
```

## Null Handling

### Use Strict Null Checks
Always check for null explicitly.

```typescript
// Good
function displayName(user: User | null) {
  if (user === null) return "Anonymous";
  return user.name;
}

// Bad
function displayName(user: User) {
  return user.name;  // Crashes if null
}
```

## Generic Types

### Keep Generic Types Simple
Use named type parameters for clarity.

```typescript
// Good
interface Response<T> {
  data: T;
  error?: string;
}

// Avoid
interface Response<D> {
  data: D;
  error?: string;
}
```

## Examples

### Good: Complete Type Safety
```typescript
interface ApiResponse<T> {
  data: T;
  error?: string;
}

async function fetchUser(id: number): Promise<ApiResponse<User>> {
  try {
    const response = await fetch(`/api/users/${id}`);
    const data = await response.json();
    return { data };
  } catch (error) {
    return { data: null as any, error: String(error) };
  }
}
```

## See Also

- [React Patterns](react.md) - React-specific typing
- [Testing](testing.md) - Type testing approaches
```

## Verification Checklist

For overall structure:

- [ ] File naming is clear and follows pattern
- [ ] Directory structure is flat (< 10 files) or organized (2-level max)
- [ ] Each file has Overview, Rules, Examples, See Also
- [ ] No file is > 300 lines
- [ ] No file is < 80 lines
- [ ] All cross-references use relative paths
- [ ] Examples show Good vs Avoid/Bad patterns
- [ ] Code examples include language syntax highlighting
- [ ] No vague advice ("write clean code")
- [ ] Every rule is actionable

## Common Mistakes

### Mistake 1: No Overview Section
**Problem:** Agent/user doesn't know if they should read the file

**Fix:** Add Overview explaining scope and when to apply

### Mistake 2: Mixing Good and Bad Without Labels
```markdown
✗ function add(a: number): number {
  function add(a) {
```
**Fix:** Use comments or code blocks with labels
```markdown
✓ // Good
  function add(a: number): number {

  // Bad
  function add(a) {
```

### Mistake 3: Broken Cross-References
```markdown
See [Related](../wrong-path.md)  # Path doesn't exist
```
**Fix:** Use correct relative paths and verify links

### Mistake 4: Inconsistent Section Depth
```markdown
# File

## Section 1
#### Buried subsection ✗

## Section 2
### Subsection ✓
```
**Fix:** Keep heading levels consistent

### Mistake 5: No See Also Section
**Problem:** Readers can't find related guidance

**Fix:** Always include See Also with 2-3 related files

## See Also

- [Progressive Disclosure Principles](progressive-disclosure.md) - Why structure matters
- [Phase 3: Categorization](phase-3-categorization.md) - Creating files
- [Phase 5: Deletion](phase-5-deletion.md) - Cleaning up content

# Progressive Disclosure Principles

Progressive disclosure is a design pattern that presents only essential information upfront, with details available on demand. For agent instruction files, this reduces token usage and improves maintainability.

## Core Concept

**Root File = Table of Contents**
- Contains only universal, always-applicable information
- Provides links to specialized documentation
- Readable in < 1 minute
- Under 50 lines

**Linked Files = Detailed Guides**
- Topic-specific instructions
- Self-contained and complete
- Loaded only when relevant to the task
- Can be updated independently

## Benefits

### 1. Reduced Token Usage
- Agent only loads instructions relevant to current task
- Saves 80-90% of context tokens on typical tasks
- Example: Frontend task doesn't load backend instructions

### 2. Easier Maintenance
- Update one file without affecting others
- Add new categories without bloating root
- Remove outdated instructions easily
- Clear ownership of topics

### 3. Better Organization
- Related instructions grouped together
- Logical hierarchy
- Easy to find specific guidance
- Clear category boundaries

### 4. Improved Clarity
- Each file has single, focused purpose
- No mixing of unrelated topics
- Easier to understand and follow
- Less cognitive load

## When to Use

Use progressive disclosure for instruction files when:
- File is > 200 lines
- Contains multiple distinct topics (code style, testing, git, etc.)
- Token usage is a concern
- Multiple team members need to maintain it
- Instructions are being added frequently

## What Belongs in Root

### Always Include
- Project name and one-sentence description
- Package manager (if not npm/pip/default)
- Custom commands (non-standard scripts)
- Critical overrides (things that MUST override agent defaults)
- Links to all detailed instruction files

### Examples of Root Content

**Good:**
```markdown
# MyProject

Real-time analytics dashboard built with React and FastAPI.

## Commands
- `pnpm dev` - Start dev server (not npm!)
- `pnpm test` - Run tests with coverage
- `make migrate` - Run database migrations

## Guidelines
- [TypeScript Conventions](.claude/typescript.md)
- [Testing Guidelines](.claude/testing.md)
- [API Design](.claude/api-design.md)
```

**Bad (Too Much Detail):**
```markdown
# MyProject

## TypeScript Conventions
- Always use strict mode
- Prefer interfaces over types for objects
- Use const assertions for literal types
... (100 more lines)

## Testing
- Use Vitest for unit tests
- Coverage must be > 80%
... (50 more lines)
```

## What Belongs in Linked Files

### Topics for Linked Files
- **Language/Framework Conventions**: TypeScript, Python, React, etc.
- **Testing**: Framework setup, coverage, patterns
- **Code Style**: Formatting, naming, structure
- **Architecture**: Patterns, folder structure, dependencies
- **Git Workflow**: Commits, branches, PRs
- **API Design**: REST/GraphQL conventions
- **Security**: Auth, validation, secrets
- **Performance**: Optimization, caching
- **Deployment**: CI/CD, environments

### Structure of Linked Files

Each linked file should have:

1. **Overview**: Brief context for when these guidelines apply
2. **Rules**: Specific, actionable instructions organized by category
3. **Examples**: Good vs bad code examples
4. **See Also**: Links to related files (if needed)

**Example:**
```markdown
# TypeScript Conventions

## Overview
Guidelines for TypeScript code in this project. Applies to all .ts and .tsx files.

## Type Safety

### Always Use Strict Mode
- Enable `strict: true` in tsconfig.json
- No implicit any
- Strict null checks

### Prefer Interfaces for Objects
```typescript
// Good
interface User {
  id: number;
  name: string;
}

// Avoid
type User = {
  id: number;
  name: string;
}
```

### Use Const Assertions for Literals
```typescript
// Good
const STATUSES = ['pending', 'active', 'complete'] as const;

// Avoid
const STATUSES = ['pending', 'active', 'complete'];
```

## Examples

### Good: Type-Safe API Response
```typescript
interface ApiResponse<T> {
  data: T;
  error?: string;
}

async function fetchUser(id: number): Promise<ApiResponse<User>> {
  // Implementation
}
```

### Avoid: Loose Typing
```typescript
async function fetchUser(id: any): Promise<any> {
  // Implementation
}
```

## See Also
- [React Patterns](.claude/react.md) - Component typing
- [Testing](.claude/testing.md) - Type testing with Vitest
```

## Common Mistakes

### Mistake 1: Keeping Everything in Root
**Problem**: Defeats the purpose of progressive disclosure

**Solution**: Move all topic-specific content to linked files

### Mistake 2: Too Many Categories
**Problem**: 20+ files, hard to find the right one

**Solution**: Consolidate related topics (e.g., combine ESLint and Prettier into `code-style.md`)

### Mistake 3: Linked Files Not Self-Contained
**Problem**: File references undefined terms or requires reading other files

**Solution**: Each file should make sense independently

### Mistake 4: Vague Instructions
**Problem**: "Write clean code", "Follow best practices"

**Solution**: Delete or make specific: "Limit functions to 20 lines"

### Mistake 5: Duplicating Defaults
**Problem**: "Use descriptive variable names", "Don't commit secrets"

**Solution**: Delete - agent already knows these

## Migration Strategy

### Phase 1: Analyze (1 hour)
- Read entire instruction file
- Identify contradictions
- List all distinct topics

### Phase 2: Extract Essentials (30 min)
- Pull out root-worthy content
- Verify it's truly universal
- Draft minimal root file

### Phase 3: Categorize (1-2 hours)
- Group instructions by topic
- Create 3-8 logical categories
- Draft linked file outlines

### Phase 4: Write Files (2-3 hours)
- Create root file with links
- Write each linked file
- Add examples to each file

### Phase 5: Prune (1 hour)
- Remove vague/redundant instructions
- Verify all remaining content is actionable
- Get user confirmation on deletions

### Phase 6: Verify (30 min)
- Check all links work
- Verify root is < 50 lines
- Test by having agent read files

## Metrics for Success

After refactoring:
- **Root file**: < 50 lines
- **Linked files**: 3-8 files, each 50-300 lines
- **Coverage**: All original unique guidance preserved
- **Actionability**: Every instruction is specific and executable
- **Token savings**: 80-90% reduction for typical tasks

## Example: Before & After Metrics

### Before
- Single CLAUDE.md: 850 lines
- Token usage per task: ~3,000 tokens
- Maintenance: Difficult (find-in-page searches)
- Updates: Risky (may break other sections)

### After
- Root CLAUDE.md: 35 lines
- 5 linked files: 120-200 lines each
- Token usage per task: ~300-800 tokens (depending on relevance)
- Maintenance: Easy (edit specific file)
- Updates: Safe (isolated changes)

## See Also

- [Phase 2: Essential vs Linked](phase-2-essentials.md) - Deciding what goes where
- [Phase 3: Categorization](phase-3-categorization.md) - Grouping strategies
- [Root Template](../assets/root-template.md) - Minimal root file template

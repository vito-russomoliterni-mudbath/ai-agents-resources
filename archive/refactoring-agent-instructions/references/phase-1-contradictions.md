# Phase 1: Detecting and Resolving Contradictions

Contradictory instructions confuse the agent, waste tokens, and cause incorrect behavior. Phase 1 identifies conflicts and establishes a single source of truth.

## What Are Contradictions?

### Style Conflicts
Instructions that recommend opposite coding styles or conventions.

**Example:**
```markdown
# Conflict in TypeScript Guidelines

Location 1 (.claude/typescript.md):
"Use interfaces for all object types"

Location 2 (CLAUDE.md line 145):
"Use type aliases for better composability"

Location 3 (.claude/react.md):
"Component props: always use interfaces"
```

**Resolution:**
- Choose one standard (interfaces in this case)
- Document reasoning: "Interfaces are preferred because they support declaration merging and are more readable for object contracts"
- Update all files to use "interfaces"
- Add note explaining the decision

### Workflow Conflicts
Instructions that describe different processes or tool preferences.

**Example:**
```markdown
# Conflict in Git Workflow

In CLAUDE.md:
"Always use 'git rebase' for feature branches"

In .claude/git-workflow.md:
"Use 'git merge' to preserve branch history"

Result: Agent gets contradictory instructions about how to integrate code
```

**Resolution:**
- Interview user to understand actual preference
- Check git history to see what's actually used
- Document workflow with explicit cases (rebase for small features, merge for releases)
- Remove conflicting sections

### Tool Preference Conflicts
Instructions that specify different tools for the same task.

**Example:**
```markdown
# Conflict in Test Framework

Line 80: "Use Vitest for unit testing"
Line 240: "Use Jest for all tests"

Line 450: "Run tests with: npm test"
Line 320: "Run tests with: yarn test --watch"
```

**Resolution:**
- Determine primary tool (check package.json)
- Consolidate into one section
- Note if multiple tools serve different purposes (unit vs e2e)

### Configuration Contradictions
Different settings for same tool/language.

**Example:**
```markdown
# Conflict in TypeScript Config

Section 1:
"Set tsconfig.json: strict: false for faster development"

Section 2:
"Always use: strict: true"

Section 3:
"Set strict: true except in legacy modules"
```

**Resolution:**
- Consolidate into one rule with conditions
- Create environment-specific configs if needed
- Document trade-offs

## Detection Strategy

### 1. Automated Search (10 minutes)
Search for conflicting keywords:

```bash
# Search for contradictory patterns
grep -i "always\|never\|must\|don't\|avoid" CLAUDE.md | sort
grep -i "use\|prefer" CLAUDE.md | sort

# Look for opposite commands
grep -E "(eslint|prettier|formatting|style)" CLAUDE.md
grep -E "(test|jest|vitest|mocha)" CLAUDE.md
```

### 2. Manual Review (20 minutes)
Read through entire file looking for:
- Different descriptions of same feature
- Conflicting version requirements
- Multiple command options for same task
- Opposite recommendations

### 3. Check Linked Files (15 minutes)
If using progressive disclosure, search across all files:
- Root CLAUDE.md contradicting .claude/*.md
- Files contradicting each other
- Outdated examples in multiple places

### 4. Cross-Reference with Code (10 minutes)
Check actual project configuration:
```bash
cat package.json        # Check actual dependencies and scripts
cat tsconfig.json       # Check actual TypeScript config
cat .eslintrc           # Check actual linter config
cat pytest.ini          # Check actual test config
ls -la .git/config      # Check git config
```

## Resolution Strategies

### Strategy 1: Choose One Winner
When only one approach makes sense:

**Before:**
```markdown
## Code Formatting

Option A: "Use Prettier with 80 character line width"
Option B: "Use ESLint for all formatting"
```

**After:**
```markdown
## Code Formatting

Use Prettier for formatting (80 character line width).
ESLint is for linting only - disable formatting rules.
```

### Strategy 2: Context-Based Rules
When different contexts need different approaches:

**Before:**
```markdown
"Always use const"
"Use let for loop variables"
```

**After:**
```markdown
## Variable Declaration

- Use `const` by default
- Use `let` only for loop variables and when const would cause reassignments
- Never use `var`
```

### Strategy 3: Deprecation + Migration Path
When moving from old to new approach:

**Before:**
```markdown
Section 1: "Use class-based components"
Section 2: "Use functional components with hooks"
```

**After:**
```markdown
## React Components

Use functional components with hooks exclusively.

DEPRECATED: Do not create new class-based components.
Existing class components may remain but convert them
during refactoring work.
```

### Strategy 4: Conditional Branching
When different tools/languages have different rules:

**Before:**
```markdown
"Always use promises"
"Always use async/await"
```

**After:**
```markdown
## Async Patterns

- **JavaScript/TypeScript**: Prefer async/await over promises
- **Python**: Use async/await for async functions, context managers for cleanup
- **C#**: Use async/await with Task/Task<T>
```

## Resolution Checklist

For each contradiction found:

- [ ] Identified type of contradiction (style/workflow/tool/config)
- [ ] Located all instances across all files
- [ ] Checked actual code/config to find reality
- [ ] Interviewed user about preference if unclear
- [ ] Selected resolution strategy
- [ ] Updated all locations with consistent guidance
- [ ] Added context or reasoning where helpful
- [ ] Removed old/conflicting sections
- [ ] Verified resolution makes sense for project

## Common Contradictions by Project Type

### React Projects
- Class vs functional components
- Hooks vs HOC
- Redux vs Context vs Jotai
- Styled-components vs Tailwind vs CSS modules
- Vitest vs Jest
- ESLint vs Prettier scoping

### Python Projects
- unittest vs pytest
- async patterns (asyncio vs Trio)
- Type hints (optional vs required)
- Virtual env vs poetry vs conda
- Black vs autopep8
- Logging vs print statements

### .NET Projects
- Async/await patterns
- Dependency injection container (Autofac vs built-in)
- ORM (EF Core vs Dapper)
- Testing framework (xUnit vs NUnit)
- Logging framework (Serilog vs built-in)

## Example Resolution

**Original contradictions in React project:**

```markdown
# Contradiction Set 1: Component Style

Line 25: "Write React components as classes extending React.Component"
Line 145: "Use functional components with hooks exclusively"
Line 340: "Class components are preferred for complex state management"
```

**Detection:**
- 3 statements about component style
- Directly contradictory
- Reality: package.json shows React 18+ (hooks standard)

**Resolution:**

```markdown
## React Components

Use functional components with hooks exclusively. This project targets
React 18+ which optimizes for hooks-based development.

### Pattern

```typescript
// Good: Functional component with hooks
function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);

  if (!user) return <Skeleton />;
  return <div>{user.name}</div>;
}

// Avoid: Class components
class UserProfile extends React.Component {
  // ...
}
```

### Migration
Existing class components can remain but convert during refactoring.
```

This clarity helps the agent make consistent decisions.

## See Also

- [Progressive Disclosure Principles](progressive-disclosure.md) - Why contradictions hurt progressive disclosure
- [Phase 2: Essentials](phase-2-essentials.md) - Deciding what content to keep
- [Phase 5: Deletion](phase-5-deletion.md) - Removing vague guidance that causes confusion

# Phase 5: Identifying and Removing Redundant/Vague Instructions

Vague, redundant, or default advice clutters instruction files and wastes agent context. Phase 5 systematically identifies what to delete and why.

## Why Delete Content?

### Token Usage
- Vague advice ("write clean code") adds tokens but no value
- Agent already knows universal best practices
- Example: 50 lines of default advice = ~300 tokens per task

### Clarity
- Vague instructions confuse rather than guide
- Contradicts agent's own knowledge
- Adds noise to signal

### Maintenance
- Outdated default advice needs updating
- Cultural wisdom that ages poorly
- Distracts from project-specific needs

## Categories of Content to Delete

### Category 1: Universal Best Practices (DELETE)

Things every developer and every AI already knows.

**Examples to delete:**
```markdown
✗ Write clean, readable code
✗ Use meaningful variable names
✗ Write well-documented functions
✗ Follow DRY principles
✗ Don't commit secrets
✗ Test your code before pushing
✗ Follow SOLID principles
✗ Write reusable components
✗ Avoid hardcoded values
✗ Use error handling
✗ Write defensive code
✗ Avoid deeply nested code
✗ Keep functions small
```

**Why delete:** These are agent defaults. Stating them adds no value and uses tokens.

**Counter-example - Keep This:**
```markdown
✓ Limit functions to 20 lines maximum (project-specific standard)
✓ Use named exports for all components (specific to codebase)
✓ Always add JSDoc comments to complex functions (project requirement)
```

### Category 2: Vague Guidance (DELETE or SPECIFY)

Instructions that sound useful but aren't actionable.

**Examples to delete:**
```markdown
✗ Keep it simple
✗ Be consistent
✗ Use best practices
✗ Follow conventions
✗ Optimize for performance
✗ Write maintainable code
✗ Consider scalability
✗ Think about edge cases
✗ Be defensive
✗ Use appropriate patterns
✗ Write good documentation
```

**Why delete:** No concrete guidance - agent can't act on "keep it simple"

**How to fix: Make Specific**
```markdown
Original: "Optimize for performance"

Better: "Use memoization for components that render > 100 items"
Or:     "Debounce API calls in search inputs (300ms minimum)"
Or:     "Cache database queries with Redis for repeat requests"
```

```markdown
Original: "Write good documentation"

Better: "Add JSDoc comments to all exported functions"
Or:     "Document complex algorithms with step-by-step comments"
Or:     "Include examples in README for each public API"
```

### Category 3: Redundant Rules (CONSOLIDATE)

Same rule stated multiple places.

**Examples to consolidate:**
```markdown
File 1 (.claude/typescript.md):
"Use interfaces for object contracts"

File 2 (CLAUDE.md):
"Prefer interfaces over types"

File 3 (.claude/react.md):
"React component props should use interfaces"

Action: Keep in typescript.md, remove from others, link from others
```

### Category 4: Outdated Guidance (DELETE or UPDATE)

Advice that no longer applies to current stack.

**Examples:**
```markdown
✗ "Use Class components for complex state"
  (Project uses React 18 with hooks - delete)

✗ "Python 3.6 f-strings not yet stable"
  (Python 3.10+ standard - delete)

✗ "Avoid TypeScript in templates"
  (TypeScript is standard - delete)

✗ "IE11 compatibility is required"
  (IE11 discontinued - delete)

✗ "Node 12 LTS is our target"
  (Node 18+ standard now - update or delete)
```

### Category 5: Configuration Duplication (DELETE)

Repeating what's already in config files.

**Examples to delete:**
```markdown
✗ "Use 2-space indentation (configured in .prettierrc)"
   [Already enforced by Prettier - no need to restate]

✗ "Set TypeScript strict mode (tsconfig.json has strict: true)"
   [Already configured - delete]

✗ "Use ESLint for linting (package.json has eslint script)"
   [It's a script - people can see it - delete]

✗ "Set Python line length to 88 characters (pyproject.toml configured)"
   [Already configured - delete]
```

**Exception - Keep if:**
- Configuration is non-obvious
- Requires understanding WHY it's set
- Team members frequently ask about it

```markdown
✓ "Prettier is configured for 2-space indentation to match team style"
  [Explains why - not just restating what prettier does]
```

### Category 6: Default Tool Behavior (DELETE)

Explaining what tools do by default.

**Examples to delete:**
```markdown
✗ "npm install reads package.json and installs dependencies"
✗ "Jest discovers test files ending in .test.js"
✗ "Git commit creates a snapshot of staged changes"
✗ "Python imports work from the same directory"
✗ "Docker runs containers based on Dockerfile"
```

**Why delete:** These are tool documentation, not project guidance

**Keep only if:**
- Project does something non-standard with the tool
- Understanding is critical for this specific project

```markdown
✓ "npm run build triggers our custom build script defined in package.json"
  [Project-specific usage]
```

### Category 7: Conditional/Optional Advice (DELETE)

Suggestions that aren't required.

**Examples to delete:**
```markdown
✗ "You could use Redux, or Context API, or Jotai for state"
✗ "Consider using a testing library like Jest or Vitest"
✗ "Maybe add logging with Winston or Pino"
✗ "Docker is recommended but optional"
✗ "Consider adding linting (optional)"
```

**Why delete:** Creates confusion and decision paralysis

**Fix: Make it Definitive**
```markdown
Original: "You can use Redux, Context API, or Jotai"

Better: "Use Jotai for global state management"
[One decision, not optional]
```

### Category 8: Aspirational Goals (DELETE)

Things the team would like to do but doesn't.

**Examples to delete:**
```markdown
✗ "We aim for 90% code coverage (currently at 45%)"
✗ "Eventually we'll migrate to TypeScript (still JS)"
✗ "Once we refactor, we'll use dependency injection (not yet)"
✗ "We want to switch to Kubernetes (still using VMs)"
```

**Why delete:** Confuses what IS vs what could BE

**Fix: Document Separately or Delete**
```markdown
If aspirational, create .claude/roadmap.md or delete entirely
Keep actual standards in main files
```

## Detection Strategy

### Pass 1: Scan for Vague Language (15 minutes)

Search for weak words and phrases:

```bash
grep -E "should|could|might|consider|try|perhaps|maybe|typically" CLAUDE.md
grep -E "usually|often|generally|tend to|likely" CLAUDE.md
grep -E "best practice|should follow|try to|aim for" CLAUDE.md
```

**These indicate vague content likely to delete.**

### Pass 2: Check for Defaults (10 minutes)

```bash
grep -E "write.*code|readable|clean|meaningful names|good documentation" CLAUDE.md
grep -E "use.*pattern|follow.*principle|consider.*scalability" CLAUDE.md
grep -E "don't.*hardcode|avoid.*duplication|keep.*simple" CLAUDE.md
```

### Pass 3: Search for Redundancy (20 minutes)

Look for repeated concepts:

```bash
grep -i "testing" CLAUDE.md | wc -l
# If > 5 results, likely redundant

grep -i "git" CLAUDE.md
grep -i "commit" CLAUDE.md
# Check if same rules appear multiple times
```

### Pass 4: Check for Outdated Tech (10 minutes)

```bash
# Search for old versions/frameworks mentioned
grep -E "node.*12|python.*3\.[0-6]|react.*15|typescript.*4\.0" CLAUDE.md
grep -E "IE11|IE10|babel|webpack" CLAUDE.md

# Compare with actual package.json/config
cat package.json | grep '"version"'
```

### Pass 5: Compare Against Config Files (15 minutes)

For each rule, ask: "Is this configured?"

```bash
# Rule: "Use 2-space indentation"
cat .prettierrc | grep -i "indent"

# Rule: "TypeScript strict mode"
cat tsconfig.json | grep -i "strict"

# Rule: "Coverage > 80%"
cat jest.config.js | grep -i "coverage"
```

## Deletion Checklist

For each piece of content, ask:

- [ ] Is this specific to THIS project? (If no → DELETE)
- [ ] Is this NOT already configured? (If already configured → DELETE)
- [ ] Is this NOT a universal best practice? (If universal → DELETE)
- [ ] Is this NOT vague? (If vague → DELETE or SPECIFY)
- [ ] Is this stated only once? (If repeated → CONSOLIDATE)
- [ ] Is this current/not outdated? (If outdated → DELETE or UPDATE)
- [ ] Is this actionable/specific? (If not → DELETE or SPECIFY)
- [ ] Is this a definite rule? (If optional/aspirational → DELETE)

**If ALL checks pass → KEEP, otherwise DELETE or REVISE**

## Before and After Examples

### Example 1: Vague Test Guidance

**Before (140 words):**
```markdown
## Testing

Write tests to ensure code quality and catch bugs early.
Consider using Jest or Vitest for unit testing. Tests should be
meaningful and cover important scenarios. Try to keep tests simple
and readable. Use meaningful test names. Test edge cases and error
handling. Mock external dependencies appropriately. Aim for high
code coverage (ideally 80% or more, though coverage isn't everything).
Write integration tests for complex features. Use fixtures and
factories where appropriate. Keep tests fast by mocking expensive
operations. Consider using snapshot testing for UI. Write tests
that are maintainable and not brittle.
```

**After (180 words, but specific):**
```markdown
## Testing

Use Vitest for all unit and integration tests.

### Coverage Requirements
- Minimum 80% code coverage
- Coverage reported in CI/CD pipeline
- Coverage gates blocks merge if < 80%

### Test Structure
Use Arrange-Act-Assert pattern:
```typescript
it('adds two numbers correctly', () => {
  // Arrange
  const a = 5, b = 3;

  // Act
  const result = add(a, b);

  // Assert
  expect(result).toBe(8);
});
```

### Mocking
- Mock external API calls with vi.mock()
- Use test fixtures for database state
- Never make real network calls in tests

### Test Names
Use descriptive names describing what and why:
```typescript
it('throws error when user not found', () => {
  // Clear what should happen
});
```

### Performance
Tests should complete in < 5 seconds total
Slow tests indicate design issues
```

**Result:**
- Old: 140 words of vague advice
- New: 180 words of specific, actionable rules
- Deletion: All vague language removed and replaced with concrete examples

### Example 2: Configuration Duplication

**Before:**
```markdown
## Code Formatting

Use Prettier for code formatting. Configuration is in .prettierrc
with 80 character line width and 2-space indentation. ESLint handles
linting separately. Both run on git commit hooks.
```

**After:**
```markdown
## Code Formatting

Use Prettier (configured in .prettierrc) and ESLint (configured in
.eslintrc) - both run automatically on git commit.
```

**Result:** Reduced from 60 words to 30 words by removing redundant details

### Example 3: Outdated Guidance

**Before:**
```markdown
## Browser Support

Support IE11 and above. Use polyfills for newer JavaScript features.
Babel is configured to transpile to ES2015. Test in IE11 before
releasing.
```

**After:**
```markdown
[DELETED - IE11 is no longer supported. Project targets modern browsers only.]
```

**Result:** 70 words deleted entirely. IE11 support is not needed anymore.

### Example 4: Aspirational Content

**Before:**
```markdown
## Architecture

We're moving toward microservices architecture. Currently using
monolith but aiming to split services. Use dependency injection
patterns in preparation for this migration. Write code as if it
will eventually be its own service.
```

**After:**
```markdown
## Architecture

Use dependency injection for service layer. This improves testability
and loose coupling.
```

**Result:** Removed aspirational parts (migration plan) and kept the actual practice

## Handling Pushback

**If user says "But we might need this someday":**

Response: "Progressive disclosure means we keep the absolute minimum
in active use. If you need guidance later, we can add it back. For
now, it's using tokens without providing value."

**If user says "This is important to remember":**

Response: "If it's important, make it specific and actionable. Generic
reminders don't help - concrete examples do. Add it to the right
topic file with real examples."

**If user says "Everyone should know this":**

Response: "Agent already knows universal best practices. We save tokens
by focusing on YOUR project specifics. If this is non-obvious for
YOUR context, we'll make it specific."

## Verification Checklist

After deletion pass:

- [ ] No vague language (should/could/might/consider)
- [ ] No "universal best practices" (write clean code, meaningful names)
- [ ] No repeated rules across files
- [ ] No outdated technology references
- [ ] No configuration repetition
- [ ] No aspirational/optional guidance
- [ ] No default tool behavior explanation
- [ ] Every remaining rule is actionable
- [ ] Root file is under 50 lines
- [ ] All files have good signal-to-noise ratio

## Token Savings Example

```
Before Deletion:
- 800 lines total
- 200 lines are vague/redundant/outdated
- 600 lines of actual value
- Average per task: ~1,200 tokens

After Deletion:
- 600 lines total
- All actionable content
- Average per task: ~800 tokens

Savings: 33% per task (~400 tokens)
```

## See Also

- [Progressive Disclosure Principles](progressive-disclosure.md) - Why deletion matters
- [Phase 1: Contradictions](phase-1-contradictions.md) - Resolve conflicts first
- [Phase 2: Essentials](phase-2-essentials.md) - What to keep
- [Phase 4: Structure](phase-4-structure.md) - Clean file organization

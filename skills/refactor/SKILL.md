---
name: refactor
description: This skill should be used when the user asks to "refactor this code", "clean up this code", "improve code structure", "reduce duplication", or "make this more maintainable". It guides safe, incremental refactoring while preserving behavior.
version: 1.0.0
---

# Refactor Skill

## Overview

Safe, incremental refactoring while preserving behavior. This skill guides identification of code improvement opportunities, application of proven refactoring patterns, and validation that behavior remains unchanged throughout the process.

## Prerequisites

This skill requires:
- Existing test suite (unit tests)
- Git repository with commit history
- Code to refactor

This skill does NOT:
- Introduce new features or functionality
- Change external behavior or API contracts
- Rewrite code without incremental steps
- Create new abstractions without justification

## Workflow

### Phase 1: Assessment

#### 1. Identify refactoring scope (interactive)

Ask the user to clarify:
- **Scope type**: Specific file/module, function/class, or codebase-wide
- **Pain points**: What's hard to maintain, understand, or test?
- **Constraints**: Team standards, framework versions, tech stack
- **Success metrics**: What would "better" look like?

Use AskUserQuestion for this interaction.

#### 2. Baseline analysis

Run existing tests to establish green baseline:
```bash
npm test / python -m pytest / dotnet test
```

Document:
- Current test pass/fail status
- Test coverage metrics (if available)
- Performance metrics (if relevant)

#### 3. Detect code smells

Examine the target code using Read and identify:
- **Long methods** (> 20-30 lines)
- **Duplicate code** patterns
- **Large classes** (> 300-400 lines)
- **Deep nesting** (> 3-4 levels)
- **Magic numbers/strings** without explanation
- **Unclear variable/function names**
- **Mixed concerns** (too many responsibilities)

Create a task list documenting issues found.

### Phase 2: Planning

#### 4. Select refactoring patterns

Choose from [refactor-patterns.md](references/refactor-patterns.md):
- **Extract Method** - Pull out logic into named function
- **Extract Class** - Move cohesive code to new class
- **Inline** - Merge unnecessarily split code
- **Move** - Relocate code to appropriate module/class
- **Rename** - Use clearer names
- **Replace Temp with Query** - Eliminate intermediate variables
- **Remove Duplication** - Consolidate repeated logic
- **Simplify Conditional** - Reduce branching complexity

#### 5. Create refactoring plan

Document order of refactorings:
- Independent first (can be done in any order)
- Build on each other logically
- Biggest impact/lowest risk first
- Include small, testable steps

#### 6. Review against anti-patterns

Consult [anti-patterns.md](assets/anti-patterns.md) to avoid:
- Over-engineering
- Premature abstraction
- Losing performance
- Breaking compatibility

### Phase 3: Implementation

#### 7. Execute incremental refactorings

For each refactoring step:
1. **Read** the target code section
2. **Plan** the specific change
3. **Edit/Write** to apply the refactoring
4. **Run tests** to verify behavior preservation
5. **Commit** with clear message (e.g., "refactor: extract calculateTotal method")

Use the [refactor-checklist.md](assets/refactor-checklist.md) to track each step.

#### 8. Match existing patterns

Follow project conventions:
- Naming standards (camelCase, snake_case, PascalCase)
- File/module organization
- Comment style
- Error handling approach
- Testing patterns

#### 9. Run tests after each step

After every change:
```bash
npm test / python -m pytest / dotnet test
```

If tests fail:
- Analyze the failure
- Revert or fix the refactoring
- Commit the fix
- Re-run tests

Do NOT commit failing code.

### Phase 4: Validation

#### 10. Verify final state

Ensure:
- All tests passing
- Code coverage maintained or improved
- Readability improved
- Performance unchanged (or better)
- No new warnings or errors

#### 11. Compare before/after

Document:
- Lines of code change (reduced duplication, improved structure)
- Complexity metrics (if measured)
- Maintainability improvements
- Changes to test count/structure

Reference [before-after-examples.md](assets/before-after-examples.md) for documentation patterns.

#### 12. Update task list

Mark all refactoring tasks as completed with results.

## Common Scenarios

### Scenario 1: Large Function Refactor
**User**: "This function is 100 lines, hard to understand"
**Action**: Extract methods for each responsibility, run tests after each extraction

### Scenario 2: Code Duplication
**User**: "This logic is repeated in 5 places"
**Action**: Find common pattern, extract to shared utility, verify behavior with tests

### Scenario 3: Class Reduction
**User**: "This class does too much"
**Action**: Identify responsibilities, extract related methods into new classes, refactor incrementally

### Scenario 4: Name Clarity
**User**: "I don't understand what this function does from the name"
**Action**: Rename with clearer intent, refactor logic to match intent, run tests

## Refactoring Patterns at a Glance

| Pattern | Use When | Benefit |
|---------|----------|---------|
| Extract Method | Function > 30 lines or mixed concerns | Readability, reusability, testability |
| Extract Class | Class has multiple responsibilities | SRP, easier to test, clearer intent |
| Inline | Function/variable is trivial or obfuscating | Clarity, fewer abstractions |
| Move | Code in wrong module/class | Better organization, reduced coupling |
| Rename | Names are unclear or misleading | Readability, maintainability |
| Replace Temp with Query | Temporary variables obscure intent | Fewer variables, cleaner logic |
| Remove Duplication | Same logic appears 2+ times | DRY principle, easier maintenance |
| Simplify Conditional | Deep nesting or complex logic | Readability, maintainability |

## Code Smells Quick Reference

| Smell | Signs | Solution |
|-------|-------|----------|
| Long Method | > 30 lines or hard to name | Extract Method |
| Large Class | > 400 lines or many responsibilities | Extract Class |
| Duplicate Code | Same logic in 2+ places | Extract Method/Class or consolidate |
| Long Parameter List | > 3-4 parameters | Object parameter or builder pattern |
| Long Conditional | Deep nesting or complex boolean logic | Extract Method, guard clauses, polymorphism |
| Magic Numbers/Strings | Unexplained constants | Named constants with clear intent |
| Unclear Names | Names don't match intent | Rename to reveal intent |
| Dead Code | Unreachable or unused code | Delete |

## Tools to Use

- **TaskCreate/TaskUpdate/TaskList**: Track refactoring steps
- **Read**: Examine code structure and patterns
- **Edit/Write**: Apply refactoring changes
- **Bash**: Run tests and git commands
- **Glob**: Find related code patterns
- **Grep**: Search for duplicate code patterns

## Notes

- Never refactor without tests
- Commit after each successful refactoring
- Keep refactorings small and focused
- When stuck, run tests to understand current behavior
- Ask user before major architectural changes
- Preserve external behavior at all times
- If refactoring reveals bugs, fix in separate commits

## Reference Files

- [Refactoring Patterns](references/refactor-patterns.md) - Detailed patterns guide
- [Code Smells](references/code-smells.md) - Code smell detection and fixes
- [Testing During Refactor](references/testing-during-refactor.md) - Test strategies
- [Scope Strategies](references/scope-strategies.md) - How to scope refactoring work
- [Refactor Checklist](assets/refactor-checklist.md) - Pre/during/post checks
- [Before/After Examples](assets/before-after-examples.md) - Good refactoring examples
- [Anti-Patterns](assets/anti-patterns.md) - What NOT to do

---
name: bug-fix
description: This skill should be used when the user asks to "fix this bug", "debug this issue", "investigate this error", "this is broken", or "find the problem". It systematically debugs and fixes software defects through identification, analysis, and validated correction.
version: 1.0.0
---

# Bug Fix Workflow

## Overview

Systematically debug and fix software defects through identification, root cause analysis, minimal fixes, and validated correction with tests. This workflow ensures bugs are properly understood, fixed at the source, and prevented from recurring.

This skill guides you through:
- Reproducing and identifying the bug
- Root cause analysis
- Implementing minimal, targeted fixes
- Testing and verification
- Adding regression tests

## When to Use

Use this skill when:
- User reports a bug or error
- Tests are failing
- Application exhibits incorrect behavior
- Regressions are detected
- Error logs show problems

## Common Bug Categories

Understanding bug types helps focus investigation:

| Category | Indicators | Common Causes |
|----------|-----------|---------------|
| **Logic Error** | Wrong output, incorrect calculation | Off-by-one, wrong operator, edge case |
| **Null/Undefined** | TypeError, NullReferenceException | Missing validation, async race condition |
| **Type Error** | Type mismatch, cast failure | Wrong type passed, schema mismatch |
| **Async/Race Condition** | Intermittent failure, timing-dependent | Missing await, callback ordering |
| **Integration** | API failure, database error | Connection issue, data format mismatch |
| **Configuration** | Works locally, fails in production | Environment variable, missing dependency |
| **Performance** | Timeout, memory leak, slowness | Inefficient query, unbounded growth |
| **Security** | Injection, XSS, auth bypass | Missing validation, improper sanitization |

See [Error Patterns Reference](references/error-patterns.md) for detailed patterns and solutions.

## Workflow

### 1. Create Task List

Use **TaskCreate** to track the bug fix workflow:
- Task for reproducing/identifying the bug
- Task for root cause analysis
- Task for implementing the fix
- Task for testing the fix
- Task for adding regression tests (if needed)

Update each task with **TaskUpdate** as you progress.

### 2. Reproduce and Identify

**Goal**: Understand exactly what's failing and when.

**Steps:**
1. Read error messages and logs carefully
2. Use **Grep** to search for error messages in code
3. Use **Read** to examine failing components
4. Use **Bash** to reproduce the failure:
   - Run failing tests
   - Execute the failing scenario
   - Create minimal reproduction case

**Output**: Clear understanding of:
- What fails (specific function, component, flow)
- When it fails (conditions, inputs)
- What the expected behavior is

See [Debugging Strategies](references/debugging-strategies.md) for investigation techniques.

### 3. Root Cause Analysis

**Goal**: Find the actual source of the bug, not just symptoms.

**Ask:**
- Is this a symptom or the root cause?
- What assumptions are being made?
- What changed recently that could cause this?
- Are there edge cases not being handled?

**Techniques:**
- Trace execution backwards from failure point
- Check input validation and data flow
- Look for missing null checks or type guards
- Review recent commits (git log, git diff)
- Check for timing/async issues

**Red Flags:**
- Multiple catch-all try/catch blocks hiding real errors
- Silent failures (errors swallowed without logging)
- Assumptions about data structure or format

See [Root Cause Analysis](references/root-cause-analysis.md) for detailed techniques.

### 4. Documentation (If Needed)

If framework/library usage is unclear:
- Search the web for specific documentation
- Look for documentation for the exact version you're using
- Focus on API changes, deprecations, breaking changes
- Re-run investigation with new knowledge

### 5. Implement the Fix

**Goal**: Minimal, targeted change that fixes the root cause.

**Principles:**
- Fix the root cause, not symptoms
- Make the smallest change that works
- Preserve existing patterns and conventions
- Don't refactor unrelated code
- Add defensive checks only where needed

**Steps:**
1. Use **Read** to understand surrounding code
2. Use **Edit** to implement minimal fix
3. Verify fix addresses root cause
4. Check for similar bugs elsewhere (use **Grep**)

**Example Fixes:**

**Null Check:**
```typescript
// Before (bug)
const userName = user.profile.name;

// After (fixed)
const userName = user?.profile?.name ?? 'Unknown';
```

**Off-by-One:**
```python
# Before (bug)
for i in range(len(items)):
    if i < len(items):  # Redundant, always true
        process(items[i])

# After (fixed)
for item in items:
    process(item)
```

**Async Race:**
```javascript
// Before (bug)
const data = fetchData();
processData(data);  // undefined - fetchData is async

// After (fixed)
const data = await fetchData();
processData(data);
```

### 6. Test the Fix

**Goal**: Verify the bug is actually fixed.

**Primary Verification:**
Use **Bash** to run the most relevant test first:
- Specific unit test for the bug
- Reproduction script
- Command that previously failed
- Manual test of the scenario

**Regression Check:**
- Run full test suite for affected area
- Check for new failures introduced by fix
- Verify related functionality still works

**Manual Verification (if applicable):**
- Test in browser/UI if frontend bug
- Test API endpoint if backend bug
- Check logs for errors

### 7. Add/Update Tests

**Goal**: Prevent regression of this bug.

**When to Add Tests:**
- Bug wasn't caught by existing tests (gap in coverage)
- Edge case that wasn't tested
- Integration scenario not covered
- Complex logic that needs validation

**Steps:**
1. Use **Glob** to find relevant test files
2. Use **Read** to understand test patterns
3. Use **Write** or **Edit** to add regression test
4. Run new test to verify it catches the bug
5. Verify fix makes the test pass

Templates: [Python Test Template](assets/test-for-bug-template.py) | [TypeScript Test Template](assets/test-for-bug-template.ts)

See [Testing Strategies](references/testing-strategies.md) for test patterns.

### 8. Final Status

Use **TaskUpdate** to mark all tasks completed and **TaskList** to show progress.

## Common Scenarios

### Scenario 1: Null Pointer Error

**Symptom**: `TypeError: Cannot read property 'x' of undefined`

**Investigation:**
```bash
# Find where the error occurs
grep -rn "property that failed" src/

# Check data flow
# Read the function that failed
# Trace back to data source
```

**Common Causes:**
- Missing null/undefined check
- Async data not loaded yet
- Wrong property path
- API response changed

**Fix**: Add proper validation and default values

### Scenario 2: Test Failure

**Symptom**: Unit test fails after code change

**Investigation:**
```bash
# Run the specific failing test
npm test -- --testNamePattern="failing test"
pytest -k "test_name" -v

# Check what changed
git diff main...HEAD
```

**Common Causes:**
- Breaking change to function signature
- Test expectations outdated
- Mock/fixture data stale
- Timing/async issue in test

**Fix**: Update code or test to match requirements

### Scenario 3: Integration Failure

**Symptom**: API call fails, database error

**Investigation:**
```bash
# Check logs
tail -f logs/application.log

# Test API endpoint manually
curl -X POST http://localhost:3000/api/endpoint -d '{"test": "data"}'

# Check database connection
# Verify schema matches
```

**Common Causes:**
- Schema mismatch
- Missing environment variable
- Network/connection issue
- Authentication failure

**Fix**: Align data formats, fix configuration

See [Debugging Strategies](references/debugging-strategies.md) for more scenarios.

## Tools to Use

### Investigation
- **Grep**: Search for error messages, function calls, related code
- **Read**: Examine code, understand context, review changes
- **Bash**: Reproduce bugs, run tests, check logs
- **Glob**: Find test files, locate related modules

### Implementation
- **Edit**: Apply minimal fixes to existing code
- **Write**: Add new test files or utilities
- **Bash**: Run tests, verify fixes

### Task Management
- **TaskCreate**: Track bug fix workflow
- **TaskUpdate**: Mark progress (in_progress → completed)
- **TaskList**: Show final status

## Best Practices

### Investigation
- Read error messages completely - they often point to exact line
- Reproduce the bug reliably before attempting a fix
- Understand the root cause, don't just fix symptoms
- Check recent git history for changes that might have introduced the bug

### Fixing
- Make minimal, targeted changes
- Fix the root cause, not just where the error appears
- Don't refactor unrelated code
- Preserve existing patterns and conventions
- Add defensive checks only where they make sense

### Testing
- Verify the fix actually resolves the bug
- Check for regressions (new bugs introduced)
- Add tests for gaps in coverage
- Run full test suite for affected area
- Test edge cases related to the bug

### Documentation
- Update code comments if the bug revealed unclear logic
- Don't add obvious comments
- Document workarounds only if necessary

## Anti-Patterns to Avoid

### Don't Guess and Check
- ❌ Try random changes hoping something works
- ✅ Understand the bug first, then apply targeted fix

### Don't Fix Symptoms
- ❌ Add try/catch to hide the error
- ✅ Fix the root cause

### Don't Over-Engineer
- ❌ Add complex error handling for impossible scenarios
- ✅ Handle realistic error cases simply

### Don't Refactor While Fixing
- ❌ "While I'm here, let me clean up this code..."
- ✅ Focus on the bug, refactor separately if needed

### Don't Skip Testing
- ❌ "It looks fixed, ship it"
- ✅ Verify with tests, add regression test

## Execution Notes

- Prefer precise, minimal edits over broad refactors
- If documentation is unavailable, proceed cautiously and document assumptions
- If tests are slow or unavailable, explain what verification you performed
- Always reproduce the bug before fixing to confirm your fix works
- Use **TaskList** to show final status

## See Also

- [Debugging Strategies](references/debugging-strategies.md) - Investigation techniques
- [Root Cause Analysis](references/root-cause-analysis.md) - Finding real issues
- [Error Patterns](references/error-patterns.md) - Common error types and solutions
- [Testing Strategies](references/testing-strategies.md) - Adding regression tests
- [Bug Fix Checklist](assets/bug-fix-checklist.md) - Quality assurance

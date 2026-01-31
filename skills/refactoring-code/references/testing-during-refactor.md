# Testing During Refactoring

Strategies for ensuring behavior preservation throughout refactoring work.

## Test Requirements

### Before Starting

1. **Existing Tests**: Must have passing test suite
   - If tests don't exist, add them first
   - This skill assumes test coverage exists
   - Tests serve as safety net for refactoring

2. **Test Coverage**: Ideally >80% for target code
   - Gaps in coverage increase risk
   - Consider adding tests before refactoring
   - Focus on behavioral coverage, not line coverage

3. **Test Execution**: Can run tests locally
   - Need ability to run full test suite
   - Tests should run fast (< 5 seconds for unit tests)
   - CI/CD not required but helpful

## Incremental Testing

### Step-by-Step Validation

For each refactoring step:

1. **Make small change** (Extract one method, rename one variable)
2. **Run all tests** immediately
3. **Fix any failures** before proceeding
4. **Commit** if passing
5. **Move to next step**

Never batch multiple refactorings before testing.

### Red-Green-Refactor Cycle

1. **Red**: Ensure tests pass before starting
2. **Refactor**: Make targeted change
3. **Green**: Run tests; if fail, immediately fix
4. **Commit**: Save successful state

Repeat until refactoring complete.

## Common Test Failures During Refactoring

### Import/Module Path Failures

**Cause**: Moved code to new location; imports broken

**Fix**:
1. Update import statements to new location
2. Verify module/package exists
3. Run tests again
4. Update in implementation AND tests

### Behavioral Changes

**Cause**: Refactoring accidentally changed logic

**Fix**:
1. Compare old and new implementation line-by-line
2. Identify where logic diverged
3. Restore original behavior
4. Re-run tests

### Test Fixture Issues

**Cause**: Tests relied on internal implementation details

**Fix**:
1. Update test setup to work with new structure
2. Create factories if needed
3. Mock new dependencies
4. Verify test still validates behavior

### Performance Regressions

**Cause**: Refactoring changed performance characteristics

**Detection**:
- Test takes much longer to run
- Timeout errors in CI
- Memory usage increases significantly

**Fix**:
1. Identify performance bottleneck
2. Consider optimization step
3. Or revise refactoring approach

## Testing Strategies by Refactoring Type

### Extract Method

**Test Approach**:
1. Ensure original function tests still pass
2. New method usually private (no direct test needed)
3. If new method is useful, make it public and add tests

### Extract Class

**Test Approach**:
1. Create basic tests for new class
2. Ensure original class tests still pass
3. Test integration between classes

### Rename

**Test Approach**:
1. All existing tests should pass unchanged
2. Use IDE refactoring to rename (safer)

### Move Method/Field

**Test Approach**:
1. Tests following original code still pass
2. If moved to public location, add targeted tests

### Remove Duplication

**Test Approach**:
1. Each original test should still pass
2. When consolidating, all behavior covered by shared tests

## Debugging Test Failures

### When Tests Fail After Refactoring

1. **Understand what failed**
   - Read test name and assertion
   - What behavior was being tested?

2. **Compare old vs new code**
   - Side-by-side comparison
   - What changed logic?

3. **Run test in isolation**
   - Focus on single failing test

4. **Add debug output**
   - Print intermediate values
   - Check what test receives vs expects

5. **Revert and try different approach**
   - If stuck, revert to last working state
   - Try simpler refactoring first

## Validation Beyond Tests

After refactoring, verify:

1. **Code Review**: Another developer review changes
2. **Manual Testing**: Try actual workflows
3. **Performance**: Monitor if applicable
4. **Integration**: Check with dependent systems

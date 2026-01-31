# Refactoring Checklist

Use this checklist for each refactoring task to ensure consistent, safe progress.

## Pre-Refactoring

### Understanding
- [ ] Identified target code and its purpose
- [ ] Located all places code is used/called
- [ ] Understand data flow in and out
- [ ] Identified dependencies and side effects
- [ ] Know what improved code should look like

### Testing
- [ ] Existing tests pass with green status
- [ ] Test coverage exists for target code
- [ ] Can run tests locally in < 5 seconds
- [ ] Know which test to run after each change

### Planning
- [ ] Listed all refactoring steps in order
- [ ] Identified which steps are independent
- [ ] Ordered steps from simplest to complex
- [ ] Created task list in TaskCreate
- [ ] Got user approval if scope is large

### Communication
- [ ] If team project, informed team of plans
- [ ] Created branch if needed
- [ ] Documented reason for refactoring
- [ ] Communicated timeline if blocking others

## During Each Refactoring Step

### Before Making Change
- [ ] Reviewed current tests
- [ ] Identified what needs to change
- [ ] Planned exact change (what/where/how)
- [ ] Located code to be changed

### Making the Change
- [ ] Made single, focused change
- [ ] Maintained indentation and style consistency
- [ ] Updated related comments (if any)
- [ ] Did NOT mix refactoring with feature work
- [ ] Did NOT optimize or change behavior

### After Making Change
- [ ] Ran all tests immediately
- [ ] Confirmed all tests pass
- [ ] If tests failed, understand why and fix
- [ ] Verified no new warnings or errors
- [ ] Committed change with clear message

### Testing Verification
- [ ] Tests passing: Yes/No
- [ ] Coverage maintained: Yes/No
- [ ] Behavior unchanged: Yes/No
- [ ] Performance acceptable: Yes/No
- [ ] Code review ready: Yes/No

## Commit Practices

### Each Commit Should
- [ ] Represent single logical refactoring step
- [ ] Have clear, descriptive message
- [ ] Use format: `refactor: [pattern] [what changed]`
- [ ] Have all tests passing
- [ ] Be reviewable in < 5 minutes

### Examples
- "refactor: extract calculateDiscount method from getPrice"
- "refactor: rename UserManager to UserRepository"
- "refactor: remove duplicate validation logic"
- "refactor: simplify conditional with guard clause"

## Post-Refactoring

### Code Quality
- [ ] All tests passing
- [ ] Code coverage same or improved
- [ ] Complexity metrics improved
- [ ] No new warnings
- [ ] Code style consistent

### Documentation
- [ ] Updated any related comments
- [ ] Updated architecture docs (if needed)
- [ ] Updated CLAUDE.md (if pattern matters)
- [ ] Added notes for next developer (if needed)

### Review Readiness
- [ ] PR/branch is focused (only refactoring, no features)
- [ ] Changed files clearly related
- [ ] Commit messages clear and small
- [ ] All tests passing in CI
- [ ] Ready for peer review

### Final Verification
- [ ] Run full test suite one more time
- [ ] Manual spot-check of changed code
- [ ] Verify no accidental changes
- [ ] Check for commented-out code
- [ ] Confirm behavior completely unchanged

## Per-Pattern Checklist

### Extract Method
- [ ] Identified cohesive code block
- [ ] Created method with clear name
- [ ] All required variables passed as parameters
- [ ] Return value captured if needed
- [ ] Original code replaced with method call
- [ ] Tests still pass
- [ ] Method is testable (private or public?)

### Extract Class
- [ ] Identified cohesive responsibility
- [ ] Created new class with clear purpose
- [ ] Moved related fields and methods
- [ ] Created instance in original class
- [ ] Updated all references
- [ ] Tests pass for both classes
- [ ] Integration between classes correct

### Rename
- [ ] Used IDE rename refactoring (not manual)
- [ ] All references updated automatically
- [ ] Tests still pass
- [ ] New name reveals intent
- [ ] Name consistent with codebase conventions

### Remove Duplication
- [ ] Found all instances of duplicated code
- [ ] Created shared location (method, class, module)
- [ ] Consolidated code doesn't lose functionality
- [ ] All instances updated to call shared
- [ ] All original behaviors preserved in tests
- [ ] No missing edge cases

### Simplify Conditional
- [ ] Original logic fully understood
- [ ] New logic semantically equivalent
- [ ] Guard clauses eliminate nesting
- [ ] Tests verify all branches
- [ ] Performance acceptable
- [ ] Readability improved

## Troubleshooting

### Tests Fail After Change
- [ ] Revert change immediately
- [ ] Compare old and new carefully
- [ ] Identify what logic changed
- [ ] Fix in smaller steps
- [ ] Run tests after each fix

### Hard to Understand Original Code
- [ ] Don't start refactoring yet
- [ ] Add tests first to capture behavior
- [ ] Document what you learn
- [ ] Then refactor small pieces
- [ ] Run tests constantly

### Unexpected Side Effects
- [ ] Revert change
- [ ] Run tests to verify baseline
- [ ] Investigate what was affected
- [ ] Consider if refactoring is safe
- [ ] Adjust scope if needed

### Code Review Feedback
- [ ] Understand reviewer's concern
- [ ] Verify it's not already tested
- [ ] Fix or explain clearly
- [ ] Re-commit with updated message
- [ ] Avoid arguing about style

## Sign of Successful Refactoring

- [ ] All tests pass (no failures)
- [ ] Same behavior as before (verified by tests)
- [ ] Code is clearer and easier to understand
- [ ] Easier to test individual pieces
- [ ] Easier to explain to new developer
- [ ] Duplicated code eliminated
- [ ] Complexity metrics improved
- [ ] No performance regression
- [ ] Team agrees it's an improvement

## Sign of Risky Refactoring

- [ ] Tests start failing
- [ ] Behavior might have changed
- [ ] Code is now harder to understand
- [ ] More code than before
- [ ] More complex data structures
- [ ] Performance noticeably worse
- [ ] Peer review has concerns
- [ ] Can't confidently explain changes

---
name: add-unit-tests
description: This skill should be used when the user asks to "add unit tests", "create tests for my changes", "test my PR", "validate unit tests", or "compare tests against develop". It adds or updates unit tests for code changes and iterates until all tests pass.
version: 1.1.0
---

# Add Unit Tests

## Overview

Add or update unit tests for recent code changes and iterate until all unit tests pass. This skill does not set up new test frameworks or environments.

## Prerequisites

This skill requires:
- An existing test framework (pytest, vitest, jest, junit, etc.)
- Git repository with commit history
- Runnable test suite

This skill does NOT:
- Set up new testing frameworks
- Create test infrastructure from scratch
- Add integration or E2E tests (unless explicitly requested)

## Workflow

### Phase 1: Discovery

#### 1. Ask scope and baseline (interactive)

Ask the user to determine:
- Which scope to use:
  - Compare against develop (diff-based)
  - Focus on a specific feature/file/area
  - Scan the whole codebase for test gaps
- If the user chooses develop comparison, confirm the base branch name if it might differ (e.g., `main`, `master`, `Develop`).

Use AskUserQuestion for this interaction.

#### 2. Detect testing framework and configuration

Locate test directories and configuration files:
- Use Glob to find test patterns: `tests/**/*`, `**/*_test.*`, `**/*.test.*`, `**/*.spec.*`
- Examine test configuration files with Read: `pytest.ini`, `vitest.config.ts`, `jest.config.js`, etc.
- Identify the test framework in use (see [references/testing-frameworks.md](references/testing-frameworks.md) for details)

#### 3. Identify changed files (if diff-based)

Compare current branch to the base branch using Bash:
```bash
git diff develop...HEAD --name-only
git log --oneline --decorate develop..HEAD
```

If develop is not present locally, fetch or ask before proceeding. See [references/git-workflow.md](references/git-workflow.md) for handling branch variations.

### Phase 2: Baseline

#### 4. Create task list for tracking

Create tasks using TaskCreate:
- Task for identifying changed files (if diff-based)
- Task for running existing tests
- Task for adding/updating unit tests
- Task for iterating until all tests pass

#### 5. Run existing tests to establish baseline

Run the existing unit test command using Bash:
- Execute the detected test framework command
- Capture the output and test results
- Note any failing tests before changes

If no unit tests exist, stop and report that this workflow does not create new testing environments.

#### 6. Document current test coverage

Record:
- Number of existing tests
- Test pass/fail status
- Coverage gaps related to changed files

### Phase 3: Implementation

#### 7. Add or update unit tests for changed code

Examine existing code with Read, then create or modify tests using Edit or Write:

- **If diff-based**: Focus on behavior introduced or modified in the diff vs base branch
- **If feature-focused**: Prioritize tests that validate the feature's expected behavior and edge cases
- **If whole-codebase scan**: Prioritize high-risk or core modules, then fill obvious gaps in critical paths

Follow these principles:
- Prefer small, focused tests and minimal mocking
- Follow existing test patterns and naming conventions
- Use test templates from `assets/` directory when creating new test files
- Cover happy paths, edge cases, and error conditions

#### 8. Follow existing patterns and conventions

Match the style and structure of existing tests:
- Use the same assertion library
- Follow the same file naming convention
- Match the indentation and formatting style
- Use similar test structure (arrange/act/assert, given/when/then, etc.)

#### 9. Use documentation only if needed

If testing APIs or frameworks are unfamiliar or ambiguous:
- Search the web for framework-specific documentation
- Check official testing library documentation sites
- Keep the query narrow (e.g., "pytest parametrize example" or "vitest mock module")
- Reference [references/testing-frameworks.md](references/testing-frameworks.md) for common patterns

### Phase 4: Validation

#### 10. Run tests iteratively until all pass

After each change:
- Run the same unit test command using Bash
- Analyze failures and fix issues
- Re-run until all unit tests pass

Mark progress with TaskUpdate (in_progress → completed).

#### 11. Update task list with results

Update all tasks to completed status:
- Mark identification task as completed
- Mark baseline test run as completed
- Mark test creation/update as completed
- Mark validation as completed

#### 12. Report final status

Provide a summary using the task list:
- Number of tests added/updated
- Final test results (all passing)
- Files modified
- Any issues encountered

## Common Scenarios

### Scenario 1: PR Review
**User**: "Add tests for my PR"
**Action**: Compare against develop, focus on diff, run iteratively until green

### Scenario 2: Feature Testing
**User**: "Test the login feature"
**Action**: Focus on specific area, skip git diff, test feature behavior comprehensively

### Scenario 3: Coverage Audit
**User**: "Find test gaps in the codebase"
**Action**: Scan whole project, prioritize critical paths, suggest tests for high-risk areas

### Scenario 4: Fix Failing Tests
**User**: "My tests are failing, can you fix them?"
**Action**: Run tests, analyze failures, fix issues, iterate until passing

## Tools to Use

- **AskUserQuestion**: Get user preferences for scope and baseline
- **TaskCreate/TaskUpdate/TaskList**: Track progress through the workflow
- **Bash**: Run git commands and test suites
- **Glob**: Find test files and patterns
- **Read**: Examine existing code and test files
- **Edit/Write**: Create or modify test files

## Notes

- Do not add integration or end-to-end tests unless explicitly requested
- Do not modify production code unless required to make tests reliable and the request allows it
- Use TaskUpdate to mark each phase as completed
- Report final status using the task list
- If tests cannot pass due to production code issues, report the problem and ask for guidance

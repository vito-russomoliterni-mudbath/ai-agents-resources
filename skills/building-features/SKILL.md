---
name: building-features
description: This skill should be used when the user asks to "implement a new feature", "add functionality", "build a feature", "create a new component", or "develop new capabilities". It guides feature development through planning, implementation, testing, and quality assurance phases.
version: 1.0.0
---

# Building Features Workflow

## Overview

Implement new features using a structured approach: plan, code, verify, and iterate until complete. This workflow ensures thorough planning, quality implementation, and proper validation of new functionality.

This skill guides you through:
- Planning and task breakdown
- Documentation research
- Implementation with appropriate tools
- Verification through testing and linting
- Quality assurance and self-review
- Iteration until completion

## Prerequisites

- Clear feature requirements from the user
- Access to the codebase
- Existing build/test infrastructure (if verification is needed)

## Workflow

### 1. Plan Phase

Design the implementation approach:
- Analyze the feature request and identify dependent sub-tasks
- Use **Grep** to search for similar patterns in the codebase
- Use **Glob** to map file structure and locate dependencies
- Use **Read** to examine related code and understand existing patterns
- Break down the feature into logical implementation steps

See [Planning Strategies](references/planning-strategies.md) for detailed planning techniques.

### 2. Create Task List

Use **TaskCreate** to track implementation progress:
- Break the plan into ordered sub-tasks with clear subjects
- Create tasks for implementation, testing, and verification phases
- Use **TaskUpdate** to mark each task's progress (in_progress → completed)
- Keep tasks focused and actionable

Example task structure in [assets/task-template.md](assets/task-template.md).

### 3. Documentation Phase

If framework/library APIs or patterns are unclear:
- Search the web for up-to-date documentation
- Check official framework/library documentation sites
- Use web search to find examples and best practices
- Keep queries focused (e.g., "React useState hook patterns" or "FastAPI dependency injection")
- Use documentation to inform implementation decisions

### 4. Code Phase

Implement changes using appropriate tools:
- **Read**: Understand existing code before making changes
- **Edit**: Modify existing files with precise string replacements
- **Write**: Create new files only when absolutely necessary
- **Bash**: Run local dev servers, incremental builds, or verification commands

**Important**: Always prefer editing existing files over creating new ones. Only create files when they're essential to the feature.

See [Cross-Platform Commands](references/cross-platform-commands.md) for Bash/PowerShell equivalents.

### 5. Verification Phase

Run verification steps to ensure the feature works:

**Testing:**
```bash
# Examples (adjust based on project)
dotnet test              # .NET projects
npm test                 # Node.js projects
pytest                   # Python projects
```

**Linting and Type Checking:**
```bash
npm run lint             # JavaScript/TypeScript
dotnet format --verify-no-changes  # .NET
ruff check .             # Python
```

**Finding Test Files:**
- Use **Glob** with patterns like `**/*.test.*`, `tests/**/*`, `**/*_test.*`
- Use **Grep** to search for test functions/classes

See [Verification Patterns](references/verification-patterns.md) for framework-specific commands.

### 6. QA Phase (Self-Review)

Review changes for quality before completion:

**Code Quality Checks:**
- Use **Grep** to find similar patterns and ensure consistency
- Verify the feature follows existing code style and conventions
- Check for common bugs and regressions
- Ensure error handling is appropriate (only where needed)
- Look for security vulnerabilities:
  - XSS (Cross-Site Scripting)
  - SQL injection
  - Command injection
  - Authentication/authorization issues
  - Sensitive data exposure

**Test Coverage:**
- Verify tests cover the new functionality
- Check edge cases and error conditions
- Ensure tests are clear and maintainable

See [QA Checklist](references/qa-checklist.md) for a comprehensive review guide.

### 7. Iterate

If issues are found during review or verification:
- Use **TaskCreate** to track fixes needed
- Apply fixes using **Edit**
- Re-run verification commands
- Use **TaskUpdate** to mark fixes as completed
- Repeat until all tests pass and quality checks are clean

### 8. Final Status

Use **TaskList** to show the final status of all tasks and confirm completion.

## Tools to Use

### Planning & Discovery
- **Grep**: Search for code patterns and similar implementations
- **Glob**: Find files by pattern (e.g., `**/*.ts`, `src/**/*.py`)
- **Read**: Examine existing code and configuration
- **AskUserQuestion**: Clarify requirements or design decisions

### Task Management
- **TaskCreate**: Create new tasks with clear subjects and descriptions
- **TaskUpdate**: Update task status (pending → in_progress → completed)
- **TaskList**: View all tasks and their current status

### Implementation
- **Edit**: Modify existing files (preferred over Write)
- **Write**: Create new files when necessary
- **Bash**: Run commands, tests, builds, and verification

## Common Scenarios

### Adding a UI Component
1. Search for similar components with **Grep**
2. Read existing component patterns with **Read**
3. Create component file structure
4. Implement component logic
5. Add tests for the component
6. Verify rendering and functionality

### Adding an API Endpoint
1. Find existing endpoints with **Glob** (`**/*controller*`, `**/routes/*`)
2. Read similar endpoint implementations
3. Implement endpoint handler
4. Add request/response validation
5. Write unit tests for the endpoint
6. Test the endpoint manually or with integration tests

### Adding a Database Migration
1. Search for recent migrations with **Glob**
2. Read migration patterns and naming conventions
3. Create migration file
4. Define schema changes (tables, columns, indexes)
5. Test migration up/down operations
6. Verify database state after migration

See [scripts/cross-platform-search.sh](scripts/cross-platform-search.sh) for search examples.

## Best Practices

### Avoid Over-Engineering
- Only make changes that are directly requested or clearly necessary
- Keep solutions simple and focused on the requirement
- Don't add features, refactor code, or make "improvements" beyond what was asked
- A bug fix doesn't need surrounding code cleaned up
- A simple feature doesn't need extra configurability

### Code Quality
- Only add comments where the logic isn't self-evident
- Don't add docstrings, comments, or type annotations to code you didn't change
- If something is unused, delete it completely (no `_unused` variables or `// removed` comments)
- Trust internal code and framework guarantees

### Error Handling
- Don't add error handling, fallbacks, or validation for scenarios that can't happen
- Only validate at system boundaries (user input, external APIs)
- Don't design for hypothetical future requirements

### Abstractions
- Don't create helpers, utilities, or abstractions for one-time operations
- Three similar lines of code is better than a premature abstraction
- Don't use feature flags or backwards-compatibility shims when you can just change the code

### Security
- Always validate user input at system boundaries
- Use parameterized queries to prevent SQL injection
- Sanitize output to prevent XSS
- Avoid command injection by validating inputs to shell commands
- Don't expose sensitive data (passwords, tokens, keys) in logs or responses

## Notes

- This workflow is flexible - adapt phases based on feature complexity
- Simple features may skip documentation phase or have minimal QA
- Complex features may require multiple iterations through code/verify/iterate
- Always communicate progress and blockers to the user
- Use **AskUserQuestion** when requirements are unclear or design decisions are needed

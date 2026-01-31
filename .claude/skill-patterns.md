# Common Skill Patterns

## Task Management

All complex skills create task lists to track progress:
```
1. Create tasks with TaskCreate (subject, description, activeForm)
2. Update status with TaskUpdate (pending → in_progress → completed)
3. Report final status with TaskList
```

## Testing Workflow

Skills that modify code run tests iteratively:
```
1. Establish baseline (run tests before changes)
2. Make changes
3. Run tests after each change
4. Fix issues and re-run until all tests pass
```

## Git Integration

Skills that compare against branches:
```bash
git diff develop...HEAD --name-only  # Find changed files
git log --oneline develop..HEAD      # Review commits
```

## Tool Usage Philosophy

Skills emphasize:
- **Prefer Edit over Write** - Modify existing files when possible
- **Minimal changes** - Smallest change that achieves the goal
- **Parallel tool calls** - Run independent tools simultaneously
- **Task tracking** - Use TaskCreate/Update for complex workflows
- **Test-driven** - Run tests after every change
- **Incremental commits** - Commit after each successful step (refactor skill)

## Anti-Patterns to Avoid

Skills explicitly warn against:
- Over-engineering solutions beyond requirements
- Adding features/improvements not requested
- Refactoring unrelated code during bug fixes
- Creating abstractions for one-time operations
- Adding error handling for impossible scenarios
- Skipping tests or committing failing code
- Making changes to code you haven't read first

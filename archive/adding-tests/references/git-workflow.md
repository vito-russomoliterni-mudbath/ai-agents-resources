# Git Workflow Reference

This document covers git operations for identifying changed files and comparing branches.

## Branch Name Variations

Different projects use different conventions for the main development branch:

| Common Names | Usage |
|--------------|-------|
| `develop` | Gitflow workflow |
| `Develop` | Same, but capitalized (seen in some projects) |
| `main` | Modern default (GitHub, GitLab) |
| `master` | Legacy default |
| `dev` | Short form |
| `development` | Explicit form |

## Detecting the Base Branch

### Method 1: Ask the user
Use AskUserQuestion to confirm the base branch name if there's any doubt.

### Method 2: Check git configuration
```bash
git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
```

### Method 3: List branches and infer
```bash
git branch -a | grep -E 'develop|main|master'
```

## Comparing Branches

### Three-dot vs Two-dot diff

**Three-dot (recommended for feature branches)**:
```bash
git diff develop...HEAD --name-only
```
Shows changes between the merge-base and HEAD (only changes on your branch).

**Two-dot**:
```bash
git diff develop..HEAD --name-only
```
Shows all differences between develop and HEAD (includes changes on develop).

**Example**:
```
      A---B---C topic (HEAD)
     /
D---E---F---G develop
```

- `develop...HEAD` compares from E (merge-base)
- `develop..HEAD` compares from G (latest develop)

Use three-dot for most cases to avoid including changes from develop.

## Identifying Changed Files

### Files changed in commits
```bash
git diff develop...HEAD --name-only
```

### Files changed but not committed
```bash
git diff --name-only
```

### Files staged for commit
```bash
git diff --cached --name-only
```

### All uncommitted changes
```bash
git status --short
```

### Combine committed and uncommitted
```bash
git diff develop...HEAD --name-only && git diff --name-only
```

## Getting Commit History

### One-line log
```bash
git log --oneline --decorate develop..HEAD
```

### Detailed log with files
```bash
git log --stat develop..HEAD
```

### Just commit messages
```bash
git log --pretty=format:"%s" develop..HEAD
```

## Handling Missing Branches

### If develop doesn't exist locally
```bash
git fetch origin develop:develop
```

### If origin/develop exists but not local develop
```bash
git branch develop origin/develop
```

### Check if branch exists before using
```bash
if git show-ref --verify --quiet refs/heads/develop; then
  echo "develop exists"
else
  echo "develop does not exist"
fi
```

## Filter Changed Files by Type

### Only source files (not tests)
```bash
git diff develop...HEAD --name-only | grep -v test
```

### Only test files
```bash
git diff develop...HEAD --name-only | grep -E 'test|spec'
```

### Only specific file types
```bash
git diff develop...HEAD --name-only | grep -E '\.(py|js|ts)$'
```

### Exclude certain directories
```bash
git diff develop...HEAD --name-only | grep -v -E '^(docs|config)/'
```

## Common Issues

### Issue: "fatal: ambiguous argument 'develop...HEAD'"
**Cause**: develop branch doesn't exist locally
**Solution**:
```bash
git fetch origin develop:develop
# or
git branch develop origin/develop
```

### Issue: Too many changed files
**Cause**: Might be using two-dot instead of three-dot
**Solution**: Use `develop...HEAD` instead of `develop..HEAD`

### Issue: No changes detected
**Cause**: Already up-to-date with base branch
**Solution**: Check if commits exist:
```bash
git log develop..HEAD
```

## Workflow Integration

### Typical flow for diff-based testing

1. **Confirm base branch**: Ask user or detect
2. **Ensure branch exists**: Fetch if needed
3. **Get changed files**: Use three-dot diff
4. **Filter for relevant files**: Exclude non-code files
5. **Identify corresponding test files**: Look for test files related to changed source files
6. **Find test gaps**: Changed source files without corresponding test changes

### Example combined command
```bash
# Get changed source files (Python example)
git diff develop...HEAD --name-only | grep -E '\.py$' | grep -v test

# Get changed test files
git diff develop...HEAD --name-only | grep -E 'test.*\.py$'
```

## Best Practices

- Always use three-dot diff for feature branch comparisons
- Verify base branch exists before running diff
- Consider both committed and uncommitted changes
- Filter out non-source files (docs, config, etc.) early
- Handle case sensitivity in branch names (develop vs Develop)

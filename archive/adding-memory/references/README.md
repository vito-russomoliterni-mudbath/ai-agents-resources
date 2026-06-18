# Add Memory Skill - Complete Guide

Quickly capture project knowledge, coding guidelines, and best practices in the right documentation file at the right scope.

## Usage Examples

### Invoke with argument
```bash
/add-memory use pandas for complex data filtering
```

### Invoke without argument (skill will ask)
```bash
/add-memory
```

## Scope Options

When saving memory, you choose the scope:

| Scope | Path | Applies To | When to Use |
|-------|------|-----------|------------|
| **Global** | `~/.claude/CLAUDE.md` | All your projects | Universal patterns you use everywhere |
| **Project** | `.claude/CLAUDE.md` | Current project only | Team guidelines, project standards |
| **Personal** | `CLAUDE.local.md` | Just you (not committed) | Your local preferences, machine setup |

## File Structure & Sections

### CLAUDE.md (Project-wide)
- Project Overview
- Quick Reference
- Setup
- Tech Stack
- **Development Guidelines** ← coding practices
- **Code Conventions** ← style rules
- **Database Guidelines** ← schema/query patterns
- **Testing Guidelines** ← test patterns
- **Performance Notes** ← optimization tips
- Reference Documentation

### CLAUDE.local.md (Personal)
- Personal Preferences
- Environment Setup
- Local Tools & Aliases

### ~/.claude/CLAUDE.md (Global)
- Personal Coding Patterns
- Universal Best Practices
- Development Preferences
- Tool Preferences

## Writing Guidelines

### Good Memory Entry ✅
```
**Prefer Python for complex transformations:**
Use SQL for basic queries, but move filtering, JSON parsing,
and multi-step logic to Python/Pandas for maintainability.
```

**Why it's good:**
- Specific action (use Python, not SQL)
- Reason provided (maintainability)
- Concise (2 sentences)

### Avoid ❌
```
Write clean and efficient code
```

**Why it fails:**
- Vague (what counts as clean?)
- No actionable guidance
- No context

### Another Good Example ✅
```
**Always validate dates before querying:**
The created_at column can be NULL for imported legacy data.
Use pandas isnull() to filter before aggregating.
```

## Notes

- The skill checks for duplicates and conflicting guidelines
- Memory entries are kept short and actionable
- You review and confirm before anything is saved
- Entries follow markdown formatting for readability

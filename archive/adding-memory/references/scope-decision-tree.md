# Scope Decision Tree: Where to Document Knowledge

Use this decision tree to determine the right place to save project knowledge.

## Quick Decision Tree

```
Is this knowledge specific to ONE person's preferences?
├─ YES: Store in ~/.claude/CLAUDE.md (Personal)
└─ NO:
    Is this specific to the entire project?
    ├─ YES: Store in [repo-root]/CLAUDE.md (Project-wide)
    └─ NO:
        Is this specific to a tool/module within project?
        ├─ YES: Store in [tool-dir]/CLAUDE.md (Local)
        └─ NO:
            Does this knowledge need depth/multiple sections?
            ├─ YES: Create structured file (e.g., guides/, docs/)
            └─ NO: Add to appropriate CLAUDE.md section
```

## Scope Levels Explained

### Level 1: Personal (~/.claude/CLAUDE.md)

**What Goes Here**:
- Individual developer preferences and workflows
- Personal development setup and environment
- Tools you prefer to use
- Keyboard shortcuts and aliases you've created
- Your coding style quirks
- Debugging techniques you like
- Personal performance optimizations

**Examples**:
- "I always use async/await instead of .then()"
- "When debugging, I prefer console.log over debugger"
- "I configure VS Code with Prettier on save"
- "I use TODO comments for tracking progress"

**Scope**: Only you, doesn't affect others

### Level 2: Project-Wide (CLAUDE.md in repo root)

**What Goes Here**:
- Team coding standards and conventions
- Project-wide architectural patterns
- Required tools and versions
- Development setup instructions
- Testing strategy and patterns
- Build and deployment procedures
- Key dependencies and why they're used
- Approved libraries and frameworks
- Performance considerations
- Security considerations
- Common gotchas in this codebase

**Examples**:
- "All async operations use async/await, not .then()"
- "React components must be functional, not class-based"
- "Always use TypeScript, never `any` type"
- "Components go in [src]/components, utilities in [src]/utils"
- "We use Vitest for unit tests, Cypress for E2E"

**Scope**: Entire team, affects everyone's code

**Decision Factor**: "Would this matter to a new team member?"

### Level 3: Module/Tool-Specific (CLAUDE.md in tool directory)

**What Goes Here**:
- Architecture of this specific module/tool
- Setup instructions specific to this tool
- How this tool integrates with rest of project
- Patterns specific to this tool's domain
- Dependencies specific to this tool
- Performance considerations for this tool
- Testing approach for this tool

**Examples**:
- tools/data-processor/CLAUDE.md: Workflow orchestration setup, database connectivity
- backend/api-service/CLAUDE.md: .NET specific patterns, database migrations
- frontend/web-app/CLAUDE.md: React patterns, state management

**Scope**: Developers working on this specific tool

**Decision Factor**: "Is this only relevant to people working in this directory?"

### Level 4: Structured Documentation

**What Goes Here**:
- Detailed guides and tutorials
- Architecture deep-dives
- Step-by-step processes
- Multiple related concepts
- Large code examples and walkthroughs

**Structure**:
- docs/guides/[topic].md - How-to guides
- docs/architecture/[topic].md - Architecture docs
- docs/patterns/[topic].md - Design patterns
- docs/setup/[topic].md - Setup procedures

**Examples**:
- docs/guides/database-setup.md
- docs/architecture/authentication-flow.md
- docs/patterns/factory-pattern.md
- docs/setup/local-development.md

**When to Use**: Knowledge is substantial (> 500 words), fits natural category

## Decision Flowchart by Use Case

### Use Case: "New team member needs to know this"

1. Is it person-specific? No → Project CLAUDE.md
2. Is it module-specific? Yes → Module CLAUDE.md
3. Is it detailed? Yes → Structured docs

### Use Case: "This is how we do things in this project"

→ Project CLAUDE.md Development Guidelines section

### Use Case: "This tool has special requirements"

→ Tool CLAUDE.md, then reference from Project CLAUDE.md

### Use Case: "I discovered a performance optimization"

Specific project-wide → Project CLAUDE.md Performance Considerations
Specific to tool → Tool CLAUDE.md Performance section
Personal technique → Personal ~/.claude/CLAUDE.md

### Use Case: "This is an important architectural decision"

Affects whole project → Project CLAUDE.md Architecture
Affects one module → Module CLAUDE.md
Detailed decision → docs/architecture/[decision].md

### Use Case: "This pattern works well in our codebase"

Standard across project → Project CLAUDE.md Key Patterns
Tool-specific pattern → Tool CLAUDE.md Patterns
Requires explanation → docs/patterns/[pattern].md with example

## Multi-Level Example: Database Caching

```
Knowledge: "Always cache database queries for frequent lookups"

1. Personal perspective (~/.claude/CLAUDE.md):
   "When debugging database issues, I check cache first before DB"

2. Project perspective (CLAUDE.md):
   - "Use Redis for caching frequent queries"
   - "Cache TTL defaults to 5 minutes"
   - "Invalidate cache on updates"

3. Backend tool perspective (backend/CLAUDE.md):
   - "Entity Framework Core integrations with Redis"
   - "Async cache invalidation patterns"

4. Detailed guide (docs/guides/caching-strategy.md):
   - When to cache vs when not to
   - Cache invalidation strategies
   - Monitoring cache hit rates
   - Performance benchmarks
```

## Overlaps and Conflicts

### If knowledge fits multiple levels:

**Prioritize**:
1. Most specific level first (personal, then module, then project)
2. Reference from less specific to more specific
3. Cross-reference if appears in multiple places

**Example**:
```
Personal (~/.claude/CLAUDE.md):
"I prefer grep over other search tools"

Project CLAUDE.md:
"See ~/.claude/CLAUDE.md for personal tool preferences"

OR: Just link to most specific version
```

### If knowledge contradicts existing docs:

1. Check if contradiction is real or misunderstanding
2. Update wrong documentation
3. Add note explaining why it changed
4. Notify team if it's a material change

## When Not to Document

- One-off decisions that don't recur
- Ideas to experiment with (wait until proven)
- Incomplete thoughts or tentative ideas
- Information that changes frequently
- Confidential or sensitive information
- Company-specific details (different CLAUDE.md location)

Instead:
- Use Issues or PRs for discussion
- Document once decision is final
- Add to documentation once pattern is proven

## Maintenance Responsibility

| Level | Owner | Review Frequency |
|-------|-------|------------------|
| Personal | Individual | As needed |
| Project | Tech lead / Team | Monthly or when significant changes |
| Module | Module owner | Quarterly |
| Structured Docs | Documentation owner | Semi-annually |

## File Structure Summary

```
repo-root/
├── CLAUDE.md (project-wide guidelines)
├── docs/ (detailed documentation)
│   ├── guides/
│   ├── architecture/
│   └── patterns/
├── backend/
│   └── CLAUDE.md (backend-specific)
├── frontend/
│   └── CLAUDE.md (frontend-specific)
├── tools/
│   ├── data-processor/
│   │   └── CLAUDE.md (tool-specific)
│   └── ...

~/.claude/CLAUDE.md (personal preferences)
```

## Quick Reference Table

| Knowledge Type | Best Location | Shared? | Examples |
|----------------|---------------|---------|----------|
| Personal preference | ~/.claude/CLAUDE.md | No | "I use Prettier" |
| Code convention | Project CLAUDE.md | Yes | "Use async/await" |
| Architecture decision | Project CLAUDE.md or docs | Yes | "React for frontend" |
| Tool setup | Tool CLAUDE.md | Module team | "Prefect workflows" |
| Performance tip | Tool or Project CLAUDE.md | Yes | "Cache DB queries" |
| Step-by-step guide | docs/guides/ | Yes | "Setup development" |
| Deep concept | docs/architecture/ | Yes | "Auth flow" |
| Code pattern | Project CLAUDE.md + docs | Yes | "Factory pattern" |

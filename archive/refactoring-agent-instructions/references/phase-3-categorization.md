# Phase 3: Categorization Strategies

Grouping related instructions into logical categories is essential for effective progressive disclosure. Poor categorization makes files hard to find and creates scattered information.

## Core Categorization Principles

### Principle 1: One Topic = One File
Each file should cover a single, cohesive topic.

**Good:**
- `.claude/typescript.md` - All TypeScript conventions
- `.claude/testing.md` - All test setup and patterns
- `.claude/git-workflow.md` - All git practices

**Bad:**
- `.claude/code-style.md` - Contains TypeScript, Python, and JavaScript rules mixed together
- `.claude/testing.md` - Contains unit testing, integration testing, e2e testing, AND code coverage
- `.claude/guidelines.md` - Random mix of topics

### Principle 2: File Boundary = Topic Boundary
Once you navigate to a file, stay on that topic.

**Good structure:**
```
.claude/react.md
├── Component Patterns
├── Hooks Usage
├── State Management
└── Performance Optimization
```

**Bad structure:**
```
.claude/react.md
├── Component Patterns
├── Hooks Usage
├── How to run tests (belongs in .claude/testing.md)
├── Git workflow for React changes (belongs in .claude/git-workflow.md)
└── TypeScript for React (belongs in .claude/typescript.md)
```

### Principle 3: Logical Grouping
Related concepts group together; unrelated concepts separate.

**Good:**
- Testing framework choice, coverage targets, test structure → .claude/testing.md
- API endpoint naming, versioning, error responses → .claude/api-design.md

**Bad:**
- Testing setup in .claude/testing.md, coverage in .claude/code-quality.md
- API naming in .claude/api.md, error handling in .claude/error-handling.md

## Standard Category Templates

### Template 1: Language/Framework Categories

**When to use:** Projects with multiple languages (Node + Python + Go)

```
.claude/
├── typescript.md       # TypeScript conventions, type safety
├── python.md           # Python style, async patterns
├── go.md               # Go patterns, goroutines
├── sql.md              # Database SQL (if complex)
└── shared.md           # Applies across all languages
```

**Each file includes:**
- Type system rules (null handling, optionals)
- Async patterns specific to language
- Naming conventions
- Error handling
- Performance considerations

### Template 2: Technology Stack Categories

**When to use:** Full-stack with clear separation (Frontend/Backend)

```
.claude/
├── react.md            # React, JSX, hooks
├── api-design.md       # REST/GraphQL conventions
├── database.md         # ORM, migrations, queries
├── authentication.md   # Auth patterns, tokens, sessions
├── deployment.md       # CI/CD, environments
└── testing.md          # Test frameworks, coverage
```

**Considerations:**
- Frontend file: React components, state management, API calls
- Backend file: API design, responses, versioning
- Database file: ORM patterns, transactions, queries
- Shared files: Testing applies to both, authentication patterns

### Template 3: Concern-Based Categories

**When to use:** Layered projects with clear separation of concerns

```
.claude/
├── code-style.md       # Formatting, linting, naming
├── testing.md          # All test setup and patterns
├── architecture.md     # Folder structure, patterns
├── git-workflow.md     # Commits, branches, PRs
├── security.md         # Auth, validation, secrets
└── performance.md      # Optimization, caching
```

**Each file covers one concern across all technologies**

### Template 4: Feature/Domain Categories

**When to use:** Large projects with distinct features

```
.claude/
├── authentication/
│   ├── oauth-integration.md
│   └── token-handling.md
├── data-processing/
│   ├── pipeline-patterns.md
│   └── workflow-orchestration.md
├── api/
│   ├── endpoint-design.md
│   └── error-handling.md
└── shared.md
```

**Best for:** Microservices, complex features, enterprise systems

## Categorization by Project Type

### React + Node.js Full-Stack

**6-8 files ideal:**

```
.claude/
├── setup.md              # Environment, dev server, scripts
├── typescript.md         # Type safety, interfaces
├── react.md              # Components, hooks, state
├── node-api.md           # Express/Fastify patterns
├── database.md           # ORM, migrations
├── testing.md            # Vitest, Jest, mocking
├── git-workflow.md       # Commits, branches, PRs
└── deployment.md         # Docker, CI/CD, hosting
```

**What goes where:**

| Content | File |
|---------|------|
| Component folder structure | react.md |
| Redux store setup | react.md |
| Async/await in async functions | typescript.md |
| API endpoint naming | node-api.md |
| Database query patterns | database.md |
| Jest configuration | testing.md |
| Commit message format | git-workflow.md |

### Python + FastAPI

**6-7 files ideal:**

```
.claude/
├── setup.md              # Virtual env, pip, scripts
├── python.md             # Type hints, async, dataclasses
├── fastapi.md            # Route design, dependencies
├── database.md           # SQLAlchemy, migrations
├── testing.md            # Pytest fixtures, mocking
├── git-workflow.md       # Commits, branches, PRs
└── deployment.md         # Docker, Heroku/AWS
```

### .NET Core

**5-7 files ideal:**

```
.claude/
├── setup.md              # .NET SDK, restore, build
├── csharp.md             # Async/await, null handling
├── api-design.md         # Controllers, routing, versioning
├── database.md           # EF Core, migrations
├── testing.md            # xUnit, Mocha setup
├── git-workflow.md       # Commits, branches, PRs
└── architecture.md       # DI, patterns, layers
```

### Monorepo (Multiple Apps)

**7-10 files ideal:**

```
.claude/
├── monorepo-structure.md # Workspace setup, package layout
├── shared-code.md        # Common utilities, types
├── frontend.md           # React (or Vue/Svelte)
├── backend.md            # API design, database
├── testing.md            # Testing across workspace
├── git-workflow.md       # Monorepo-specific practices
└── deployment.md         # Publishing, versioning
```

## Grouping Decision Matrix

| Scenario | Decision | Result |
|----------|----------|--------|
| TypeScript + Python project | Create separate files | typescript.md + python.md |
| Multiple testing frameworks | One file with clear sections | testing.md with Jest/Pytest/xUnit sections |
| One language, many frameworks | Separate by framework | typescript.md + react.md + fastapi.md |
| Cross-cutting concern (auth, logging) | Own file | authentication.md, logging.md |
| Project setup (env, scripts) | Root or setup.md? | Root if < 50 lines, else setup.md |
| Performance + Optimization | One file | performance.md |
| Database + ORM + Migrations | One file | database.md |

## File Naming Conventions

### Good Names
Clear, specific, lowercase, hyphenated:

```
react.md                 ✓ Clear what it covers
typescript.md            ✓ Obvious scope
api-design.md            ✓ Specific (not just "api.md")
git-workflow.md          ✓ Not "git.md" (might seem like git commands)
database.md              ✓ Clear (ORM, migrations, queries)
code-style.md            ✓ Covers formatting, linting, naming
```

### Bad Names
Vague, too broad, unclear:

```
guidelines.md            ✗ What guidelines?
best-practices.md        ✗ Covers everything?
conventions.md           ✗ Which conventions?
misc.md                  ✗ Random collection
workflow.md              ✗ Workflow of what?
tools.md                 ✗ Which tools?
development.md           ✗ All development advice?
```

### Naming Pattern
`<domain>[-<subdomain>].md`

Examples:
- `testing.md` - All testing
- `api-design.md` - API design specifically
- `code-style.md` - Code formatting and naming
- `git-workflow.md` - Git practices specifically
- `deployment-aws.md` - Deployment to AWS specifically

## Size Guidelines

After categorization, check file sizes:

| File Size | Assessment |
|-----------|------------|
| < 100 lines | Too small, combine with similar file |
| 100-300 lines | Ideal, rich content |
| 300-500 lines | Getting long, consider splitting |
| 500+ lines | Too long, definitely split |

**Examples of splitting:**

Original: database.md (500 lines)
```
Split into:
- database-setup.md (100 lines) - Connection, migrations
- database-patterns.md (200 lines) - Query patterns, ORM
- database-performance.md (150 lines) - Indexing, optimization
```

Original: testing.md (450 lines)
```
Split into:
- testing-unit.md (150 lines) - Unit test setup and patterns
- testing-integration.md (150 lines) - Database/API integration
- testing-e2e.md (100 lines) - Browser automation
- testing-performance.md (50 lines) - Load testing
```

## Verification Checklist

For each category/file:

- [ ] Single clear topic (passes "what is this file about?" test)
- [ ] 100-300 lines (not too small, not too large)
- [ ] All related content included (nothing scattered elsewhere)
- [ ] No cross-file duplication
- [ ] File name clearly indicates topic
- [ ] Related files cross-reference each other (See Also section)
- [ ] File is independent (doesn't require reading others first)
- [ ] 3-8 files total (not too few, not too many)

## Common Mistakes

### Mistake 1: One Giant File
```
.claude/guidelines.md (2,000 lines)
```
**Fix:** Split into 6-8 focused files

### Mistake 2: Category Per Language/Tech
```
.claude/
├── typescript-style.md
├── typescript-testing.md
├── typescript-api.md
```
**Fix:** Group by concern (style.md, testing.md, api.md)

### Mistake 3: Scattered Related Content
```
Testing setup in setup.md
Test patterns in testing.md
Test coverage in code-quality.md
```
**Fix:** Consolidate all testing in testing.md

### Mistake 4: Too Many Small Files
```
.claude/ (15+ files)
├── naming.md
├── constants.md
├── interfaces.md
├── comments.md
├── errors.md
```
**Fix:** Consolidate into fewer, richer files (code-style.md, patterns.md)

## Example Refactoring

### Before (Monolithic)
```
CLAUDE.md (1,200 lines)
├── Project overview (50 lines)
├── Setup instructions (150 lines)
├── TypeScript conventions (200 lines)
├── React patterns (250 lines)
├── Testing setup (200 lines)
├── API design (150 lines)
└── Deployment (200 lines)
```

### After (Progressive Disclosure)
```
CLAUDE.md (40 lines)
├── Project overview
├── Quick setup reference
└── Links to:
    ├── .claude/setup.md (80 lines)
    ├── .claude/typescript.md (120 lines)
    ├── .claude/react.md (180 lines)
    ├── .claude/testing.md (150 lines)
    ├── .claude/api-design.md (120 lines)
    └── .claude/deployment.md (130 lines)
```

**Token savings:** ~1,200 tokens → ~400-600 per task (60-70% reduction)

## See Also

- [Progressive Disclosure Principles](progressive-disclosure.md) - Why categorization matters
- [Phase 2: Essentials](phase-2-essentials.md) - Deciding file boundaries
- [Phase 4: Structure](phase-4-structure.md) - File naming and organization

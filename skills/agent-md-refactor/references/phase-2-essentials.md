# Phase 2: Deciding What Belongs in Root vs Linked Files

The decision of what content belongs in the root CLAUDE.md versus linked files (.claude/*.md) is critical for effective progressive disclosure. Wrong decisions defeat the purpose.

## Core Decision Principle

**Root = Universal + Immediate**
**Linked = Specific + On-demand**

```
Universal?  +  Needed First?  →  BELONGS IN ROOT
     ✓              ✓
     ✓              ✗          →  LINKED FILE (critical)
     ✗              ✓          →  LINKED FILE (common)
     ✗              ✗          →  LINKED FILE (specialized)
```

## Decision Tree

```
┌─ Is this true for EVERY file/function/task in the project?
│  ├─ YES → Is agent likely to need it on FIRST read?
│  │        ├─ YES → ROOT (package manager, critical overrides)
│  │        └─ NO  → LINKED (language conventions, patterns)
│  │
│  └─ NO  → Is it specific to one technology/concern?
│           ├─ YES → LINKED (React guidelines, Testing, API design)
│           └─ NO  → GROUP WITH RELATED TOPICS
```

## Content by Category

### Definitely ROOT (Always Include)

#### 1. Project Identity
**Why:** Agent needs to understand project instantly
**Token cost:** Low (1-2 lines)

```markdown
# MyProject

Real-time analytics dashboard using React 18 and FastAPI.
```

#### 2. Non-Default Package Manager
**Why:** Agent must use right tool immediately
**Token cost:** Low (1 line)

```markdown
Package manager: `pnpm` (not npm or yarn)
```

**Examples that need root:**
- `pnpm` instead of npm
- `pip` in unusual way (poetry/conda)
- `make` or `task` as primary build tool
- `.venv` path different from standard

**Not needed:**
- "Use npm" (npm is default)
- "Use pip" (pip is default for Python)
- "Use gradle" (gradle is default for Java)

#### 3. Critical Overrides
**Why:** Must override agent defaults immediately
**Token cost:** Low (1-2 lines)

Critical overrides are things that MUST happen:

```markdown
IMPORTANT: Commit messages MUST follow Conventional Commits format.
This enforces them: git config core.hooksPath .githooks
```

Not critical (can be in linked file):
- "Prefer kebab-case for file names" (nice to have)
- "Use 2 spaces for indent" (standard best practice)

#### 4. Essential Links
**Why:** Agent needs map to detailed instructions
**Token cost:** Low (1 line per file)

```markdown
## Guidelines
- [TypeScript Conventions](.claude/typescript.md)
- [Testing](.claude/testing.md)
- [Git Workflow](.claude/git-workflow.md)
```

### Definitely LINKED (Create Topic Files)

#### Content Pattern: Technology-Specific Rules
Move entire sections about specific languages/frameworks:

**Examples:**
- TypeScript conventions (all TS rules)
- React patterns (all React rules)
- Python testing (all pytest/unittest rules)
- .NET architecture (all EF Core/dependency injection)

```markdown
# Move from Root → Create .claude/typescript.md

Types vs Interfaces
- Prefer interfaces for object contracts
- Use types for unions and type aliases
- Use const assertions for literal types

Type Safety Rules
- Strict mode enabled
- No implicit any
- Strict null checks
```

#### Content Pattern: Topic-Specific Rules
Move entire sections about concerns that cross all tech:

**Examples:**
- Testing (all test framework rules, coverage targets)
- Git workflow (branch strategy, commit rules)
- API design (endpoint naming, versioning)
- Security (authentication, validation, secrets)

```markdown
# Move from Root → Create .claude/testing.md

Unit Testing
- Use Vitest for speed
- Coverage > 80%
- One assertion per test (arrange-act-assert)

Integration Testing
- Database tests must be isolated
- Use test fixtures for setup
- Clean up after each test
```

#### Content Pattern: Environment-Specific Rules
Move rules that only apply in certain contexts:

**Examples:**
- Local development setup
- Docker configuration
- CI/CD pipeline
- Production deployment

```markdown
# Move from Root → Create .claude/deployment.md

Local Development
- Use docker-compose up
- Environment: .env.local
- See dev_tools/docker/README.md

Production
- Docker build includes health checks
- Environment variables managed in GitHub Secrets
- See terraform/ for infrastructure
```

## Decision Matrix: Common Content

| Content | Root? | Why | Alternative |
|---------|-------|-----|------------|
| Project description | YES | Identity | None |
| `npm install` command | NO | Standard | Link to [Setup](.claude/setup.md) |
| `npm run test` custom command | YES | Non-standard | None |
| TypeScript config rules | NO | Language-specific | [TypeScript](.claude/typescript.md) |
| Prettier config | NO | Code style | [Code Style](.claude/code-style.md) |
| Git branch strategy | NO | Workflow | [Git Workflow](.claude/git-workflow.md) |
| "Use async/await" | NO | Language detail | [JavaScript](.claude/javascript.md) |
| "Don't commit secrets" | NO | Universal best practice | Delete (agent knows) |
| "Use descriptive names" | NO | Universal best practice | Delete (agent knows) |
| "Write tests" | NO | Universal best practice | Delete (agent knows) |
| Authentication pattern | NO | Architecture | [Architecture](.claude/architecture.md) |
| Component folder structure | NO | Framework-specific | [React](.claude/react.md) |
| Database transaction rules | NO | Infrastructure | [Database](.claude/database.md) |
| Linting setup | NO | Tooling | [Code Style](.claude/code-style.md) |
| Build optimization | NO | Performance | [Performance](.claude/performance.md) |

## Token Cost Analysis

### Root File Examples

**Bad (200+ lines):**
```
Root file cost: ~1,200 tokens
Every task loads all 200 lines
Frontend task doesn't need backend instructions
```

**Good (30-40 lines):**
```
Root file cost: ~150 tokens
Links cost ~50 tokens per file loaded
Frontend task loads root + React file (~200 tokens total)
Backend task loads root + API file (~200 tokens total)
Savings: ~1,000 tokens per task
```

## Examples by Project Type

### React Project - What Goes in Root

**Good root (40 lines):**
```markdown
# Web Application

Web application for managing data flows.
Built with React 18, TypeScript, Material-UI.

## Setup
npm install && npm run dev

## Scripts
- `npm run dev` - Dev server (Vite)
- `npm run build` - Production build
- `npm run test` - Tests with coverage
- `npm run lint` - Linting and formatting

## Guidelines
- [TypeScript](https://www.typescriptlang.org/docs/)
- [React Patterns](.claude/react.md)
- [Testing](.claude/testing.md)
- [API Integration](.claude/api.md)
```

**Linked files:**
- .claude/react.md (component patterns, hooks)
- .claude/testing.md (Vitest setup, coverage)
- .claude/api.md (API calls, error handling)

### Python Project - What Goes in Root

**Good root (35 lines):**
```markdown
# Data Processing Pipeline

Prefect workflow system for data processing and orchestration.

## Setup
python -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate (Windows)
pip install -r requirements.txt

## Commands
- `python -m src.flows.main` - Run main flow
- `prefect server start` - Local Prefect server
- `pytest tests/ -v --cov` - Tests with coverage

## Guidelines
- [Python Style](.claude/python.md)
- [Testing](.claude/testing.md)
- [Database](.claude/database.md)
- [Prefect Workflows](.claude/prefect.md)
```

**Linked files:**
- .claude/python.md (type hints, async patterns)
- .claude/testing.md (pytest fixtures, mocking)
- .claude/database.md (ORM patterns)
- .claude/prefect.md (flow/task patterns)

### .NET Project - What Goes in Root

**Good root (38 lines):**
```markdown
# REST API Service

.NET 8 administration API service.

## Setup
cd backend/api-service
dotnet restore
dotnet build

## Commands
- `dotnet run --project src/Api.Admin` - Run API
- `dotnet test` - Tests with coverage
- `dotnet ef migrations add InitialSchema` - Database migrations

## Guidelines
- [C# Standards](.claude/csharp.md)
- [API Design](.claude/api-design.md)
- [Testing](.claude/testing.md)
- [Database & ORM](.claude/database.md)
```

**Linked files:**
- .claude/csharp.md (async, dependency injection)
- .claude/api-design.md (REST conventions, versioning)
- .claude/testing.md (xUnit, mocking)
- .claude/database.md (EF Core patterns)

## Red Flags for Linked File Content

These indicate content should NOT be in root:

### Red Flag 1: "Optional" Content
```markdown
# BAD in root
You can optionally use Redux for state management.
Or use Context API if you prefer.
Or use Jotai...
```

**Fix:** Remove (or create .claude/state-management.md with decision made)

### Red Flag 2: Multiple Rules for One Topic
```markdown
# BAD in root
## Testing
- Use Jest for unit tests
- Consider Mocha for integration tests
- Some teams prefer Vitest

## Code Formatting
- ESLint for linting
- Maybe use Prettier
- Or configure your editor
```

**Fix:** Create .claude/testing.md and .claude/code-style.md with one decision each

### Red Flag 3: "Usually" or "Typically"
```markdown
# BAD in root
We typically use TypeScript.
Usually we prefer async/await.
Most components use hooks.
```

**Fix:** Make it definitive or move to linked file

### Red Flag 4: Historical Context
```markdown
# BAD in root
We used to use Webpack but switched to Vite.
Old class components are still in codebase.
Legacy code uses var instead of const.
```

**Fix:** Create .claude/migration-guide.md or .claude/legacy-notes.md if helpful, otherwise delete

## Verification Checklist

For each piece of content:

- [ ] Is it universal across project? (If no → linked file)
- [ ] Is it needed on first read? (If no → linked file)
- [ ] Is it short and actionable? (If no → linked file)
- [ ] Does agent need it for 80% of tasks? (If no → linked file)
- [ ] Is it configuration-specific? (If yes → linked file)
- [ ] Is it technology-specific? (If yes → linked file)
- [ ] Does root have this topic's other rules? (If no → needs linked file)

## See Also

- [Progressive Disclosure Principles](progressive-disclosure.md) - Core concepts
- [Phase 1: Contradictions](phase-1-contradictions.md) - Resolve conflicts first
- [Phase 3: Categorization](phase-3-categorization.md) - Grouping into files
- [Phase 4: Structure](phase-4-structure.md) - File naming and organization

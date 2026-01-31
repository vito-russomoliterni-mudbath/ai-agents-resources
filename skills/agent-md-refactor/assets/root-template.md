# Root Template: Minimal Agent Instruction File

Use this template as the foundation for your CLAUDE.md or project-level instruction files. The goal is to keep the root file under 50 lines with just essential information and links to detailed guidance.

## Template Structure (Copy & Adapt)

```markdown
# [Project Name] - Agent Instructions

## Quick Start
[1-2 sentence project description]

### Prerequisites
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

### Core Commands
\`\`\`bash
[Command 1]
[Command 2]
[Command 3]
\`\`\`

## Documentation
- [Architecture & Components](.claude/architecture.md) - System design, structure, components
- [Development Workflow](.claude/development.md) - Adding features, conventions, patterns
- [Deployment & Operations](.claude/deployment.md) - CI/CD, production setup, monitoring
- [Related Links](#related-links) - External docs, repos, resources

---

**Total lines: ~35-45 | Token count: ~500-700 tokens**
```

---

## Example 1: Python Data Pipeline Project

```markdown
# Data Processing Pipeline - Agent Instructions

## Quick Start
Python-based Prefect workflow system for processing file data and inspection reports. Orchestrates file parsing, data extraction, database operations, and generates analytical insights.

### Prerequisites
- Python 3.8+
- SQL Server with pyodbc driver
- Prefect 3.6.6+

### Core Commands
\`\`\`bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python -m src.file_system.flows.processing_flows
prefect server start
\`\`\`

## Documentation
- [Architecture & Components](.claude/architecture.md) - Flows, tasks, handlers, data models
- [Development Workflow](.claude/development.md) - Adding flows, database integration
- [Deployment & Operations](.claude/deployment.md) - GitHub Actions, environment variables
- [Setup Guide](./Readme.md) - Prefect, WSL, SQL Server connectivity

---

**File location**: `tools/data-processor/CLAUDE.md`
```

---

## Example 2: TypeScript/React Frontend Project

```markdown
# Web Application - Agent Instructions

## Quick Start
React/TypeScript web application for asset management with Material-UI components, Redux state management, and 3D visualization using Three.js.

### Prerequisites
- Node.js 18+
- npm or yarn
- TypeScript 4.9.5+

### Core Commands
\`\`\`bash
npm install
npm run dev          # Development server
npm run build        # Production build
npm run test         # Run tests with Vitest
npm run lint         # Check code quality
\`\`\`

## Documentation
- [Code Style & Architecture](.claude/code-style.md) - TypeScript conventions, component patterns
- [Testing Strategy](.claude/testing.md) - Unit, integration, E2E test guidelines
- [UI Components](.claude/components.md) - Material-UI usage, custom components
- [State Management](.claude/state.md) - Redux patterns, API data flow

---

**File location**: `frontend/web-app/CLAUDE.md`
```

---

## Example 3: .NET Backend API Project

```markdown
# REST API Service - Agent Instructions

## Quick Start
.NET 8.0 Core API backend with Entity Framework Core, PostgreSQL, and Azure Functions. Provides admin, document conversion, and data sync services.

### Prerequisites
- .NET 8.0 SDK
- PostgreSQL 13+
- Docker (for local services)

### Core Commands
\`\`\`bash
cd backend/api-service
dotnet restore
dotnet build
dotnet test
dotnet run --project src/Api.Admin
\`\`\`

## Documentation
- [Architecture & Services](.claude/architecture.md) - Project structure, dependency injection patterns
- [Development Guidelines](.claude/development.md) - C# conventions, API design, Entity Framework
- [Database & Migrations](.claude/database.md) - Schema, EF migrations, seeding
- [Testing & CI/CD](.claude/testing.md) - Unit tests, xUnit patterns, GitHub Actions

---

**File location**: `backend/api-service/CLAUDE.md`
```

---

## Key Guidelines for Root Files

1. **Keep it minimal** - Max 40-50 lines of actual content (excludes template section)
2. **One-sentence project description** - What does this solve?
3. **Quick commands** - Just the essentials to get started
4. **Link early, link often** - Use linked files for deep dives
5. **Consistent structure** - Use same headings across all root files in organization
6. **Update frequently** - Root file changes should be quick wins

## When to Reference Details

- ✅ Link to `.claude/` files for conventions, patterns, architecture
- ✅ Link to external docs for library-specific information
- ✅ Keep commands to top 3-5 most used
- ❌ Don't repeat details available in linked files
- ❌ Don't list every dependency (use requirements.txt / package.json)
- ❌ Don't include code snippets longer than 5 lines

## Conversion Checklist

When converting a bloated CLAUDE.md to progressive disclosure:

- [ ] Extract all architectural details → `architecture.md`
- [ ] Extract all development rules → `development.md`
- [ ] Extract all setup/testing → `operations.md`
- [ ] Extract all deployment → `deployment.md`
- [ ] Keep root file under 50 lines
- [ ] Add "See Also" section with all linked files
- [ ] Test all links work correctly
- [ ] Verify token count reduction (typically 60-75% reduction)

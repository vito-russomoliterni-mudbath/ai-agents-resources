# Verification Patterns

This guide covers verification strategies for ensuring features work correctly through testing, linting, and validation.

## Testing Strategies

### Unit Testing

**Purpose**: Test individual functions, methods, or components in isolation

**When to Run**:
- After implementing new functions/components
- Before committing changes
- As part of CI/CD pipeline

**Common Frameworks**:
- **JavaScript/TypeScript**: Jest, Vitest, Mocha
- **Python**: pytest, unittest
- **C#/.NET**: xUnit, NUnit, MSTest
- **Java**: JUnit, TestNG

**Example Commands**:
```bash
# JavaScript/TypeScript
npm test                    # Run all tests
npm test -- --watch         # Watch mode
npm test -- ComponentName   # Specific test

# Python
pytest                      # Run all tests
pytest tests/test_module.py # Specific file
pytest -k "test_name"       # Specific test
pytest -v                   # Verbose

# .NET
dotnet test                 # Run all tests
dotnet test --filter "FullyQualifiedName~UnitTest"
dotnet test --logger "console;verbosity=detailed"
```

### Integration Testing

**Purpose**: Test interactions between components, APIs, or services

**When to Run**:
- After implementing API endpoints
- When testing database interactions
- Before major releases

**Example Commands**:
```bash
# JavaScript/TypeScript
npm run test:integration
npm run test:e2e

# Python
pytest tests/integration/
pytest --integration

# .NET
dotnet test --filter "Category=Integration"
```

### Finding Test Files

**Using Glob Tool**:
```
Pattern: "**/*.test.*"        # JavaScript/TypeScript
Pattern: "**/*.spec.*"        # Angular/Jasmine
Pattern: "**/test_*.py"       # Python
Pattern: "**/*Tests.cs"       # C#
```

**Using Grep Tool**:
```
Pattern: "describe\(|it\(|test\("    # JavaScript test functions
Pattern: "def test_"                  # Python test functions
Pattern: "\[Test\]|\[Fact\]"          # C# test attributes
```

## Linting and Code Quality

### JavaScript/TypeScript

**ESLint**:
```bash
# Run linter
npm run lint
npx eslint src/

# Fix auto-fixable issues
npm run lint -- --fix
npx eslint src/ --fix

# Check specific files
npx eslint src/components/MyComponent.tsx
```

**TypeScript Compiler**:
```bash
# Type checking
npx tsc --noEmit
npm run type-check

# Watch mode
npx tsc --noEmit --watch
```

**Prettier (Formatting)**:
```bash
# Check formatting
npx prettier --check src/

# Fix formatting
npx prettier --write src/
```

### Python

**Ruff (Modern Linter)**:
```bash
# Run linter
ruff check .
ruff check src/

# Fix auto-fixable issues
ruff check --fix .

# Specific rules
ruff check --select E,F,I .  # Error, Pyflakes, Import
```

**Black (Formatter)**:
```bash
# Check formatting
black --check .

# Format code
black .
```

**mypy (Type Checker)**:
```bash
# Type checking
mypy src/
mypy --strict src/
```

### .NET

**dotnet format**:
```bash
# Check formatting
dotnet format --verify-no-changes

# Fix formatting
dotnet format
```

**Code Analysis**:
```bash
# Run analyzers
dotnet build /p:RunAnalyzersDuringBuild=true

# Treat warnings as errors
dotnet build /p:TreatWarningsAsErrors=true
```

## Manual Verification

### Running Development Servers

**Node.js/JavaScript**:
```bash
# Vite
npm run dev
npx vite

# Next.js
npm run dev
npx next dev

# Create React App
npm start

# Express API
npm run dev
node server.js
```

**Python**:
```bash
# Flask
flask run
python app.py

# FastAPI
uvicorn main:app --reload
fastapi dev main.py

# Django
python manage.py runserver
```

**.NET**:
```bash
# Run project
dotnet run

# Watch mode (auto-reload)
dotnet watch run

# Specific project
dotnet run --project src/MyProject
```

### API Testing

**curl**:
```bash
# GET request
curl http://localhost:3000/api/endpoint

# POST request with JSON
curl -X POST http://localhost:3000/api/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'

# With authentication
curl -H "Authorization: Bearer token" \
  http://localhost:3000/api/endpoint
```

**httpie** (if available):
```bash
# GET request
http localhost:3000/api/endpoint

# POST request
http POST localhost:3000/api/endpoint key=value

# With authentication
http localhost:3000/api/endpoint Authorization:"Bearer token"
```

## Build Verification

### JavaScript/TypeScript

```bash
# Production build
npm run build

# Check build output
ls -lh dist/

# Verify build works
npm run preview  # Vite
npm run start    # Next.js production
```

### Python

```bash
# Install in editable mode
pip install -e .

# Build distribution
python -m build

# Check package
twine check dist/*
```

### .NET

```bash
# Build solution
dotnet build

# Release build
dotnet build --configuration Release

# Publish
dotnet publish --configuration Release --output ./publish
```

## Database Verification

### Migrations

**Python (Alembic/Django)**:
```bash
# Check migration status
alembic current
python manage.py showmigrations

# Create migration
alembic revision --autogenerate -m "description"
python manage.py makemigrations

# Apply migration
alembic upgrade head
python manage.py migrate

# Rollback migration
alembic downgrade -1
python manage.py migrate app_name previous_migration
```

**.NET (Entity Framework)**:
```bash
# Check migration status
dotnet ef migrations list

# Create migration
dotnet ef migrations add MigrationName

# Apply migration
dotnet ef database update

# Rollback migration
dotnet ef database update PreviousMigrationName
```

### Database Queries

**PostgreSQL**:
```bash
# Connect to database
psql -U username -d database_name

# Run query
psql -U username -d database_name -c "SELECT * FROM table_name;"
```

**SQL Server**:
```bash
# Using sqlcmd
sqlcmd -S server -d database -Q "SELECT * FROM table_name;"
```

## Code Coverage

### JavaScript/TypeScript

**Vitest**:
```bash
# Run with coverage
npx vitest --coverage

# Coverage threshold
npx vitest --coverage --coverage.lines 80
```

**Jest**:
```bash
# Run with coverage
npm test -- --coverage

# Coverage threshold in package.json
{
  "jest": {
    "coverageThreshold": {
      "global": {
        "lines": 80
      }
    }
  }
}
```

### Python

**pytest with coverage**:
```bash
# Run with coverage
pytest --cov=src

# Coverage report
pytest --cov=src --cov-report=html
pytest --cov=src --cov-report=term-missing

# Coverage threshold
pytest --cov=src --cov-fail-under=80
```

### .NET

```bash
# Run with coverage
dotnet test --collect:"XPlat Code Coverage"

# Generate report (requires ReportGenerator)
reportgenerator \
  -reports:"**/coverage.cobertura.xml" \
  -targetdir:"coveragereport" \
  -reporttypes:Html
```

## Performance Verification

### JavaScript/TypeScript

**Lighthouse** (for web apps):
```bash
# Run Lighthouse
npx lighthouse http://localhost:3000 --view

# Performance only
npx lighthouse http://localhost:3000 --only-categories=performance
```

**Bundle Size**:
```bash
# Analyze bundle (Vite)
npx vite-bundle-visualizer

# Analyze bundle (webpack)
npx webpack-bundle-analyzer dist/stats.json
```

### Python

**Profiling**:
```bash
# cProfile
python -m cProfile script.py

# line_profiler (if installed)
kernprof -l script.py
python -m line_profiler script.py.lprof
```

### .NET

**Benchmarking**:
```bash
# BenchmarkDotNet
dotnet run --configuration Release --project Benchmarks/
```

## Security Verification

### Dependency Scanning

**JavaScript/TypeScript**:
```bash
# npm audit
npm audit
npm audit fix

# Specific severity
npm audit --audit-level=moderate
```

**Python**:
```bash
# pip-audit
pip-audit

# Safety
safety check
```

**.NET**:
```bash
# dotnet list vulnerable packages
dotnet list package --vulnerable
dotnet list package --vulnerable --include-transitive
```

### Static Analysis Security Testing (SAST)

**JavaScript/TypeScript**:
```bash
# ESLint security plugins
npm install --save-dev eslint-plugin-security
npx eslint --plugin security src/
```

**Python**:
```bash
# Bandit
bandit -r src/

# With config
bandit -r src/ -c .bandit.yml
```

## Verification Checklist

Before marking a feature complete, verify:

### Functionality
- [ ] Feature works as expected (manual testing)
- [ ] All unit tests pass
- [ ] Integration tests pass (if applicable)
- [ ] Edge cases handled correctly
- [ ] Error cases handled appropriately

### Code Quality
- [ ] Linter passes with no errors
- [ ] Type checker passes (TypeScript/mypy)
- [ ] Code formatted correctly
- [ ] No security warnings from linter

### Performance
- [ ] No obvious performance regressions
- [ ] Build completes successfully
- [ ] Bundle size is reasonable (for frontend)

### Database
- [ ] Migrations apply successfully
- [ ] Migrations are reversible
- [ ] Database queries are efficient
- [ ] Data integrity maintained

### Documentation
- [ ] Code is self-documenting (clear naming)
- [ ] Complex logic has comments
- [ ] API changes documented (if applicable)
- [ ] README updated (if needed)

### Security
- [ ] No dependency vulnerabilities
- [ ] Input validation in place
- [ ] No SQL injection risks
- [ ] No XSS vulnerabilities
- [ ] Authentication/authorization correct

## Common Verification Issues

### Issue: Tests Pass Locally But Fail in CI

**Causes**:
- Environment differences (Node version, Python version)
- Missing environment variables
- Database not seeded properly
- Timing issues (race conditions)

**Solutions**:
- Match local environment to CI
- Check CI logs for specific errors
- Add retries for flaky tests
- Use environment-agnostic configurations

### Issue: Linter Fails on Different Platform

**Causes**:
- Line ending differences (CRLF vs LF)
- Path separator differences (Windows vs Unix)
- Case sensitivity differences

**Solutions**:
- Configure .gitattributes for line endings
- Use cross-platform path utilities
- Run linter on all platforms before committing

### Issue: Build Succeeds but Runtime Fails

**Causes**:
- Type errors not caught by TypeScript
- Missing runtime dependencies
- Environment-specific code

**Solutions**:
- Enable strict TypeScript checking
- Test in production-like environment
- Use runtime validation libraries (zod, joi)

## See Also

- [Planning Strategies](planning-strategies.md) - Including verification in planning
- [QA Checklist](qa-checklist.md) - Comprehensive quality assurance guide
- [Cross-Platform Commands](cross-platform-commands.md) - Platform-specific command equivalents

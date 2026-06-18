# Cross-Platform Commands

This guide provides Bash and PowerShell equivalents for common development tasks. Use the appropriate command for your platform.

## File Search

### Find Files by Name Pattern

**Bash (Linux/macOS/WSL):**
```bash
# Find TypeScript files
find . -name "*.ts" -type f

# Find files matching multiple patterns
find . -name "*component*" -o -name "*service*"

# Find files excluding directories
find . -name "*.py" -not -path "./venv/*" -not -path "./.venv/*"
```

**PowerShell (Windows):**
```powershell
# Find TypeScript files
Get-ChildItem -Recurse -Filter "*.ts" -File

# Find files matching patterns
Get-ChildItem -Recurse -Include "*component*","*service*" -File

# Find files excluding directories
Get-ChildItem -Recurse -Filter "*.py" -File | Where-Object { $_.FullName -notmatch "venv|\.venv" }
```

**Glob Tool (Preferred - Cross-Platform):**
```
Use Glob tool with pattern: "**/*.ts"
Use Glob tool with pattern: "**/*component*"
Use Glob tool with pattern: "**/*.py"
```

### List Directory Structure

**Bash:**
```bash
# Simple list
ls -R src/

# Tree view (if tree is installed)
tree src/

# List with details
ls -lah src/
```

**PowerShell:**
```powershell
# Simple list
Get-ChildItem -Recurse src/

# List with details
Get-ChildItem -Recurse src/ | Format-Table Name,Length,LastWriteTime
```

## Content Search

### Search for Text in Files

**Bash (using grep):**
```bash
# Search for pattern
grep -r "pattern" src/

# Search with line numbers
grep -rn "pattern" src/

# Search case-insensitive
grep -ri "pattern" src/

# Search for exact word
grep -rw "function_name" src/

# Search with context (3 lines before/after)
grep -rn -C 3 "pattern" src/

# Search in specific file types
grep -r "pattern" --include="*.ts" src/
```

**PowerShell (using Select-String):**
```powershell
# Search for pattern
Get-ChildItem -Recurse src/ | Select-String "pattern"

# Search with line numbers (default)
Get-ChildItem -Recurse src/ | Select-String "pattern" | Select-Object Path,LineNumber,Line

# Search case-insensitive (default in PowerShell)
Get-ChildItem -Recurse src/ | Select-String "pattern"

# Search in specific file types
Get-ChildItem -Recurse src/ -Filter "*.ts" | Select-String "pattern"
```

**Grep Tool (Preferred - Cross-Platform):**
```
Use Grep tool with pattern: "pattern"
Use Grep tool with pattern: "function_name", glob: "*.ts"
Use Grep tool with pattern: "pattern", output_mode: "content", -C: 3
```

### Count Matches

**Bash:**
```bash
# Count matching lines
grep -rc "pattern" src/

# Count files with matches
grep -rl "pattern" src/ | wc -l
```

**PowerShell:**
```powershell
# Count matching lines
(Get-ChildItem -Recurse src/ | Select-String "pattern").Count

# Count files with matches
(Get-ChildItem -Recurse src/ | Select-String "pattern" | Select-Object -Unique Path).Count
```

## Running Tests

### Node.js/JavaScript/TypeScript

**Cross-Platform:**
```bash
# npm scripts (work on all platforms)
npm test
npm run test:unit
npm run test:e2e
npm run test:watch

# Direct test runner execution
npx jest
npx vitest
npx mocha
```

### Python

**Cross-Platform:**
```bash
# pytest (works on all platforms)
pytest
pytest tests/
pytest -v  # verbose
pytest -k "test_pattern"  # run specific tests

# unittest
python -m unittest
python -m unittest discover
```

### .NET

**Cross-Platform:**
```bash
# dotnet CLI (works on all platforms)
dotnet test
dotnet test --filter "FullyQualifiedName~UnitTests"
dotnet test --logger "console;verbosity=detailed"
```

## Linting and Formatting

### JavaScript/TypeScript

**Cross-Platform:**
```bash
# ESLint
npm run lint
npx eslint src/

# Prettier
npm run format
npx prettier --check src/
npx prettier --write src/

# TypeScript compiler
npx tsc --noEmit
```

### Python

**Cross-Platform:**
```bash
# Ruff (modern linter)
ruff check .
ruff check --fix .

# Black (formatter)
black .
black --check .

# mypy (type checker)
mypy src/
```

### .NET

**Cross-Platform:**
```bash
# dotnet format
dotnet format --verify-no-changes
dotnet format
```

## Running Development Servers

### Node.js

**Cross-Platform:**
```bash
npm run dev
npm start
npx vite
npx next dev
```

### Python

**Cross-Platform:**
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

### .NET

**Cross-Platform:**
```bash
dotnet run
dotnet watch run
```

## File Operations

### Reading File Content

**Bash:**
```bash
# Show entire file
cat file.txt

# Show with line numbers
cat -n file.txt

# Show first 20 lines
head -n 20 file.txt

# Show last 20 lines
tail -n 20 file.txt
```

**PowerShell:**
```powershell
# Show entire file
Get-Content file.txt

# Show first 20 lines
Get-Content file.txt -Head 20

# Show last 20 lines
Get-Content file.txt -Tail 20
```

**Read Tool (Preferred - Cross-Platform):**
```
Use Read tool with file_path parameter
Use Read tool with offset and limit for large files
```

### Checking File Existence

**Bash:**
```bash
# Check if file exists
if [ -f "file.txt" ]; then echo "exists"; fi

# Check if directory exists
if [ -d "dir/" ]; then echo "exists"; fi
```

**PowerShell:**
```powershell
# Check if file exists
Test-Path "file.txt" -PathType Leaf

# Check if directory exists
Test-Path "dir/" -PathType Container
```

## Process Management

### Running Background Commands

**Bash:**
```bash
# Run in background
npm run dev &

# View background jobs
jobs

# Bring to foreground
fg %1
```

**PowerShell:**
```powershell
# Run in background job
Start-Job -ScriptBlock { npm run dev }

# View jobs
Get-Job

# Get job output
Receive-Job -Id 1
```

**Bash Tool with run_in_background (Preferred):**
```
Use Bash tool with run_in_background: true
Check output with TaskOutput tool
```

## Environment Variables

### Setting Variables

**Bash:**
```bash
# Set for current session
export API_KEY="secret"

# Set for single command
API_KEY="secret" npm run dev

# Load from .env file
source .env
```

**PowerShell:**
```powershell
# Set for current session
$env:API_KEY = "secret"

# Set for single command
$env:API_KEY = "secret"; npm run dev

# Load from .env file (requires parsing)
Get-Content .env | ForEach-Object {
    if ($_ -match '^([^=]+)=(.*)$') {
        [Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
}
```

## Working with Git

### Common Git Commands (Cross-Platform)

```bash
# Status
git status

# Diff
git diff
git diff --staged

# Log
git log --oneline -10
git log --graph --oneline --all

# Branches
git branch
git checkout -b new-feature
git switch main

# Staging and committing
git add file.txt
git commit -m "message"

# Comparing branches
git diff main...feature-branch
git log main..feature-branch
```

## Package Management

### Node.js (Cross-Platform)

```bash
# npm
npm install
npm install package-name
npm install --save-dev package-name
npm run script-name

# yarn
yarn install
yarn add package-name
yarn add -D package-name
yarn script-name

# pnpm
pnpm install
pnpm add package-name
pnpm add -D package-name
pnpm script-name
```

### Python (Cross-Platform)

```bash
# pip
pip install -r requirements.txt
pip install package-name
pip list

# poetry
poetry install
poetry add package-name
poetry run python script.py

# pipenv
pipenv install
pipenv install package-name
pipenv run python script.py
```

### .NET (Cross-Platform)

```bash
# dotnet CLI
dotnet restore
dotnet add package PackageName
dotnet list package
```

## Best Practices

### Prefer Cross-Platform Tools

1. **Use Built-in Claude Code Tools**: Grep, Glob, Read, Bash
2. **Use language-specific CLIs**: npm, dotnet, pip (all cross-platform)
3. **Avoid platform-specific commands**: When possible, use cross-platform alternatives

### When to Use Platform-Specific Commands

Use platform-specific commands when:
- The command is significantly more efficient
- The feature is only available on that platform
- Working in a known platform environment
- Document platform requirement clearly

### Document Platform Requirements

If using platform-specific commands:
```bash
# PowerShell only
# Requires: Windows with PowerShell 5.1+
Get-ChildItem -Recurse | Select-String "pattern"

# Bash only
# Requires: Linux/macOS or WSL
find . -type f -exec grep -l "pattern" {} \;
```

## See Also

- [Planning Strategies](planning-strategies.md) - Using these commands in planning
- [Verification Patterns](verification-patterns.md) - Testing and verification commands
- [scripts/cross-platform-search.sh](../scripts/cross-platform-search.sh) - Example search scripts

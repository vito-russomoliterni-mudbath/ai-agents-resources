---
name: running-isolated-subagents
description: Guides the usage of the isolated subagent runner MCP tool (execute_subagent_task) to safely implement features, run database migrations, and validate edits within a secure, containerized sandbox environment.
version: 1.0.0
---

# Running Isolated Subagents Workflow

## Overview

This skill describes how to run complex code modification, database migration, and test verification tasks within a secure, containerized sandbox environment using the `execute_subagent_task` MCP tool. 

By executing changes inside a Docker/Podman container using a temporary Git worktree, the host developer workspace remains clean and untracked changes/git index are never corrupted.

```mermaid
graph TD
    A[Start task] --> B[Host environment profiler checks locks/engine]
    B --> C[Create non-destructive workspace snapshot commit]
    C --> D[Spawn temporary detached Git worktree]
    D --> E[Start credential socket proxy & companion DB container]
    E --> F[Spin up sandbox container & run pre-edit migrations]
    F --> G[Execute OpenCode runner inside sandbox container]
    G --> H[Check migration globs & run database catch-up/healing]
    H --> I[Execute host project verification tests]
    I --> J[Stage/Commit worktree edits & register sdd/task-id branch]
    J --> K[Teardown containers, proxies, worktree & snapshots]
    K --> L[Finish task]
```

---

## When to Use

Use this skill when:
- Implementing new features or fixing bugs that require containerized tools, package installation, or external runtime execution.
- Executing database migrations, seeding, or setup scripts that should be isolated to prevent dev database corruption.
- Testing code changes against live companion containers (like PostgreSQL or Redis) in a sandbox environment.
- Safely executing untrusted or experimental code modifications without risking host system files.

---

## Workflow

### 1. Configuration & Registration

To use the isolated subagent runner MCP server, it must be registered with Claude Code or Gemini. The MCP server can be started globally.

#### MCP Configuration Block
Add the following to your global agent configurations (e.g. `~/.claude.json` or `~/.config/claude/config.json`):

```json
{
  "mcpServers": {
    "isolated-subagent-runner": {
      "command": "python3",
      "args": ["/absolute/path/to/ai-agents-resources/mcp-servers/isolated-subagent-runner/mcp_server.py"],
      "env": {
        "OPENCODE_API_KEY": "your_opencode_api_key_here",
        "OPENCODE_API_URL": "https://api.opencode.ai/v1/chat/completions",
        "OPENCODE_MODEL": "gpt-5.1-codex-mini"
      }
    }
  }
}
```

### 2. Invoke the Tool

Call the `execute_subagent_task` tool with a structured JSON payload defining the task parameters.

#### Schema Fields
- `task_id`: Unique, short, lowercase alphanumeric slug (e.g. `issue-19`, `feat-auth`). You MUST auto-generate this slug based on the active ticket, issue, or branch name. Do NOT prompt the user to input or confirm the `task_id`.
- `summary`: High-level explanation of the code modifications to perform.
- `files_to_read`: List of workspace-relative paths to read as context.
- `instructions`: List of file modification objects:
  - `file_path`: Relative path of the file to touch.
  - `action`: `CREATE`, `MODIFY`, or `DELETE`.
  - `description`: Detailed instructions for the LLM editing this specific file.
- `migration_file_globs`: Glob patterns to match against changed files to detect migration changes (e.g., `["db/migrate/*.rb", "migrations/*.py"]`).
- `setup_commands`: Environment or package dependency installation commands to run before execution (e.g. `["npm install"]`, `["bundle install"]`, `["pip install -r requirements.txt"]`). Since the container starts clean, you MUST include any package installations here if compilation, linting, or tests require them.
- `db_setup_commands`: Ephemeral database migration/setup commands (e.g., `["bundle exec rails db:migrate"]`, `["python manage.py migrate"]`).
- `verification_commands`: Verification commands to run inside the container (e.g., `["bundle exec rspec"]`, `["npm test"]`, `["npx tsc --noEmit"]`).
- `resource_bounds`: `{ "max_steps": 10, "timeout_seconds": 600 }`.
- `environment_requirements`:
  - `database`: Companion database type (`"postgres"`, `"redis"`, or `"none"`).
  - `forward_credentials`: Forwarding agents (`["ssh-agent"]`).
  - `environment_overrides`: Custom environment variables dictionary.

---

## Framework Templates

### 1. Django / Python
```json
{
  "task_id": "django-user-profile",
  "summary": "Add user profile fields and run migrations",
  "files_to_read": ["myapp/models.py"],
  "instructions": [
    {
      "file_path": "myapp/models.py",
      "action": "MODIFY",
      "description": "Add a new bio TextField and birth_date DateField to the UserProfile model."
    }
  ],
  "migration_file_globs": ["**/migrations/*.py"],
  "db_setup_commands": [
    "python manage.py migrate"
  ],
  "verification_commands": [
    "python manage.py test myapp.tests"
  ],
  "resource_bounds": {
    "max_steps": 5,
    "timeout_seconds": 300
  },
  "environment_requirements": {
    "database": "postgres",
    "forward_credentials": [],
    "environment_overrides": {
      "DATABASE_URL": "postgres://postgres:postgres@postgres:5432/postgres"
    }
  }
}
```

### 2. Ruby on Rails
```json
{
  "task_id": "rails-api-token",
  "summary": "Create an API Token model and migrate the database",
  "files_to_read": [],
  "instructions": [
    {
      "file_path": "db/migrate/20260603000000_create_api_tokens.rb",
      "action": "CREATE",
      "description": "Create a migration for api_tokens table containing token:string, active:boolean, and user_id:integer."
    },
    {
      "file_path": "app/models/api_token.rb",
      "action": "CREATE",
      "description": "Define the ApiToken model belonging to a user."
    }
  ],
  "migration_file_globs": ["db/migrate/*.rb"],
  "db_setup_commands": [
    "bundle exec rails db:migrate"
  ],
  "verification_commands": [
    "bundle exec rspec spec/models/api_token_spec.rb"
  ],
  "resource_bounds": {
    "max_steps": 5,
    "timeout_seconds": 400
  },
  "environment_requirements": {
    "database": "postgres",
    "forward_credentials": ["ssh-agent"],
    "environment_overrides": {
      "DATABASE_URL": "postgresql://postgres:postgres@postgres:5432/postgres"
    }
  }
}
```

### 3. Node.js (Prisma / Express)
```json
{
  "task_id": "node-redis-cache",
  "summary": "Integrate Redis caching into user endpoints",
  "files_to_read": ["src/routes/users.js"],
  "instructions": [
    {
      "file_path": "src/routes/users.js",
      "action": "MODIFY",
      "description": "Wrap user fetching in a Redis cache get/set wrapper."
    }
  ],
  "migration_file_globs": ["prisma/migrations/**/*.sql"],
  "db_setup_commands": [
    "npx prisma migrate dev --name init"
  ],
  "verification_commands": [
    "npm run test"
  ],
  "resource_bounds": {
    "max_steps": 5,
    "timeout_seconds": 300
  },
  "environment_requirements": {
    "database": "redis",
    "forward_credentials": [],
    "environment_overrides": {
      "REDIS_URL": "redis://redis:6379"
    }
  }
}
```

---

## Sandbox Behaviors & Safeguards

### 1. Database Self-Healing
During execution, if migration files are modified, the runner runs standard catch-up commands. If catch-up fails due to migration conflicts or database checksum mismatch, the runner initiates **Self-Healing**:
- Destroys the ephemeral database container.
- Spawns a clean fresh database container.
- Re-runs all database setup and seeding commands from scratch.

### 2. Physical Git Lock Protection
The system profiles the host repository for any active Git lock files (e.g. `index.lock`, `config.lock`, `HEAD.lock`). If locks exist, execution is aborted immediately to avoid repository corruption.

### 3. Staging and Branch Verification
Once all tests and verification commands pass successfully inside the container:
1. Edits are committed inside the isolated Git worktree.
2. A new local branch `sdd/{task_id}` is created on the host pointing to this validated commit.
3. The temporary Git worktree and snapshot reference are safely destroyed.
4. Developers can review changes by running:
   ```bash
   git merge sdd/{task_id}
   ```

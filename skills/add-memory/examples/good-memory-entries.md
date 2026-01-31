# Good Memory Entry Examples

Real examples of well-formatted memory entries across different categories.

## Code Conventions

### Database Queries
```
**Prefer Python for complex transformations:**
Use SQL for basic data retrieval, but handle filtering, JSON parsing,
and multi-step transformations in Python/Pandas for maintainability and testability.
```

### JSON Parsing
```
**Parse JSON in Python, not SQL:**
The metadata column contains concatenated JSON with delimiters.
Use Python's json.loads() for parsing in data processing logic.
```

### Date Handling
```
**Always validate dates before queries:**
The created_at column can be NULL for imported legacy data.
Filter with pandas isnull() before aggregations.
```

## Performance Notes

### Data Loading
```
**Use connection pooling for SQL Server connections:**
SQLAlchemy + pyodbc pooling is configured in database/connection.py.
Reuse connections instead of creating new ones per query.
```

### Caching
```
**Cache small reference tables:**
Status and location lookup tables are small enough to load once
and reuse. See database/queries.py for caching patterns.
```

## Architecture Guidelines

### File Structure
```
**Keep UI pages under 200 lines:**
Split complex pages into separate modules in ui/components/.
Each module should have a single responsibility.
```

### Database Schema
```
**Multiple records per entity are normal:**
Join on parent_id to group related records.
Always filter to latest created_at per parent_id when you need one record per entity.
```

## Testing Guidelines

### Error Handling
```
**Test error paths in JSON parsing:**
Metadata JSON can be malformed. Always test with invalid JSON
in unit tests before deploying.
```

## Environment Setup (for CLAUDE.local.md)

```
**Use ./.venv/Scripts/python.exe for development:**
The virtual environment provides all dependencies needed for panel serve.
This avoids system Python conflicts.
```

## Documentation

```
**Link to database schema for complex queries:**
When adding a new SQL query, reference [Database Schema](.claude/database-schema.md)
to help maintainers understand table relationships.
```

---

## Pattern: Technical Constraints

When documenting project constraints that affect coding decisions:

**Format:**
```
**What you should do:** The action or pattern.
Why: The reason or constraint forcing this approach.
```

**Example:**
```
**Always use parent_id for grouping records:**
Multiple records can exist per entity (retries, updates).
The parent_id groups all records from a single operation.
```

## Pattern: Best Practices with Rationale

When capturing a best practice:

**Format:**
```
**Best practice statement:**
Why it matters (context, problems it solves).
When to apply it (conditions, exceptions).
```

**Example:**
```
**Cache reference table lookups:**
Small reference tables are queried repeatedly.
Caching reduces database round-trips and improves application responsiveness.
Cache in database/connection.py when the app starts.
```

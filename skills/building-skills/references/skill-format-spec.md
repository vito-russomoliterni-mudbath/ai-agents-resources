# SKILL.md Format Specification

This reference provides the complete technical specification for the SKILL.md file format used in Claude Code.

## File Structure

Every SKILL.md file consists of two required components:

```
---
YAML Frontmatter
---

Markdown Body
```

## YAML Frontmatter

The frontmatter must:
- Begin on the first line with `---`
- Contain valid YAML
- End with `---`
- Include required fields

### Required Fields

**name** (string, max 64 characters)
- Unique identifier for the skill
- Lowercase letters, numbers, and hyphens only
- No spaces or special characters
- Should be descriptive but concise
- Examples: `code-review`, `api-endpoint-creator`, `git-pr-automation`

**description** (string, max 1024 characters)
- Primary triggering mechanism for the skill.
- Must follow the **Third-Person** format: "This skill should be used when the user asks to..."
- Must include **Exact Trigger Phrases** in quotes.
- Written in third person (Claude's perspective).
- Should be comprehensive—this is how Claude decides to use the skill.
- Include specific file types, keywords, or scenarios.

**version** (string)
- Semantic versioning for the skill.
- Example: `version: 1.0.0`

Example:
```yaml
description: This skill should be used when the user asks to "create a document", "edit text", or "analyze formatting". It provides comprehensive document creation and analysis with support for tracked changes and comments.
version: 1.0.0
```

### Optional Fields

**license** (string)
- Specifies the license under which the skill is distributed
- Example: `license: MIT` or `license: Complete terms in LICENSE.txt`

**metadata** (dictionary)
- Additional metadata for categorization or features
- Not standardized—use as needed
- Example:
  ```yaml
  metadata:
    category: coding-standards
    version: 1.0.0
  ```

**allowed-tools** (array or string)
- Specifies tool restrictions for the skill
- Limits what tools Claude can use when the skill is active
- Examples: `allowed-tools: ["Bash", "Read", "Edit"]`

**Do NOT include:**
- Custom fields that don't serve a clear purpose
- Fields that duplicate information in the body
- Extensive metadata that should be in the body

## Markdown Body

The body contains instructions for Claude to follow when the skill is active.

### Structure Guidelines

**Keep it concise:**
- Target: <500 lines, <5,000 words
- Split longer content into references files
- Challenge every paragraph: "Does Claude need this?"

**Use imperative form:**
- ✅ "Extract text from PDF"
- ❌ "Extracts text from PDF"
- ✅ "Create a new branch"
- ❌ "Creates a new branch"

**Organize with headers:**
```markdown
# Main Title

## Overview
Brief purpose explanation

## Workflow
Step-by-step instructions

## Best Practices
Key recommendations

## References
Links to bundled resources
```

### Progressive Disclosure

Structure content to support on-demand loading:

**Level 1: Overview** (in SKILL.md)
- Quick start information
- Core workflow
- Essential concepts

**Level 2: Details** (link to references/)
- Detailed documentation
- Comprehensive examples
- API specifications

**Level 3: Resources** (link to scripts/ and assets/)
- Executable code
- Templates
- Configuration files

### Linking to Bundled Resources

Reference files using relative paths:

```markdown
For detailed API documentation, see [API Reference](references/api-docs.md).

To generate boilerplate, use the template in [assets/template.html](assets/template.html).

Run the helper script: [scripts/process.py](scripts/process.py)
```

## Validation Rules

### Name Validation

The name field must:
1. Be 1-64 characters long
2. Contain only: lowercase letters (a-z), numbers (0-9), hyphens (-)
3. Not start or end with a hyphen
4. Not contain XML tags or reserved words

Invalid names:
- `My Skill` (spaces)
- `skill_name` (underscores)
- `Skill-Name` (uppercase)
- `-skill` (starts with hyphen)

Valid names:
- `my-skill`
- `code-review-v2`
- `api-doc-generator`

### Description Validation

The description must:
1. Be 1-1024 characters long
2. Be non-empty and meaningful
3. Not contain XML tags
4. Include both purpose and triggers

Poor description:
```yaml
description: A skill for code review
```

Good description:
```yaml
description: This skill should be used when the user asks to "review my code", "check for security issues", or "analyze code quality". It reviews code for bugs, security vulnerabilities, and style violations.
```

### Frontmatter Best Practices

**Be specific in descriptions:**
Include concrete triggers that help Claude decide when to use the skill:
- File extensions: ".docx files", ".pdf documents"
- Keywords: "when reviewing", "when creating", "when debugging"
- Use cases: "for presentations", "for API endpoints", "for test generation"

**Use consistent naming:**
- Prefer gerund form (verb-ing): `code-reviewing`, `api-generating`
- Be descriptive but concise
- Follow domain conventions

**Third-person perspective:**
```yaml
# Good
description: Processes Excel files and generates reports

# Bad
description: I will process Excel files and generate reports
```

## Common Mistakes

### Mistake 1: Empty or Generic Descriptions
```yaml
# Bad
description: A helpful skill

# Good
description: Creates RESTful API endpoints following best practices. Use when building REST APIs, designing endpoints, or implementing CRUD operations in Express, Flask, or FastAPI.
```

### Mistake 2: Missing Triggers in Description
```yaml
# Bad
description: Generates commit messages

# Good  
description: Generates conventional commit messages following the Conventional Commits format. Use when creating commits, writing PR descriptions, or formatting changelog entries.
```

### Mistake 3: Frontmatter Not on First Line
```yaml
# Bad (blank line before frontmatter)

---
name: my-skill
---

# Good (frontmatter starts on line 1)
---
name: my-skill
---
```

### Mistake 4: Invalid YAML Syntax
```yaml
# Bad (missing colon)
name my-skill

# Good
name: my-skill

# Bad (unquoted multiline)
description: This is a long
description that spans lines

# Good (use folded style)
description: >
  This is a long description
  that spans multiple lines
```

### Mistake 5: Extra Fields in Frontmatter
```yaml
# Avoid (unless truly needed)
---
name: my-skill
description: Does something
author: John Doe
created: 2025-01-01
updated: 2025-01-30
tags: [coding, review]
---

# Prefer (minimal)
---
name: my-skill
description: Reviews code for bugs and style violations. Use when reviewing pull requests or checking code quality.
---
```

## Directory Structure

Complete skill structure with all optional components:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown body (required)
├── LICENSE.txt (optional)
├── scripts/ (optional)
│   ├── script1.py
│   └── script2.sh
├── references/ (optional)
│   ├── api-docs.md
│   └── examples.md
└── assets/ (optional)
    ├── template.html
    └── logo.png
```

## Examples

### Example 1: Simple Skill

```markdown
---
name: commit-message-generator
description: Generates conventional commit messages following the Conventional Commits format. Use when creating commits, writing PR descriptions, or formatting changelog entries.
---

# Commit Message Generator

## Overview
Generates properly formatted conventional commit messages.

## Format
```
type(scope): subject

body

footer
```

## Types
- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Formatting
- refactor: Code restructuring
- test: Adding tests
- chore: Maintenance

## Usage
1. Analyze the changes
2. Determine the type
3. Write a clear subject (<50 chars)
4. Add body if needed
5. Include breaking changes in footer
```

### Example 2: Skill with Resources

```markdown
---
name: api-endpoint-creator
description: Creates RESTful API endpoints following best practices. Use when building REST APIs, designing endpoints, or implementing CRUD operations in Express, Flask, or FastAPI.
---

# API Endpoint Creator

## Overview
Generates RESTful API endpoints following industry standards.

## Workflow
1. Determine HTTP method and URL pattern
2. Implement with proper validation
3. Add error handling
4. Include documentation

## Best Practices
For detailed REST conventions, see [REST Guidelines](references/rest-conventions.md).

For framework-specific examples:
- Express.js: [examples/express.md](references/examples/express.md)
- Flask: [examples/flask.md](references/examples/flask.md)
- FastAPI: [examples/fastapi.md](references/examples/fastapi.md)

## Templates
Use boilerplate from [assets/api-template/](assets/api-template/).
```

## References

- Agent Skills specification: https://agentskills.io
- Claude Code documentation: https://code.claude.com/docs
- Codex CLI documentation: https://developers.openai.com/codex/skills
- Anthropic skills repository: https://github.com/anthropics/skills
- OpenAI skills repository: https://github.com/openai/skills

---
name: building-skills
description: Builds a properly formatted skills following the Agent Skills open standard specification. Use when asked to "create a skill", "convert a workflow to a skill", "transform a prompt into a skill", or "update a skill to best practices".
---

# Building Skills

## Overview

Converts AI assistant workflows, prompts, and usage patterns from various tools into properly formatted skills following the [Agent Skills open standard](https://agentskills.io/). The Agent Skills format is an open specification that enables any AI agent to use packaged instructions, scripts, and resources for domain expertise and repeatable workflows.

## Workflow

### 1. Gather Input
Ask the user to provide the workflow via:
- Direct text/paste of instructions
- URL to documentation
- Path to local folder with files
- Screenshots or examples of the workflow in action

### 2. Analyze Patterns
Identify the workflow characteristics:
- **Task purpose**: What problem does this solve?
- **Key steps**: What are the main actions?
- **Source tool**: Which AI assistant is this from? (Claude Code, Cursor, Windsurf, Aider, etc.)
- **Tool usage**: Does it use specific tools, commands, or APIs?
- **Dependencies**: Are there environmental requirements?

Research tool-specific best practices if needed.

### 3. Design Structure
Plan the skill layout following Agent Skills specification:

**Required frontmatter:**
- `name`: Short lowercase identifier (kebab-case)
- `description`: Clear explanation with keywords (1-1024 chars)

**Optional frontmatter:**
- `license`: License identifier (e.g., `MIT`, `Apache-2.0`)
- `compatibility`: Environmental requirements (if needed, 1-500 chars)
- `metadata`: Custom fields (author, version, etc.)

**File organization:**
- `SKILL.md`: Main instructions (< 500 lines recommended)
- `references/`: Detailed documentation (loaded on demand)
- `scripts/`: Executable code
- `assets/`: Templates, examples, configs

Determine which content belongs in main `SKILL.md` vs. separate files for progressive disclosure.

### 4. Validate Skill Name
Ensure the name follows Agent Skills specification requirements:

**Required rules:**
- ✅ Lowercase only
- ✅ Kebab-case (words separated by hyphens)
- ✅ Numbers allowed
- ✅ Cannot start with hyphen
- ✅ No consecutive hyphens (`--`)
- ✅ Descriptive and unique
- ✅ Max 64 characters
- ✅ Must not contain XML tags
- ✅ Must not be reserved words: `anthropic`, `claude`

**Recommended best practice (gerund form):**
While not required by the specification, gerund/present participle forms are commonly used in the ecosystem and clearly communicate ongoing actions:

- ✅ **Recommended**: `processing-data`, `analyzing-code`, `fixing-bugs`, `building-features`
- ⚠️ **Valid but less common**: `data-processor`, `code-analyzer`, `bug-fixer`

If the proposed name violates required rules OR doesn't follow the gerund best practice:
- Use **AskUserQuestion** to present alternatives
- Explain the specification requirements
- Suggest 3-4 name options following both rules and best practices
- Let user choose or propose their own

**Example interaction:**
```
User proposes: "Bug-Fixer" or "bug--helper"

Response:
"The name 'Bug-Fixer' violates Agent Skills specification (uppercase not allowed)
and 'bug--helper' has consecutive hyphens.

Valid names following the specification:
1. fixing-bugs (recommended: gerund form, emphasizes action)
2. debugging-issues (recommended: gerund form, emphasizes investigation)
3. bug-resolver (valid: meets spec, less common pattern)
4. issue-fixer (valid: meets spec, less common pattern)

Which would you like? (Pick 1-4 or suggest your own lowercase kebab-case name)"
```

### 5. Write Description
Craft the description following Agent Skills best practices:

**Format:**
- Third person, present tense
- Clear explanation of what the skill does
- When to use it (scenarios/use cases)
- Include relevant keywords for matching
- 1-1024 characters

**Good examples:**
```yaml
description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when the user mentions PDFs, forms, or document extraction.
```

```yaml
description: Analyzes datasets, generates charts, and creates summary reports. Use for data exploration, statistical analysis, or when the user asks to visualize or summarize data.
```

**Poor examples:**
```yaml
description: Helps with PDFs.  # Too vague, no keywords
```

```yaml
description: This is a skill that you should use when...  # Wordy, not direct
```

### 6. Create SKILL.md
Generate the complete `SKILL.md` file:

**Structure:**
```markdown
---
name: skill-name
description: Clear description with keywords and use cases.
license: MIT  # optional
metadata:  # optional
  author: your-org
  version: "1.0"
---

# Skill Title

## Overview
Brief explanation of what this skill does.

## Prerequisites
- List any required tools, packages, or environment setup
- Mention compatibility requirements if any

## Workflow
Numbered step-by-step instructions.

## Examples
Concrete usage examples.

## References
- Link to detailed documentation in references/
- Link to scripts or templates
```

**Writing style:**
- Use imperative voice for instructions ("Create", "Extract", "Analyze")
- Be specific and actionable
- Keep main content under 500 lines
- Move detailed reference material to separate files

### 7. Populate Resources
Create supporting files as needed:

**scripts/** - Executable code:
- Python, Bash, JavaScript, etc.
- Referenced from SKILL.md when needed
- Include shebang and clear documentation

**references/** - Detailed documentation:
- Extended guides (e.g., `references/advanced-usage.md`)
- API references
- Troubleshooting guides
- Loaded only when agent needs more detail

**assets/** - Templates and examples:
- Configuration templates
- Code snippets
- Example files
- Checklists

Use relative paths from skill root:
```markdown
See [advanced guide](references/advanced.md) for details.
Run the script: `scripts/process.py`
```

Keep references one level deep - avoid deeply nested chains.

### 8. Validate Compliance
Verify the skill meets Agent Skills specification:

**Use the official validator:**
```bash
# Install skills-ref validator
npm install -g @agentskills/skills-ref
# or
pip install agentskills

# Validate your skill
skills-ref validate ./your-skill-folder
```

**Manual checks:**
- ✅ `SKILL.md` exists with valid frontmatter
- ✅ `name` field is lowercase kebab-case
- ✅ `description` is 1-1024 characters
- ✅ No deeply nested reference chains
- ✅ All referenced files exist
- ✅ File paths use forward slashes
- ✅ Main SKILL.md is under 500 lines

### 9. Test the Skill
Before finalizing:
- Load the skill in an agent that supports Agent Skills
- Test the workflow end-to-end
- Verify referenced files are loaded correctly
- Check that the description triggers the skill appropriately
- Validate any scripts execute as expected

### 10. Document and Share
Add usage information:
- How to install the skill
- Example invocations
- Links to the Agent Skills specification
- License and attribution

## Agent Skills Specification Reference

### Required Frontmatter Fields

**`name`** (required)
- Type: String
- Format: Lowercase kebab-case
- Rules:
  - Cannot start with hyphen
  - No consecutive hyphens
  - No uppercase letters
- Examples: `pdf-processing`, `data-analysis`, `code-review`

**`description`** (required)
- Type: String
- Length: 1-1024 characters
- Purpose: Clear explanation with keywords
- Style: Third person, present tense
- Should include: What it does + When to use it

### Optional Frontmatter Fields

**`license`** (optional)
- Type: String
- Purpose: Specify licensing terms
- Examples: `MIT`, `Apache-2.0`, `See LICENSE.txt`

**`compatibility`** (optional)
- Type: String
- Length: 1-500 characters
- Purpose: Environmental requirements
- When to use: Only if skill has specific requirements
- Example: `Requires Docker and network access for container operations`

**`metadata`** (optional)
- Type: Object (key-value pairs)
- Purpose: Custom properties not in spec
- Common uses: author, version, tags, etc.
- Example:
  ```yaml
  metadata:
    author: example-org
    version: "1.0"
    category: data-processing
  ```

### Progressive Disclosure

Skills use a three-tier loading model:

1. **Metadata** (~100 tokens): `name` and `description` loaded at agent startup
2. **Instructions** (< 5000 tokens): Full `SKILL.md` loaded when skill activated
3. **Resources** (as needed): Files in `scripts/`, `references/`, `assets/` loaded on demand

**Best practices:**
- Keep SKILL.md under 500 lines
- Move detailed material to `references/`
- Link to resources with relative paths
- Avoid deep nesting of references

## Common Naming Patterns

### Gerund/Present Participle (Recommended)
Describes ongoing actions, commonly used in the ecosystem:

| Pattern | Example | Use Case |
|---------|---------|----------|
| `[action]-ing-[object]` | `processing-data` | Data transformation workflows |
| `[action]-ing-[object]` | `analyzing-code` | Code review and analysis |
| `[action]-ing-[object]` | `fixing-bugs` | Debugging and repair |
| `[action]-ing-[object]` | `building-features` | Feature development |
| `[action]-ing-[object]` | `testing-code` | Test execution and validation |

### Noun-Object (Valid Alternative)
Meets specification but less common:

| Pattern | Example | Use Case |
|---------|---------|----------|
| `[object]-[action]` | `pdf-processing` | Valid, widely used |
| `[object]-[tool]` | `data-analyzer` | Valid but less descriptive of action |
| `[object]-[purpose]` | `code-review` | Valid, commonly seen |

### Invalid Patterns
Violate Agent Skills specification:

| Pattern | Example | Issue |
|---------|---------|-------|
| Uppercase | `PDF-Processing` | Must be lowercase |
| Starts with hyphen | `-pdf-processing` | Cannot start with hyphen |
| Consecutive hyphens | `pdf--processing` | No consecutive hyphens |
| Spaces | `pdf processing` | Must use hyphens |

## Name Suggestion Process

When generating name suggestions, prioritize:

1. **Specification compliance** (required)
2. **Gerund form** (recommended best practice)
3. **Clarity** (immediately understandable)
4. **Brevity** (2-3 words ideal)
5. **Uniqueness** (distinct from existing skills)

**Example suggestion generation:**

User describes: "A skill for running unit tests automatically"

**Analysis:**
- Action: running/executing tests
- Object: tests/code
- Purpose: automation/validation

**Suggestions:**
1. `running-tests` (gerund, emphasizes execution)
2. `testing-code` (gerund, emphasizes validation)
3. `executing-tests` (gerund, formal tone)
4. `test-runner` (noun-object, valid but less recommended)

Present with rationale, let user choose.

## Best Practices (Short)
- Keep instructions concise; assume the model is competent and remove unnecessary explanation.
- Decide degrees of freedom (high/medium/low) and make it explicit in the workflow.
- Test with every model you plan to use and revise for inconsistencies.
- Prefer checklists and validation loops for reliability.
- For long references, include a brief table of contents at the top.

**Degrees of freedom example:**
- High freedom: "Use best judgment to select tools and sequence steps."
- Medium freedom: "Follow the workflow order; adjust only when blocked."
- Low freedom: "Perform steps exactly as written; do not deviate."

## References

- Official specification: https://agentskills.io/specification
- Integration guide: https://agentskills.io/integrate-skills
- Validation tools: https://github.com/agentskills/agentskills
- Example skills: https://github.com/agentskills/skills

# Best Practices for Creating Skills

This reference compiles research-backed best practices for creating effective, high-quality skills for Claude Code and Codex.

## Core Design Principles

### 1. Progressive Disclosure (Essential)

Skills use a three-tier loading system:

**Tier 1: Metadata** (~100 words, always loaded)
- Name + description in frontmatter
- Triggers skill discovery
- Must be comprehensive enough for Claude to decide relevance

**Tier 2: Instructions** (<5k words, loaded when triggered)
- SKILL.md body
- Core workflow and guidance
- Links to deeper resources

**Tier 3: Resources** (variable size, loaded on-demand)
- Scripts, references, assets
- Loaded only when explicitly referenced
- No context penalty until accessed

**Why it matters:** The context window is shared across system prompts, conversation history, skills metadata, and user requests. Efficient use of context enables more skills to coexist and leaves more room for actual work.

### 2. Conciseness is Critical

**Default assumption:** Claude is already very capable and knowledgeable.

Before adding content, ask:
- Does Claude really need this explanation?
- Could an example replace this paragraph?
- Is this justifying its token cost?

**Research finding:** Keeping SKILL.md under 5,000 words prevents overwhelming Claude's context window. Target <500 lines for the body.

**Prefer examples over explanations:**

```markdown
# Instead of:
To create a conventional commit message, start with a type like "feat" or "fix", 
followed by an optional scope in parentheses, then a colon and space, and finally 
a subject line that describes the change in imperative mood.

# Use:
## Format
feat(auth): add password reset functionality
fix(api): handle null response from database
docs(readme): update installation instructions
```

### 3. Set Appropriate Degrees of Freedom

Match specificity to task characteristics:

**High Freedom (Text Instructions)**
- Multiple valid approaches
- Decisions depend on context  
- Heuristics guide the work
- Example: Code review feedback

**Medium Freedom (Pseudocode/Parameters)**
- Preferred pattern exists
- Some variation acceptable
- Configuration affects behavior
- Example: API endpoint creation

**Low Freedom (Specific Scripts)**
- Operations are fragile/error-prone
- Consistency is critical
- Specific sequence required
- Example: PDF manipulation, Git operations

**Analogy:** Think of Claude exploring a path—a narrow bridge with cliffs needs specific guardrails, while an open field allows many routes.

## Description Best Practices

The description field is **the primary skill trigger mechanism**. It must be comprehensive.

### Include Both Purpose AND Triggers

**Poor description:**
```yaml
description: Reviews code for quality issues
```

**Good description:**
```yaml
description: Reviews code for bugs, security issues, and style violations. Use when reviewing pull requests, checking code quality before commits, or performing security audits on Python, JavaScript, or TypeScript files.
```

### Be Specific About Use Cases

Include concrete scenarios that should trigger the skill:

- File types: ".docx files", ".pdf documents", "Excel spreadsheets"
- Actions: "when creating", "when reviewing", "when debugging"
- Contexts: "for presentations", "for API endpoints", "for test generation"
- Keywords: "pull requests", "commit messages", "documentation"

## Claude-Specific Best Practices

### 1. Trigger Optimization

Claude Code relies heavily on semantic matching for skill activation. Use exact phrases that a user would typically type, and always use the third-person format:

- ✅ "This skill should be used when the user asks to 'review code'..."
- ❌ "Use this skill for code reviews."

### 2. Decision Trees for Routing

For skills that handle multiple sub-tasks, include a decision tree in the `Overview` or `Workflow` section to help Claude navigate:

```markdown
## Decision Tree

**What do you need?**
├─ New project? -> [assets/boilerplate/](assets/boilerplate/)
├─ Debugging? -> [references/debugging.md](references/debugging.md)
└─ Deployment? -> See Workflow step 4
```

### 3. Progressive Disclosure

Maintain the hierarchy to save tokens:
- **Level 1 (Essential)**: Frontmatter (Name, Description, Version) and basic Workflow in `SKILL.md`.
- **Level 2 (Deep Dive)**: Detailed rules and schemas in `references/`.
- **Level 3 (Execution)**: Reusable logic in `scripts/`.

### 4. Hook Integration

If your skill needs to intercept tool calls (e.g., validate a `write_file` call), consider implementing a **PreToolUse** hook in a supporting script within your plugin.

### Don't Duplicate in Body

The body is only loaded AFTER triggering. "When to Use This Skill" sections in the body don't help Claude decide whether to use the skill.

**Put ALL trigger information in the description.**

## Naming Conventions

### Use Gerund Form

Prefer verb-ing form for skill names:

```yaml
# Good
name: code-reviewing
name: api-generating  
name: test-creating

# Acceptable
name: code-review
name: api-generator
name: test-creator
```

**Research guidance:** Gerund form clearly describes the activity or capability the skill provides.

### Follow Format Rules

- Lowercase letters, numbers, hyphens only
- No spaces, underscores, or special characters
- 1-64 characters max
- Descriptive but concise

```yaml
# Valid
name: git-pr-automation
name: doc-generator-v2
name: api-endpoint-creator

# Invalid
name: Git PR Automation  # spaces, uppercase
name: doc_generator      # underscores
name: API-Creator        # uppercase
```

## Body Structure

### Use Imperative Form

Write instructions as commands, not descriptions:

```markdown
# Good
## Workflow
1. Extract text from the PDF
2. Analyze the content
3. Generate a summary

# Bad
## Workflow  
1. Text is extracted from the PDF
2. The content is analyzed
3. A summary is generated
```

### Organize with Clear Headers

```markdown
# Skill Name

## Overview
[2-3 sentences on purpose]

## Workflow  
[Step-by-step process]

## Best Practices
[Key recommendations]

## References
[Links to bundled resources]
```

### Link to Resources Effectively

Make it clear when Claude should read additional files:

```markdown
## PDF Operations

For basic text extraction, use pdfplumber:
[quick example]

For advanced features:
- **Form filling**: See [references/forms.md](references/forms.md)
- **OCR processing**: See [references/ocr.md](references/ocr.md)
- **Complete API reference**: See [references/api-reference.md](references/api-reference.md)
```

## Bundled Resources

### Scripts Directory

Create scripts for:
- Code that gets rewritten repeatedly
- Operations requiring deterministic reliability
- Complex logic that should be tested and versioned

**Must test scripts by actually running them.**

```python
# scripts/rotate_pdf.py
"""Rotate PDF pages by specified degrees."""
import PyPDF2
import sys

def rotate_pdf(input_path, output_path, rotation):
    # Implementation
    pass

if __name__ == "__main__":
    rotate_pdf(sys.argv[1], sys.argv[2], int(sys.argv[3]))
```

Reference in SKILL.md:

```markdown
## Rotating PDFs

Use the rotation script:
```bash
python scripts/rotate_pdf.py input.pdf output.pdf 90
```
```

### References Directory

Create reference files for:
- API documentation
- Database schemas  
- Company policies
- Workflow guides
- Best practices

**Keep references focused:**
- One topic per file
- <10k words per file
- Include table of contents if >100 lines
- Link explicitly from SKILL.md

**Avoid duplication:** Information should live in either SKILL.md OR references, not both.

```markdown
# references/api-docs.md

# API Reference

## Table of Contents
- Authentication
- Endpoints
- Error Handling
- Rate Limiting

## Authentication
[Details...]
```

### Assets Directory

Include files used in output:
- Templates (HTML, config files)
- Boilerplate code
- Images, fonts, icons
- Sample documents

**Not loaded into context** - these are copied/modified for output.

```markdown
## Creating New Projects

Copy the boilerplate from [assets/react-template/](assets/react-template/):

```bash
cp -r assets/react-template/ my-new-project/
```
```

## Quality Guidelines

### Avoid Over-Explanation

Claude already knows common programming concepts, Git basics, HTTP methods, etc.

```markdown
# Don't explain basics Claude knows
## HTTP Methods
GET retrieves data, POST creates resources, PUT updates...

# Instead, focus on YOUR specific patterns
## API Conventions
Use POST for /api/v1/resources
Include X-Request-ID header
Return 201 with Location header
```

### Use Examples Liberally

Examples are often clearer and more concise than explanations:

```markdown
# Instead of explaining the commit format...
## Commit Message Format

# Show examples:
feat(auth): add password reset functionality
fix(api): handle null response from database  
docs(readme): update installation instructions
chore(deps): upgrade axios to v1.6.0
```

### Challenge Every Section

Before including content, ask:
- Is this obvious to Claude?
- Could I show instead of tell?
- Does the user need this documented?
- Will this confuse or clarify?

## Testing Skills

### Test with Fresh Instance

Don't test with the same Claude instance that created the skill. Use a fresh conversation:

1. Load the skill
2. Try triggering it naturally
3. Observe if it activates
4. Check if instructions are clear
5. Note any struggles

### Test Multiple Phrasings

Try different ways users might invoke the skill:

```
"Review this code"
"Check my PR"  
"Look for bugs"
"Security audit"
"Code quality check"
```

If triggers are inconsistent, revise the description.

### Test on Real Examples

Use actual code/documents from real projects, not toy examples.

## Common Mistakes

### Mistake 1: Description Too Generic

```yaml
# Bad
description: A helpful coding assistant

# Good
description: Reviews code for bugs, security issues, and style violations. Use when reviewing pull requests, checking code quality, or performing security audits on Python, JavaScript, or TypeScript files.
```

### Mistake 2: Putting Triggers in Body

```markdown
# Bad - triggers in body (not seen until after skill loads)
## When to Use This Skill
Use this skill when reviewing pull requests...

# Good - triggers in description
description: ... Use when reviewing pull requests...
```

### Mistake 3: Over-Formatting SKILL.md

```markdown
# Bad - excessive structure
## Overview
### Purpose
#### Primary Use Case
##### Specific Scenarios

# Good - flat, scannable
## Overview
## Workflow
## Best Practices
```

### Mistake 4: Not Testing Scripts

Create and reference a script that hasn't been tested. Always run scripts to verify they work.

### Mistake 5: Duplicating Information

Having the same info in both SKILL.md and references. Choose one location:
- Essential workflow: SKILL.md
- Detailed reference: references/

### Mistake 6: Creating Extra Documentation

Don't create README.md, CHANGELOG.md, INSTALLATION.md, etc. The skill should only contain what Claude needs to do the job.

## Research-Backed Recommendations

### From Anthropic Engineering

A four-step workflow performs well for complex changes:
1. Ask Claude to research the codebase
2. Have Claude create a plan
3. Ask Claude to implement the solution
4. Have Claude commit and create a PR

Encode multi-step workflows like this in skills.

### From Community Usage

Skills work best when:
- They capture institutional knowledge and turn it into reusable workflows
- They help Claude behave consistently across users and sessions
- They enforce standard conventions automatically

### From Skills Specification

Follow the Agent Skills specification at agentskills.io so skills work across platforms adopting the standard.

## Iteration and Improvement

### Expect Multiple Iterations

Skills rarely work perfectly on first try. Plan for:
1. Initial creation
2. Testing on real tasks
3. Noting struggles
4. Updating SKILL.md or resources
5. Testing again

### Gather Feedback

After others use the skill:
- What triggered incorrectly?
- What instructions were unclear?
- What resources were missing?
- What could be removed?

### Keep Skills Updated

As projects evolve:
- Update references for API changes
- Add new patterns discovered through use
- Remove outdated practices
- Simplify based on learning

## Distribution Best Practices

### For Teams (Version Control)

Add to project's `.codex/skills/` or `.claude/skills/`:

```bash
git add .codex/skills/my-skill/
git commit -m "feat(skills): add API documentation generator"
```

Team members automatically get the skill.

### For Personal Use

Install in `~/.codex/skills/` or `~/.claude/skills/`:

```bash
cp -r my-skill/ ~/.codex/skills/
```

### For Community Sharing

1. Create a .skill file (zip with .skill extension)
2. Share on GitHub or skills marketplace
3. Include LICENSE.txt
4. Write clear installation instructions

```bash
# Package
zip -r my-skill.skill my-skill/

# Others install
unzip my-skill.skill -d ~/.codex/skills/
```

## Advanced Patterns

### Conditional Logic in Instructions

```markdown
## Workflow

1. Determine the framework:
   - If TypeScript: use [references/typescript-patterns.md](references/typescript-patterns.md)
   - If Python: use [references/python-patterns.md](references/python-patterns.md)
   - If Go: use [references/go-patterns.md](references/go-patterns.md)

2. Generate code following framework patterns

3. Add tests using framework test runner
```

### Multi-Stage Workflows

```markdown
## Workflow

### Stage 1: Research
1. Scan codebase for existing patterns
2. Identify dependencies
3. Note architectural constraints

### Stage 2: Plan
1. Design the solution
2. List files to modify
3. Identify risks

### Stage 3: Implementation  
1. Generate code
2. Run tests
3. Fix any issues

### Stage 4: Documentation
1. Update README
2. Add inline comments
3. Update CHANGELOG
```

### Framework Selection

```markdown
## Framework Detection

Check package.json or requirements.txt to determine framework.

For JavaScript frameworks:
- React: See [references/react-guide.md](references/react-guide.md)
- Vue: See [references/vue-guide.md](references/vue-guide.md)
- Angular: See [references/angular-guide.md](references/angular-guide.md)

For Python frameworks:
- Django: See [references/django-guide.md](references/django-guide.md)
- Flask: See [references/flask-guide.md](references/flask-guide.md)
- FastAPI: See [references/fastapi-guide.md](references/fastapi-guide.md)
```

## Further Reading

These sources informed these best practices:

- Anthropic's Skills documentation and skill-creator
- OpenAI Codex Skills specification
- Claude Code best practices from Anthropic engineering
- Agent Skills community contributions
- Skills Marketplace case studies

For official documentation:
- Anthropic Skills: https://platform.claude.com/docs/en/agents-and-tools/agent-skills
- OpenAI Codex: https://developers.openai.com/codex/skills
- Agent Skills spec: https://agentskills.io

---
name: building-skills
description: This skill should be used when the user asks to "convert a workflow to a skill", "create a Claude skill", "transform a prompt into an agent", or "update a skill to best practices". It converts AI coding assistant workflows (from Claude Code, Cursor, Windsurf, Aider, etc.) into reusable Claude skills following the Agent Skills specification.
version: 1.3.0
---

# Building Skills

## Overview

Converts AI assistant workflows, prompts, and usage patterns from various tools (Claude Code, Cursor, Windsurf, Aider, etc.) into properly formatted Claude skills.

## Workflow

1. **Gather Input**: Ask the user to provide the workflow via text, URL, or local folder.
2. **Analyze Patterns**: Identify the task, steps, and source tool. Research specific best practices for the detected tool.
3. **Design Structure**: Plan the `frontmatter` (name, description, version) and determine which logic belongs in `SKILL.md` vs. `references/` or `scripts/`.
4. **Validate Skill Name**: Ensure the skill name follows gerund form (verb + -ing):
   - **Check if name is in gerund form** (e.g., `fixing-bugs`, `adding-tests`, `building-features`)
   - **If NOT in gerund form**, prompt the user with:
     - Explanation that Claude skill best practices require gerund names
     - 3-4 alternative gerund name suggestions based on the skill's purpose
     - Ask the user to choose one or provide their own gerund name
   - **Examples of valid gerund names**:
     - `fixing-bugs` (not `bug-fix` or `fix-bug`)
     - `adding-tests` (not `add-tests` or `test-adder`)
     - `refactoring-code` (not `refactor` or `code-refactor`)
     - `building-features` (not `new-feature` or `feature-builder`)
5. **Create Skill**: Generate the `SKILL.md` using imperative language and the **Progressive Disclosure** pattern.
6. **Populate Resources**: Create necessary scripts in `scripts/`, documentation in `references/`, and templates in `assets/`.
7. **Validate**: Run the `validate_skill.py` script to ensure compliance with the Agent Skills specification.

## Best Practices

- **Gerund Naming Convention**: Skill names MUST use gerund form (verb + -ing):
  - ✅ GOOD: `fixing-bugs`, `adding-tests`, `building-features`, `refactoring-code`
  - ❌ BAD: `bug-fix`, `add-tests`, `new-feature`, `refactor`
  - **Why**: Gerund names describe ongoing actions and follow Claude skill best practices
  - **Validation**: Always check if the proposed name ends in `-ing` and represents an action
  - **If non-conforming**: Prompt user with 3-4 gerund alternatives based on the skill's purpose
- **Third-Person Description**: Always start descriptions with "This skill should be used when...".
- **Exact Trigger Phrases**: Wrap phrases the user might say in quotes within the description.
- **Progressive Disclosure**: Keep `SKILL.md` lean (< 2000 words). Move complex logic to `references/`.
- **Imperative Voice**: Use "Create", "Extract", "Analyze" instead of "Creates", "Extracting", etc.

## Skill Name Validation Process

When the user proposes a skill name, follow this validation process:

### Step 1: Check Gerund Form
Verify the name follows the pattern: `[verb]-ing-[object]` or `[verb]-ing`

**Valid patterns:**
- `fixing-bugs` (verb-ing + object)
- `adding-tests` (verb-ing + object)
- `refactoring-code` (verb-ing + object)
- `building-features` (verb-ing + object)

**Invalid patterns:**
- `bug-fix` (object-action, not gerund)
- `fix-bugs` (imperative verb, not gerund)
- `debugger` (noun, not gerund)
- `test-runner` (noun phrase, not gerund)

### Step 2: If Non-Conforming, Generate Alternatives
When the name doesn't follow gerund form, use **AskUserQuestion** to present alternatives:

**Example interaction:**
```
User proposes: "test-runner"

Response:
"The name 'test-runner' doesn't follow Claude skill best practices, which
require gerund form (verb + -ing) for skill names.

Here are gerund alternatives based on your skill's purpose:

1. running-tests (emphasizes test execution)
2. executing-tests (formal, emphasizes running)
3. testing-code (broader, emphasizes validation)
4. validating-tests (emphasizes verification aspect)

Which name would you like? (Pick 1-4 or suggest your own gerund name)"
```

### Step 3: Validate User Choice
- If user picks from suggestions: Proceed
- If user suggests new name: Verify it's in gerund form
- If still non-conforming: Explain again and offer more suggestions

### Step 4: Document Reasoning
In the skill's `SKILL.md`, briefly note why the gerund name was chosen if it helps clarify the skill's purpose.

## Common Name Conversion Patterns

| Non-Gerund (Bad) | Gerund (Good) | Alternative Options |
|------------------|---------------|---------------------|
| `bug-fix` | `fixing-bugs` | `debugging-issues`, `resolving-defects` |
| `test-runner` | `running-tests` | `executing-tests`, `testing-code` |
| `code-reviewer` | `reviewing-code` | `analyzing-code`, `inspecting-code` |
| `data-processor` | `processing-data` | `transforming-data`, `parsing-data` |
| `api-builder` | `building-apis` | `creating-apis`, `designing-apis` |
| `doc-generator` | `generating-docs` | `documenting-code`, `writing-docs` |

## References

- Detailed conversion logic: [references/conversion-details.md](references/conversion-details.md)
- Skill format specification: [references/skill-format-spec.md](references/skill-format-spec.md)
- Claude-specific guide: [references/claude-skills-guide.md](references/claude-skills-guide.md)
- Validation script: [scripts/validate_skill.py](scripts/validate_skill.py)

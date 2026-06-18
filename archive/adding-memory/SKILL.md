---
name: adding-memory
description: This skill should be used when the user asks to "remember this", "add this guideline", "document this pattern", "save this best practice", or "make a note of this". It captures project knowledge and best practices in appropriate documentation files.
version: 1.0.0
disable-model-invocation: true
user-invocable: true
argument-hint: "[guideline or best practice]"
---

# Adding Memory Skill

## Overview

Capture and organize project knowledge, best practices, and team guidelines in appropriate documentation files. This skill helps maintain collective memory across projects by storing insights in the right location for future reference.

## Prerequisites

This skill requires:
- Existing project structure with CLAUDE.md or documentation
- Git repository
- Understanding of what should be remembered

## Workflow

### Phase 1: Clarification

#### 1. Understand the knowledge item (interactive)

Ask the user to specify:
- **What to remember**: The specific guideline, pattern, or practice
- **Why it matters**: Context and importance
- **Who needs it**: Individual, team, project-wide
- **Type**: Code pattern, best practice, anti-pattern, process, etc.

Use AskUserQuestion for this interaction.

#### 2. Determine scope

Consult [scope-decision-tree.md](references/scope-decision-tree.md) to decide:
- **Personal CLAUDE.md**: Individual developer preferences (~/.claude/CLAUDE.md)
- **Project CLAUDE.md**: Team-wide standards (in repository root)
- **Local CLAUDE.md**: Module-specific tools (e.g., tools/data-processor/CLAUDE.md)
- **Structured documentation**: When it needs depth and organization

Examples:
- "Always use async/await" → Project CLAUDE.md Development Guidelines
- "This codebase uses factory pattern for widgets" → Local CLAUDE.md Architecture
- "I prefer named imports over defaults" → Personal CLAUDE.md Preferences

### Phase 2: Location & Format

#### 3. Choose target documentation

Decide where to store using [documentation-patterns.md](references/documentation-patterns.md):
- **CLAUDE.md sections**: Quick tips, guidelines, patterns (less than 500 words each)
- **Structured files**: Detailed guides needing depth and organization
- **Examples directory**: Code samples and concrete illustrations
- **README sections**: Setup, installation, getting started

#### 4. Review existing content

Read the target file with Read:
- Check if knowledge already exists
- Identify similar sections or patterns
- Understand current organization and style
- Look for merge opportunities

#### 5. Select format template

Use [memory-entry-template.md](assets/memory-entry-template.md) for consistent formatting:
- Title/section header
- Why it matters (context)
- The guidance or pattern
- Example if applicable
- Related/see also links

### Phase 3: Implementation

#### 6. Create or update documentation

For **adding to CLAUDE.md**:
1. Read the existing file structure
2. Identify appropriate section (or create if needed)
3. Add entry following [claude-md-template.md](assets/claude-md-template.md) structure
4. Maintain consistent formatting and style

For **creating structured documentation**:
1. Create new markdown file in appropriate directory
2. Use structured sections (Overview, Patterns, Examples, etc.)
3. Link from CLAUDE.md if not already in git

For **adding examples**:
1. Create file in examples/ or references/examples/
2. Use consistent naming: example-[topic].md or Example[Topic].ts
3. Include comments explaining key points

#### 7. Ensure discoverability

Make the knowledge findable:
- **Add to index**: Include in CLAUDE.md navigation or table of contents
- **Create links**: Reference from related sections
- **Use clear titles**: Descriptive headings that include keywords
- **Add tags/labels**: Especially for structured documentation

#### 8. Follow project conventions

Match existing style:
- Heading levels and formatting
- Code block syntax highlighting
- List styles (bullets vs numbered)
- Comment and explanation style
- Any domain-specific terminology

### Phase 4: Validation

#### 9. Verify accessibility

Ensure content is easy to find:
- Can it be found via search keywords?
- Does it appear in relevant sections?
- Are there appropriate cross-references?
- Would a team member know where to look?

#### 10. Test clarity

Review for:
- Clear explanation of the guideline
- Concrete examples included
- Why it matters articulated
- Any edge cases or exceptions noted

#### 11. Maintenance considerations

Use [memory-maintenance.md](references/memory-maintenance.md) guidance:
- Schedule periodic reviews (quarterly or semi-annually)
- Keep links up-to-date
- Mark deprecated guidelines
- Archive outdated patterns

#### 12. Create task for periodic review

If adding significant new guidance:
- Note when it should be reviewed
- Identify potential deprecation triggers
- Plan how to measure effectiveness

## Common Scenarios

### Scenario 1: Team Code Style Discovery
**User**: "We should always use this middleware pattern"
**Action**: Add to Project CLAUDE.md → Development Guidelines → Code Patterns section with example

### Scenario 2: Project-Specific Setup
**User**: "Remember that this project requires WSL and Docker"
**Action**: Add to Local CLAUDE.md → Prerequisites section with setup links

### Scenario 3: Anti-Pattern Identification
**User**: "Don't use this approach, we found it causes race conditions"
**Action**: Create/update Anti-Patterns section with before/after examples

### Scenario 4: New Developer Onboarding
**User**: "Add a checklist for getting new developers started"
**Action**: Create structured onboarding guide and reference from CLAUDE.md

### Scenario 5: Performance Optimization
**User**: "Document why we cache this specific calculation"
**Action**: Add to Performance Considerations section with benchmark results

## Tools to Use

- **Read**: Examine existing documentation structure
- **Edit/Write**: Add or update documentation files
- **Bash**: Git operations and verification
- **TaskCreate/TaskUpdate**: Track documentation additions
- **Grep**: Search for related content

## Maintenance Cycle

### Quarterly Reviews
- Check if guidelines still apply
- Update examples if patterns have evolved
- Remove obsolete entries
- Add missing cross-references

### Annual Cleanup
- Archive outdated patterns
- Consolidate duplicated guidance
- Refactor overly complex sections
- Update stale links

### Triggers for Updates
- New team member joins (update onboarding)
- Major version upgrade (update dependencies)
- Code review reveals common mistake (add anti-pattern)
- New tool adoption (add to guidelines)

## Notes

- Focus on knowledge worth preserving beyond individual conversations
- Avoid adding every decision; capture patterns and principles
- Include context for future readers who won't have conversation history
- Keep guidelines current through periodic review
- Link new memory to existing documentation
- Use examples for clarity
- Make guidelines specific to the project, not generic advice

## Reference Files

- [Scope Decision Tree](references/scope-decision-tree.md) - Where to document
- [Documentation Patterns](references/documentation-patterns.md) - How to format
- [Memory Maintenance](references/memory-maintenance.md) - Keeping knowledge current
- [CLAUDE.md Template](assets/claude-md-template.md) - Structure for CLAUDE.md files
- [Memory Entry Template](assets/memory-entry-template.md) - Format for entries

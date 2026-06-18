# Agent-MD-Refactor: Asset Templates

This directory contains three ready-to-use templates for the agent-md-refactor skill, helping you transform bloated agent instruction files into well-organized progressive disclosure structures.

## Files Overview

### 1. root-template.md (172 lines, ~600 tokens)
**Purpose**: Template for minimal root agent instruction file

**Contents**:
- Generic template structure (copy & adapt)
- 3 complete examples for different project types:
  - Python data pipeline (workflow orchestration)
  - TypeScript/React frontend (web application)
  - .NET backend API (REST service)
- Key guidelines for keeping root files lean
- Conversion checklist

**Use when**: You're creating a new CLAUDE.md or starting to refactor an existing one

**How to use**:
1. Copy the template structure
2. Adapt one of the 3 examples to your project type
3. Replace placeholders with your project details
4. Ensure file stays under 50 lines

---

### 2. linked-file-template.md (1,014 lines, ~7,000 tokens)
**Purpose**: Template for detailed linked instruction files

**Contents**:
- Generic template structure with standard sections
- **Complete Example 1**: TypeScript Conventions (2,100 tokens)
  - 5 detailed rules with When/Why/Implementation
  - 8+ code examples (good and bad patterns)
  - ESLint configuration
  - Cross-links to related files
  
- **Complete Example 2**: Testing Guidelines (2,400 tokens)
  - 5 core testing rules
  - Unit, integration, E2E patterns
  - Parameterized test examples
  - Command references

- Key guidelines for structure
- Checklists for consistency

**Use when**: Creating focused guides on specific topics (conventions, testing, architecture, etc.)

**How to use**:
1. Copy the "Template Structure" section
2. Use one of the complete examples as reference
3. Add your rules with When/Why/Implementation
4. Include good examples AND anti-patterns
5. Link to related `.claude/` files
6. Keep 100-300 lines (1,500-4,000 tokens)

---

### 3. before-after-example.md (1,079 lines, ~7,500 tokens)
**Purpose**: Real-world transformation example showing progressive disclosure in action

**Contents**:
- **The Problem**: 349-line bloated CLAUDE.md (5,200 tokens)
  - All rules, patterns, and guidelines in one file
  - Mixed frontend/backend/testing/deployment
  - Difficult to navigate and maintain
  
- **The Solution**: Progressive disclosure structure
  - Root file (38 lines, 600 tokens)
  - 4 linked guides (total ~700 lines)
  - Complete example of each file
  
- **Comparison Table**:
  - Token count reduction: 88% for most queries
  - Readability improvements
  - DX and AI efficiency gains
  
- **Implementation Steps**: 5-step guide to refactor
- **Benefits Achieved**: Concrete improvements with metrics

**Use when**: You need to understand the philosophy and see real examples before refactoring

**How to use**:
1. Read "The Problem" to identify if your file has same issues
2. Study "The Solution" structure
3. Review complete file examples to understand format
4. Follow "Implementation Steps" for your project
5. Check "Conversion Checklist" before committing changes

---

## Quick Reference

### Use root-template.md if you need to:
- [ ] Create a new CLAUDE.md from scratch
- [ ] Understand minimal structure requirements
- [ ] See 3 different project type examples
- [ ] Know what NOT to include in root file

### Use linked-file-template.md if you need to:
- [ ] Create detailed guides for specific topics
- [ ] Learn "When/Why/Implementation" structure
- [ ] See complete worked examples
- [ ] Understand good vs. bad patterns
- [ ] Set up cross-linking between files

### Use before-after-example.md if you need to:
- [ ] See how to refactor a bloated file
- [ ] Understand token count savings
- [ ] Learn implementation workflow
- [ ] Understand progressive disclosure benefits
- [ ] Get step-by-step conversion guide

---

## Example Workflow

**Scenario: You have a 300+ line CLAUDE.md to refactor**

1. **Start with**: `before-after-example.md`
   - Read "The Problem" section
   - Identify similar issues in your file
   - Study "The Solution" structure

2. **Then use**: `root-template.md`
   - Pick the example matching your project type
   - Create a new root file with quick start only
   - Add links to detailed guides you'll create

3. **Then create guides using**: `linked-file-template.md`
   - For each major section (frontend, backend, testing, etc.)
   - Copy the template structure
   - Fill in your specific rules and examples
   - Keep each file 100-300 lines

4. **Finally**: Follow the "Conversion Checklist" in before-after-example.md

---

## Token Count Reference

| File | Lines | Tokens | Use Case |
|------|-------|--------|----------|
| root-template.md | 172 | ~600 | Quick reference for root structure |
| linked-file-template.md | 1,014 | ~7,000 | Learn detailed file structure |
| before-after-example.md | 1,079 | ~7,500 | Understand refactoring workflow |
| **Combined** | **2,265** | **~15,000** | Complete asset package |

**When used**: Agents load these templates ONCE to understand structure, then generate specific files for your project.

---

## Tips for Success

### Root File Tips
- Keep under 50 lines
- Link early and link often
- Use consistent heading structure
- Include 3-5 core commands only

### Linked File Tips
- One topic per file (not multiple)
- Include both good AND bad examples
- Use "When/Why/Implementation" pattern
- Add token count and reading time

### Progressive Disclosure Tips
- Root file should feel complete on its own
- Each linked file should be self-contained
- Use cross-references for related files
- Keep files focused and narrow

---

## Common Patterns

### Good Root File Structure
```
# Project Name
## Quick Start
[1-2 sentence description]
[Prerequisites]
[3-5 essential commands]
## Documentation
[Links to detailed guides]
## See Also
[External links]
```

### Good Linked File Structure
```
# Topic - Project Name
## Overview
[2-3 sentences]
## Rules & Conventions
### Rule 1: [Specific Rule]
[When/Why/Implementation]
## Examples
### Good Examples
[2-3 examples with explanations]
### Avoid
[2-3 anti-patterns]
## See Also
[Links to related files]
```

---

## File Locations

```
.claude/skills/agent-md-refactor/assets/
├── README.md (this file)
├── root-template.md (172 lines)
├── linked-file-template.md (1,014 lines)
└── before-after-example.md (1,079 lines)
```

Copy these templates to your project and adapt them to your needs!

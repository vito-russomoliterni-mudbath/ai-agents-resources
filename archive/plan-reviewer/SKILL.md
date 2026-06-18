---
name: plan-reviewer
description: Reviews and validates proposed execution plans in plan mode. Ensures command accuracy, best practice adherence, and codebase compatibility using research and exploration. Use this skill after generating a plan but before execution.
license: MIT
metadata:
  version: "1.0.0"
---

# Plan Reviewer

## Overview
This skill guides you through a rigorous self-review of a proposed execution plan. It focuses on validating the technical accuracy of commands, ensuring decisions align with industry and project-specific best practices, and confirming that proposed changes are compatible with the existing codebase.

## Prerequisites
- The agent MUST be in **Plan Mode**.
- A draft plan MUST have been generated and shared with the user.

## Workflow

### 1. Systematic Command Validation
Deconstruct the plan into individual shell commands and tool calls.
- **Documentation Check:** Use `Context7 MCP` to verify syntax, parameters, and version compatibility for every command.
- **External Search:** If `Context7` is insufficient, use `google_web_search` or `web_fetch` to double-check against the latest official documentation.
- **Safety Check:** Identify any potentially destructive commands and ensure they are necessary and safely scoped.

### 2. Best Practice & Architectural Review
Evaluate the plan's logic and architectural decisions.
- **Project Context:** Check the plan against any local `GEMINI.md` or `AGENTS.md` files for project-specific conventions.
- **Standard Practices:** Ensure the proposed solution follows idiomatic patterns for the relevant language and framework.
- **Structural Fit:** Verify how the proposed changes integrate with the existing architecture.

### 3. Codebase Exploration
When in doubt about the impact of a change, explore the repository.
- **Dependency Mapping:** Use `grep_search` and `glob` to find related files, functions, or configurations that might be affected.
- **Conflict Identification:** Look for existing patterns or abstractions that the plan might be duplicating or violating.
- **Read-Verify:** Use `read_file` to examine the implementation details of critical integration points.

### 4. Consolidation & User Feedback
Summarize the findings of the review.
- **Adjust Plan:** If errors or improvements are found, update the plan accordingly.
- **Final Doubt Resolution:** If any part of the plan remains ambiguous after exploration and research, **STOP** and ask the user for clarification or guidance.

## Examples
- "I've reviewed the `npm install` command syntax in the plan using Context7 to ensure the `--save-exact` flag is correctly applied."
- "Searching the codebase for existing usages of the `BaseService` class to ensure the new `ExtendedService` adheres to the established inheritance pattern."

## References
- [Review Checklist](assets/review-checklist.md)

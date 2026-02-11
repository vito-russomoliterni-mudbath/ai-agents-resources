---
name: reviewing-pr-links
description: Reviews a GitHub pull request from a URL by checking ticket scope, code changes, status checks, and every PR comment/review thread. Use when asked to audit whether a PR does what it claims and whether comments marked resolved are actually resolved in code.
license: MIT
metadata:
  author: bdk-insite
  version: "1.0.0"
---

# Reviewing PR Links

## Overview
Use this skill to perform a rigorous PR audit from a GitHub pull request link.

This workflow verifies:
- what the ticket asks for
- what the PR claims to deliver
- what the code actually changes
- whether all comments and review threads were properly resolved

## Degrees Of Freedom
- Medium freedom: follow the workflow order, but adapt if data is missing or the PR uses non-standard conventions.

## Prerequisites
- GitHub access via MCP tools
- Repository access for the PR and linked issue
- Ability to fetch PR files and review threads

## Workflow
1. Parse the PR URL.
- Extract `owner`, `repo`, and `pullNumber`.

2. Load core PR metadata.
- Read PR details (`get`), changed files (`get_files`), reviews (`get_reviews`), review threads/comments (`get_review_comments`), issue comments on the PR (`get_comments`), and checks (`get_status`).
- Do not rely on AI bot summaries as source of truth.

3. Identify and load the source ticket.
- Read the linked issue from PR title/body/branch naming.
- If multiple tickets are referenced, review all.

4. Build a scope checklist from the ticket.
- Convert ticket asks into explicit verification points.
- Include behavioural expectations, not just wording.

5. Inspect changed code against the checklist.
- For each changed file, confirm implementation satisfies ticket intent.
- Flag mismatches between labels/text and actual data bindings, logic, or types.
- Check for regressions, edge cases, and missing validation/tests.

6. Audit every PR comment and review thread.
- Read all review threads, review comments, and PR issue comments.
- For each resolved thread, determine if resolution is valid:
  - `Valid`: code changed or rationale is correct and risk accepted.
  - `Invalid`: marked resolved but concern still exists in current code.
- Treat "ignore", "outdated", or bot dismissal as unresolved unless code outcome is correct.

7. Evaluate checks and delivery risk.
- Report CI/check status and whether verification is limited by missing checks.

8. Produce findings-first output.
- Order findings by severity: High, Medium, Low.
- Include precise file references with line numbers.
- Separate:
  - Findings
  - Open questions/assumptions
  - Ticket scope pass/fail summary
  - Comment-resolution integrity summary
  - Verification limits

## Review Criteria
Use these minimum standards:
- Ticket requirement is met functionally, not cosmetically.
- Field labels match underlying data semantics.
- Sorting/comparators align with actual data type.
- Null, negative, and boundary handling is explicit and consistent.
- Resolved comments are backed by code/rationale, not just thread state.

## Output Template
Use this structure:

1. Findings (ordered by severity)
- `High`: ...
- `Medium`: ...
- `Low`: ...

2. Open questions / assumptions
- ...

3. Ticket scope check
- Requirement: `...` -> `Met` / `Not met` / `Partially met`

4. PR comment resolution check
- Total threads: `N`
- Properly resolved: `N`
- Marked resolved but not actually resolved: `N`
- Notes: `...`

5. Verification limits
- ...

## Guardrails
- Never conclude "all good" without reading all review threads and PR comments.
- Never treat a thread as resolved solely because GitHub marks it resolved.
- Prefer primary artefacts: issue text, code diff, source files, and thread content.

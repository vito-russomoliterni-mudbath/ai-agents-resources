# Skill Reference Guide

Quick reference for each skill's unique characteristics and workflows.

## adding-memory

**Purpose:** Capture project knowledge and best practices in appropriate documentation files.

**Key Feature:** Uses a scope decision tree to determine where knowledge belongs (personal/project/local CLAUDE.md vs structured docs).

**Workflow:** Clarify -> Determine scope -> Choose location -> Format -> Implement -> Verify

## adding-tests

**Purpose:** Add or update unit tests for code changes and iterate until all tests pass.

**Key Feature:** Detects test framework automatically, supports diff-based (PR review) or feature-focused (specific area) modes.

**Workflow:** Detect framework -> Identify changes -> Baseline -> Add tests -> Iterate until green

**Modes:**
- Diff-based: Compare against develop branch
- Feature-focused: Target specific area
- Coverage audit: Scan for gaps

## building-features

**Purpose:** Implement new features using a structured approach.

**Key Feature:** Structured phases with quality gates at each step.

**Workflow:** Plan -> Task list -> Documentation -> Code -> Verify -> QA -> Iterate

**Principle:** Avoid over-engineering, keep solutions minimal

## cleaning-git-branches

**Purpose:** Find and help clean up local git branches that have no remote or have been untouched for 30+ days.

**Key Feature:** Identifies "gone" branches (whose remote was deleted) and stale branches based on committer date.

**Workflow:** Identify "gone" branches -> Identify stale branches (>30 days) -> Present report -> Ask for user confirmation -> Perform deletion

## building-skills

**Purpose:** Convert AI assistant workflows into Agent Skills open standard compatible skills.

**Key Feature:** Transforms workflows from various tools (Claude Code, Cursor, Windsurf, Aider, etc.) into properly formatted skills following the Agent Skills open standard specification (agentskills.io).

**Workflow:** Gather input -> Analyse patterns -> Design structure -> Validate name -> Write description -> Create SKILL.md -> Populate resources -> Validate compliance -> Test

**Specification:** Follows Agent Skills open standard v1.0 and works with agents that support the format.

## creating-automation-scripts

**Purpose:** Create automation scripts for repetitive tasks with environment-aware setup and safe execution patterns.

**Key Feature:** Detects environment constraints first, then selects script strategy and validation approach.

**Workflow:** Detect environment -> Clarify requirements -> Design script -> Implement -> Validate safety and idempotency

## creating-subagents

**Purpose:** Create Claude Code sub-agents through guided task analysis and configuration design.

**Key Feature:** Uses decision logic to recommend model, tool access, permission mode, and instruction structure.

**Workflow:** Discovery -> Analysis -> Design -> Validation -> Output

## fixing-bugs

**Purpose:** Systematically debug and fix software defects.

**Key Feature:** Follows a reproducible debugging approach with root cause analysis.

**Workflow:** Reproduce -> Root cause analysis -> Minimal fix -> Test -> Regression test

**Principle:** Fix the root cause, not symptoms

## refactoring-agent-instructions

**Purpose:** Refactor bloated agent instruction files using progressive disclosure principles.

**Key Feature:** Produces a minimal root file with links to categorised detailed files.

**Workflow:** Find contradictions -> Extract essentials -> Categorise -> Create structure -> Prune

**Goal:** Root file under 50 lines plus categorised linked files

## refactoring-code

**Purpose:** Safe, incremental refactoring while preserving behavior.

**Key Feature:** Incremental refactoring with tests after each change.

**Workflow:** Baseline -> Detect smells -> Apply patterns -> Test after each step -> Commit

**Principle:** Small steps, always green, commit frequently

## reviewing-pr-links

**Purpose:** Review a GitHub pull request from a URL against ticket scope, changed code, checks, and review-thread integrity.

**Key Feature:** Validates whether resolved comments are actually resolved in code, not just marked resolved in GitHub.

**Workflow:** Parse PR URL -> Load PR metadata -> Build scope checklist -> Inspect code changes -> Audit comments/threads -> Report findings first

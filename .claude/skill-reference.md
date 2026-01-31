# Skill Reference Guide

Quick reference for each skill's unique characteristics and workflows.

## adding-memory

**Purpose:** Capture project knowledge and best practices in appropriate documentation files.

**Key Feature:** Uses scope decision tree to determine where knowledge belongs (personal/project/local CLAUDE.md vs structured docs).

**Workflow:** Clarify → Determine scope → Choose location → Format → Implement → Verify

## adding-tests

**Purpose:** Add or update unit tests for code changes and iterate until all tests pass.

**Key Feature:** Detects test framework automatically, supports diff-based (PR review) or feature-focused (specific area) modes.

**Workflow:** Detect framework → Identify changes → Baseline → Add tests → Iterate until green

**Modes:**
- Diff-based: Compare against develop branch
- Feature-focused: Target specific area
- Coverage audit: Scan for gaps

## building-features

**Purpose:** Implement new features using a structured approach.

**Key Feature:** Structured phases with quality gates at each step.

**Workflow:** Plan → Task list → Documentation → Code → Verify → QA → Iterate

**Principle:** Avoid over-engineering, keep solutions minimal

## building-skills

**Purpose:** Convert AI assistant workflows into reusable Claude skills.

**Key Feature:** Transforms workflows from various tools (Claude Code, Cursor, Windsurf, Aider) into properly formatted Claude skills following the Agent Skills specification.

**Workflow:** Gather input → Analyze workflow → Structure skill → Generate SKILL.md → Validate → Refine

**Principle:** Follow Agent Skills specification and best practices

## fixing-bugs

**Purpose:** Systematically debug and fix software defects.

**Key Feature:** Follows systematic debugging approach with root cause analysis.

**Workflow:** Reproduce → Root cause analysis → Minimal fix → Test → Regression test

**Principle:** Fix the root cause, not symptoms

## refactoring-agent-instructions

**Purpose:** Refactor bloated agent instruction files using progressive disclosure principles.

**Key Feature:** Applies progressive disclosure principles: minimal root file with links to categorized detailed files.

**Workflow:** Find contradictions → Extract essentials → Categorize → Create structure → Prune

**Goal:** Root file <50 lines + categorized linked files

## refactoring-code

**Purpose:** Safe, incremental refactoring while preserving behavior.

**Key Feature:** Incremental refactoring with tests after each change.

**Workflow:** Baseline → Detect smells → Apply patterns → Test after each step → Commit

**Principle:** Small steps, always green, commit frequently

# Skill Reference Guide

Quick reference for each skill's unique characteristics and workflows.

## add-memory

**Purpose:** Capture project knowledge and best practices in appropriate documentation files.

**Key Feature:** Uses scope decision tree to determine where knowledge belongs (personal/project/local CLAUDE.md vs structured docs).

**Workflow:** Clarify → Determine scope → Choose location → Format → Implement → Verify

## add-unit-tests

**Purpose:** Add or update unit tests for code changes and iterate until all tests pass.

**Key Feature:** Detects test framework automatically, supports diff-based (PR review) or feature-focused (specific area) modes.

**Workflow:** Detect framework → Identify changes → Baseline → Add tests → Iterate until green

**Modes:**
- Diff-based: Compare against develop branch
- Feature-focused: Target specific area
- Coverage audit: Scan for gaps

## agent-md-refactor

**Purpose:** Refactor bloated agent instruction files using progressive disclosure principles.

**Key Feature:** Applies progressive disclosure principles: minimal root file with links to categorized detailed files.

**Workflow:** Find contradictions → Extract essentials → Categorize → Create structure → Prune

**Goal:** Root file <50 lines + categorized linked files

## bug-fix

**Purpose:** Systematically debug and fix software defects.

**Key Feature:** Follows systematic debugging approach with root cause analysis.

**Workflow:** Reproduce → Root cause analysis → Minimal fix → Test → Regression test

**Principle:** Fix the root cause, not symptoms

## new-feature

**Purpose:** Implement new features using a structured approach.

**Key Feature:** Structured phases with quality gates at each step.

**Workflow:** Plan → Task list → Documentation → Code → Verify → QA → Iterate

**Principle:** Avoid over-engineering, keep solutions minimal

## refactor

**Purpose:** Safe, incremental refactoring while preserving behavior.

**Key Feature:** Incremental refactoring with tests after each change.

**Workflow:** Baseline → Detect smells → Apply patterns → Test after each step → Commit

**Principle:** Small steps, always green, commit frequently

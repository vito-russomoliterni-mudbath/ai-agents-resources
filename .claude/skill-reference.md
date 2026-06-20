# Skill Reference Guide

Quick reference for each active skill's unique characteristics and workflows.

## grill-me

**Purpose:** Relentlessly interview the user about a plan or design until every branch of the decision tree is resolved.

**Key Feature:** Asks one question at a time, provides a recommended answer, and walks each decision branch iteratively until shared understanding is reached.

**Workflow:** Ask one question → provide recommendation → resolve branch → repeat until no open questions remain

## orchestrator

**Purpose:** Delegate research, file edits, and diff review to opencode subagents to preserve the host agent's context budget.

**Key Feature:** Dispatches three specialised subagents (`researcher`, `editor`, `reviewer`) defined in `subagents/`.

**Workflow:** Dispatch `researcher` → review summary → dispatch `editor` → dispatch `reviewer`

## showlinks

**Purpose:** Find official documentation and reputable sources for a topic, then return direct vetted links.

**Key Feature:** Dispatches a reviewer subagent to validate source quality before returning links.

**Workflow:** Find official docs → confirm version match → dispatch reviewer → refine if rejected → return vetted links

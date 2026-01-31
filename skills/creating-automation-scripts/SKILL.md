---
name: creating-automation-scripts
description: This skill should be used when the user asks to "create a script", "write a script", "automate this task", "make a bash script", or "make a PowerShell script". It guides automation script development with environment detection, detailed requirements gathering, and best practices for the target platform.
version: 1.0.0
---

# Creating Automation Scripts

## Overview

Create automation scripts with automatic environment detection and best practices. This workflow helps generate scripts for file processing, build tasks, deployment, and development automation.

This skill guides you through:
- Gathering detailed requirements from the user
- Detecting or clarifying the target environment
- Designing script structure
- Implementing with platform-specific best practices
- Validating the script

## Prerequisites

- Clear understanding of what the script should accomplish
- Access to the target environment (or knowledge of it)
- Any required dependencies identified

## Workflow

### 1. Requirements Gathering

Ask the user detailed questions about the script:

**Essential questions:**
- What is the script's primary purpose?
- What inputs does it need (arguments, files, environment variables)?
- What outputs should it produce (files, console output, exit codes)?
- Are there any dependencies or prerequisites?
- What error conditions should it handle?

**Use AskUserQuestion** to clarify:
- Specific file paths or patterns
- Expected input formats
- Success/failure criteria
- Logging requirements

See [Scripting Patterns](references/scripting-patterns.md) for common automation scenarios.

### 2. Environment Detection

Detect the current execution environment to determine the appropriate script type.

**Detection methods:**

Use **Bash** to check the environment:
```bash
# Check if PowerShell is available
command -v pwsh || command -v powershell

# Check shell type
echo $SHELL
echo $0
```

Or check PowerShell:
```powershell
$PSVersionTable.PSVersion
$env:SHELL
```

**Decision logic:**
- If running in PowerShell on Windows → Default to PowerShell 5.1
- If running in Bash/Zsh on Linux/macOS → Default to Bash
- If uncertain → **Always prompt the user**

**When to prompt user:**
- Environment detection is ambiguous
- User might want a different target than current environment
- Cross-platform support might be needed

Use **AskUserQuestion** with options:
1. PowerShell 5.1 (Windows native)
2. Bash (Linux/macOS/WSL)
3. Cross-platform (discuss options)

See [Environment Detection](assets/environment-detection.md) for code snippets.

### 3. Script Design

Design the script structure based on the target environment.

**For PowerShell 5.1:**
- Use `[CmdletBinding()]` for advanced function features
- Define parameters with `[Parameter()]` attributes
- Include comment-based help
- Plan error handling with `try/catch`

**For Bash:**
- Choose appropriate shebang (`#!/usr/bin/env bash`)
- Plan `set` options for error handling
- Design functions for reusable logic
- Plan argument parsing

**Cross-platform (only if user requests):**
- Offer PowerShell 7+ (runs on Windows, Linux, macOS)
- Offer dual scripts (.sh + .ps1) for maximum compatibility
- Discuss trade-offs with user

See [Environment Decision Tree](references/environment-decision-tree.md) for guidance.

### 4. Implementation

Generate the script using appropriate templates.

**PowerShell scripts:**
- Start with [PowerShell Template](assets/script-template-powershell.ps1)
- Add comment-based help with `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`
- Use `$ErrorActionPreference = 'Stop'` for fail-fast behavior
- Add `[CmdletBinding()]` for `-Verbose`, `-Debug` support
- Validate parameters with `[ValidateNotNullOrEmpty()]`, `[ValidateScript()]`

**Bash scripts:**
- Start with [Bash Template](assets/script-template-bash.sh)
- Use `set -euo pipefail` for strict error handling
- Add usage function for help
- Quote all variable expansions (`"$var"`)
- Use `[[ ]]` for conditionals (bash-specific)

**Use these tools:**
- **Write**: Create the script file
- **Edit**: Modify existing scripts
- **Bash**: Test script execution

### 5. Validation

Verify the script works correctly.

**Syntax validation:**

For PowerShell:
```powershell
# Parse without executing
[System.Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$null, [ref]$errors)
```

For Bash:
```bash
# Check syntax
bash -n script.sh
# Or with shellcheck if available
shellcheck script.sh
```

**Functional testing:**
- Run with test inputs
- Verify expected outputs
- Test error handling paths
- Check exit codes

**Provide user with:**
- How to run the script
- Required permissions or environment setup
- Example invocations

## Common Scenarios

### File Processing Script

**User request:** "Create a script to process all CSV files in a directory"

**Questions to ask:**
- What processing is needed (rename, convert, validate)?
- Recursive or single directory?
- What to do with processed files?
- Error handling for malformed files?

**Implementation:**
1. Detect environment
2. Create script with file iteration
3. Add logging for processed files
4. Handle errors gracefully

### Build/Deployment Script

**User request:** "Create a deployment script"

**Questions to ask:**
- What needs to be deployed (files, containers, services)?
- Target environment (local, staging, production)?
- Pre/post deployment steps?
- Rollback requirements?

**Implementation:**
1. Detect environment
2. Create script with deployment steps
3. Add validation checks
4. Include rollback logic if needed

### Development Setup Script

**User request:** "Create a script to set up the dev environment"

**Questions to ask:**
- What tools need to be installed?
- Configuration files to create?
- Environment variables to set?
- OS-specific requirements?

**Implementation:**
1. Detect or ask about target OS
2. Create script with installation steps
3. Add idempotency (safe to run multiple times)
4. Provide clear output of what was done

## Tools to Use

### Requirements & Clarification
- **AskUserQuestion**: Gather requirements, clarify ambiguity, confirm target environment
- **Read**: Examine existing scripts or configuration for context

### Environment Detection
- **Bash**: Run detection commands (`echo $SHELL`, `$PSVersionTable`)

### Implementation
- **Write**: Create new script files
- **Edit**: Modify existing scripts
- **Read**: Reference templates and patterns

### Validation
- **Bash**: Run syntax checks and test execution

## Best Practices

### PowerShell
- Always include comment-based help
- Use approved verbs (`Get-`, `Set-`, `New-`, etc.)
- Prefer cmdlets over aliases in scripts
- Use `Write-Verbose` for diagnostic output
- Return proper exit codes with `exit`

### Bash
- Always use `set -euo pipefail`
- Quote all variable expansions
- Use functions to organize logic
- Provide `--help` output
- Use meaningful exit codes (0 = success, 1+ = error)

### General
- Include a header comment with purpose and usage
- Handle expected errors gracefully
- Log progress for long-running scripts
- Make scripts idempotent when possible
- Avoid hardcoded paths; use parameters or environment variables

## Anti-Patterns to Avoid

### Don't Skip Requirements
- Promptly ask questions rather than assume user intent
- Clarify before implementing

### Don't Ignore Errors
- Always handle errors explicitly
- Don't use `|| true` without good reason
- Don't suppress PowerShell errors with `-ErrorAction SilentlyContinue` by default

### Don't Assume Environment
- Always detect or ask about target environment
- Don't assume paths or tools exist
- Test for prerequisites

### Don't Over-Engineer
- Keep scripts focused on the specific task
- Don't add unnecessary features
- Don't create complex abstractions for simple tasks

## Reference Files

- [Environment Detection](assets/environment-detection.md) - Code snippets for detection
- [Bash Template](assets/script-template-bash.sh) - Starting template for Bash scripts
- [PowerShell Template](assets/script-template-powershell.ps1) - Starting template for PowerShell scripts
- [Scripting Patterns](references/scripting-patterns.md) - Common patterns and best practices
- [Environment Decision Tree](references/environment-decision-tree.md) - Choosing the right script type

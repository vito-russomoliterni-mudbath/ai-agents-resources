#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Install or update Claude Code and Codex skills to local agent home directories.

.DESCRIPTION
    This script copies skills from this repository to your local Claude Code and/or Codex home directories
    (~/.claude/skills/ and ~/.codex/skills/). It will prompt for confirmation before installing or updating
    each skill, showing which files will be affected. Use the -y flag to skip confirmations and install/update
    all skills automatically.

.PARAMETER y
    Skip confirmation prompts and install/update all skills automatically.

.PARAMETER SkipAgentPrompt
    Skip the agent selection prompt and install to both Claude Code and Codex.

.PARAMETER v
    Show detailed output including full paths, file sizes, and progress messages.

.PARAMETER DryRun
    Show what would be done without actually making any changes.

.PARAMETER help
    Display this help message.

.EXAMPLE
    .\install-skills.ps1
    Install skills with confirmation prompts for each skill.

.EXAMPLE
    .\install-skills.ps1 -y
    Install all skills without confirmation prompts.

.EXAMPLE
    .\install-skills.ps1 -SkipAgentPrompt
    Install skills to both Claude Code and Codex without asking which agent to target.

.EXAMPLE
    .\install-skills.ps1 -DryRun
    Show what would be installed/updated without making changes.

.EXAMPLE
    .\install-skills.ps1 -v -y
    Install all skills with detailed progress output.

.EXAMPLE
    .\install-skills.ps1 -help
    Display help message.
#>

param(
    [switch]$y,
    [switch]$v,
    [switch]$DryRun,
    [switch]$SkipAgentPrompt,
    [switch]$help,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$RemainingArgs
)

# Check for invalid parameters or arguments
if ($RemainingArgs.Count -gt 0) {
    Write-Host "Error: Invalid parameter(s): $($RemainingArgs -join ', ')" -ForegroundColor Red
    Write-Host "Use -help for usage information" -ForegroundColor Yellow
    Write-Host "`nValid options:" -ForegroundColor Cyan
    Write-Host "  -y          Skip confirmation prompts" -ForegroundColor Gray
    Write-Host "  -v          Show detailed output" -ForegroundColor Gray
    Write-Host "  -DryRun     Show what would be done without making changes" -ForegroundColor Gray
    Write-Host "  -SkipAgentPrompt  Skip agent selection (defaults to both)" -ForegroundColor Gray
    Write-Host "  -help       Show help message" -ForegroundColor Gray
    exit 1
}

# Show help if requested
if ($help) {
    Get-Help $MyInvocation.MyCommand.Path -Detailed
    exit 0
}

# Show dry-run notice
if ($DryRun) {
    Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host "                    DRY RUN MODE                        " -ForegroundColor Magenta
    Write-Host "  No changes will be made to the filesystem             " -ForegroundColor Magenta
    Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host ""
}

# Color helper functions
function Write-Success { param($Message) Write-Host $Message -ForegroundColor Green }
function Write-Info { param($Message) Write-Host $Message -ForegroundColor Cyan }
function Write-Warning-Custom { param($Message) Write-Host $Message -ForegroundColor Yellow }
function Write-Error-Custom { param($Message) Write-Host $Message -ForegroundColor Red }
function Write-Verbose-Custom {
    param($Message)
    if ($v) {
        Write-Host "[VERBOSE] $Message" -ForegroundColor DarkGray
    }
}
function Write-DryRun {
    param($Message)
    if ($DryRun) {
        Write-Host "[DRY RUN] $Message" -ForegroundColor Magenta
    }
}

# Resolve home directory for a given agent
function Resolve-AgentHome {
    param(
        [string]$AgentName,
        [string]$EnvVarName,
        [string]$DefaultFolderName
    )

    $envValue = [Environment]::GetEnvironmentVariable($EnvVarName)
    if ($envValue) {
        Write-Verbose-Custom "Using ${EnvVarName} environment variable for ${AgentName}: $envValue"
        return $envValue
    }

    if ($IsWindows -or $env:OS -match "Windows") {
        Write-Verbose-Custom "Windows detected, using USERPROFILE\$DefaultFolderName for $AgentName"
        return (Join-Path $env:USERPROFILE $DefaultFolderName)
    }

    Write-Verbose-Custom "Unix-like system detected, using HOME/$DefaultFolderName for $AgentName"
    return (Join-Path $env:HOME $DefaultFolderName)
}

$agents = @(
    [pscustomobject]@{ Key = "claude"; DisplayName = "Claude Code"; EnvVar = "CLAUDE_HOME"; DefaultFolder = ".claude" },
    [pscustomobject]@{ Key = "codex"; DisplayName = "Codex"; EnvVar = "CODEX_HOME"; DefaultFolder = ".codex" }
)

$selectedAgentKeys = @("claude", "codex")
if (-not $SkipAgentPrompt) {
    Write-Host ""
    Write-Host "Select which agent to install skills for:" -ForegroundColor Cyan
    Write-Host "  [1] Claude Code" -ForegroundColor Gray
    Write-Host "  [2] Codex" -ForegroundColor Gray
    Write-Host "  [3] Both (default)" -ForegroundColor Gray
    $agentChoice = Read-Host "Choose an option [1/2/3]"

    $normalizedChoice = ($agentChoice | ForEach-Object { $_.Trim().ToLower() })
    switch -regex ($normalizedChoice) {
        "^(1|c|claude)$" { $selectedAgentKeys = @("claude") }
        "^(2|x|codex)$" { $selectedAgentKeys = @("codex") }
        "^(3|b|both|)$" { $selectedAgentKeys = @("claude", "codex") }
        default {
            Write-Warning-Custom "Unrecognized selection '$agentChoice'. Defaulting to both agents."
            $selectedAgentKeys = @("claude", "codex")
        }
    }
} else {
    Write-Verbose-Custom "Skipping agent prompt; defaulting to both agents"
}

# Get source skills directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillsSourceDir = Join-Path $scriptDir "skills"

Write-Verbose-Custom "Script directory: $scriptDir"
Write-Verbose-Custom "Source skills directory: $skillsSourceDir"

if (-not (Test-Path $skillsSourceDir)) {
    Write-Error-Custom "Error: Skills directory not found at $skillsSourceDir"
    exit 1
}

# Get all skills
$skills = Get-ChildItem -Path $skillsSourceDir -Directory

if ($skills.Count -eq 0) {
    Write-Warning-Custom "No skills found in $skillsSourceDir"
    exit 0
}

Write-Info "`nFound $($skills.Count) skill(s) to install/update`n"

function Install-SkillsForAgent {
    param(
        [string]$AgentDisplayName,
        [string]$SkillsDestDir,
        [System.IO.DirectoryInfo[]]$Skills
    )

    Write-Host ""
    Write-Host "Installing skills for $AgentDisplayName" -ForegroundColor Cyan
    Write-Host "Target directory: $SkillsDestDir" -ForegroundColor DarkGray

    $installed = 0
    $updated = 0
    $skipped = 0

    foreach ($skill in $Skills) {
        $skillName = $skill.Name
        $sourcePath = $skill.FullName
        $destPath = Join-Path $SkillsDestDir $skillName

        Write-Host "──────────────────────────────────────────────────" -ForegroundColor DarkGray
        Write-Host "Agent: $AgentDisplayName" -ForegroundColor DarkGray
        Write-Host "Skill: " -NoNewline
        Write-Host $skillName -ForegroundColor Magenta

        Write-Verbose-Custom "Source: $sourcePath"
        Write-Verbose-Custom "Destination: $destPath"

        $isUpdate = Test-Path $destPath
        Write-Verbose-Custom "Is update: $isUpdate"

        if ($isUpdate) {
            Write-Warning-Custom "  Status: Already exists (will be updated)"

            # Get files in old version
            $oldFileObjs = Get-ChildItem -Path $destPath -Recurse -File
            $oldFiles = $oldFileObjs | ForEach-Object {
                $_.FullName.Substring($destPath.Length + 1)
            } | Sort-Object

            # Get files in new version
            $newFileObjs = Get-ChildItem -Path $sourcePath -Recurse -File
            $newFiles = $newFileObjs | ForEach-Object {
                $_.FullName.Substring($sourcePath.Length + 1)
            } | Sort-Object

            Write-Verbose-Custom "Old version has $($oldFiles.Count) files"
            Write-Verbose-Custom "New version has $($newFiles.Count) files"

            # Calculate differences
            $toDelete = $oldFiles | Where-Object { $_ -notin $newFiles }
            $toAdd = $newFiles | Where-Object { $_ -notin $oldFiles }
            $toUpdate = $oldFiles | Where-Object { $_ -in $newFiles }

            # Show what will happen
            if ($toDelete.Count -gt 0) {
                Write-Host "  Files to delete:" -ForegroundColor Red
                $toDelete | ForEach-Object {
                    $filePath = $_
                    Write-Host "    - $filePath" -ForegroundColor DarkRed
                    if ($v) {
                        $fullPath = Join-Path $destPath $filePath
                        if (Test-Path $fullPath) {
                            $size = (Get-Item $fullPath).Length
                            Write-Verbose-Custom "      Size: $size bytes"
                        }
                    }
                }
            }

            if ($toAdd.Count -gt 0) {
                Write-Host "  Files to add:" -ForegroundColor Green
                $toAdd | ForEach-Object {
                    $filePath = $_
                    Write-Host "    + $filePath" -ForegroundColor DarkGreen
                    if ($v) {
                        $fullPath = Join-Path $sourcePath $filePath
                        $size = (Get-Item $fullPath).Length
                        Write-Verbose-Custom "      Size: $size bytes"
                    }
                }
            }

            if ($toUpdate.Count -gt 0) {
                Write-Host "  Files to update:" -ForegroundColor Yellow
                $toUpdate | ForEach-Object {
                    $filePath = $_
                    Write-Host "    ~ $filePath" -ForegroundColor DarkYellow
                    if ($v) {
                        $oldPath = Join-Path $destPath $filePath
                        $newPath = Join-Path $sourcePath $filePath
                        $oldSize = (Get-Item $oldPath).Length
                        $newSize = (Get-Item $newPath).Length
                        $sizeDiff = $newSize - $oldSize
                        $diffSign = if ($sizeDiff -gt 0) { "+" } elseif ($sizeDiff -lt 0) { "-" } else { "" }
                        Write-Verbose-Custom "      Old: $oldSize bytes, New: $newSize bytes ($diffSign$([Math]::Abs($sizeDiff)) bytes)"
                    }
                }
            }

        } else {
            Write-Info "  Status: New installation"

            # Get files in new version
            $newFileObjs = Get-ChildItem -Path $sourcePath -Recurse -File
            $newFiles = $newFileObjs | ForEach-Object {
                $_.FullName.Substring($sourcePath.Length + 1)
            } | Sort-Object

            Write-Verbose-Custom "New version has $($newFiles.Count) files"

            Write-Host "  Files to install:" -ForegroundColor Green
            $newFiles | ForEach-Object {
                $filePath = $_
                Write-Host "    + $filePath" -ForegroundColor DarkGreen
                if ($v) {
                    $fullPath = Join-Path $sourcePath $filePath
                    $size = (Get-Item $fullPath).Length
                    Write-Verbose-Custom "      Size: $size bytes"
                }
            }
        }

        # Ask for confirmation unless -y flag is set (skip in dry-run mode)
        $shouldInstall = $y.IsPresent -or $DryRun.IsPresent
        if (-not $shouldInstall) {
            Write-Host ""
            $action = if ($isUpdate) { "Update" } else { "Install" }
            $response = Read-Host "  $action this skill for $AgentDisplayName? [Y/n]"
            # Default to Yes - only skip if user explicitly enters 'n' or 'N'
            $shouldInstall = -not ($response -match '^[Nn]')
        }

        $copyAttempted = $false
        $copySucceeded = $false

        if ($shouldInstall) {
            if ($DryRun) {
                # Dry-run mode - just show what would happen
                if (Test-Path $destPath) {
                    Write-DryRun "[$AgentDisplayName] Would remove old version: $destPath"
                }
                Write-DryRun "[$AgentDisplayName] Would copy from: $sourcePath"
                Write-DryRun "[$AgentDisplayName] Would copy to: $destPath"

                if ($isUpdate) {
                    Write-Host "  [DRY RUN] Would update successfully" -ForegroundColor Magenta
                    $updated++
                } else {
                    Write-Host "  [DRY RUN] Would install successfully" -ForegroundColor Magenta
                    $installed++
                }
            } else {
                # Actually perform the operations
                try {
                    $copyAttempted = $true
                    # Remove old version if it exists
                    if (Test-Path $destPath) {
                        Write-Verbose-Custom "Removing old version: $destPath"
                        Remove-Item -Path $destPath -Recurse -Force -ErrorAction Stop
                        Write-Verbose-Custom "Old version removed successfully"
                    }

                    # Copy new version
                    Write-Verbose-Custom "Copying from: $sourcePath"
                    Write-Verbose-Custom "Copying to: $destPath"
                    Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force -ErrorAction Stop
                    Write-Verbose-Custom "Copy completed successfully"

                    if ($isUpdate) {
                        Write-Success "  ✓ Updated successfully"
                    } else {
                        Write-Success "  ✓ Installed successfully"
                    }
                    $copySucceeded = $true
                } catch {
                    Write-Error-Custom "  ✗ Failed: $($_.Exception.Message)"
                    Write-Verbose-Custom "Error details: $($_.Exception.ToString())"
                }
            }
        } else {
            Write-Warning-Custom "  ○ Skipped"
            $skipped++
        }

        if ($copySucceeded) {
            if ($isUpdate) {
                $updated++
            } else {
                $installed++
            }
        } elseif ($copyAttempted) {
            $skipped++
        }

        Write-Host ""
    }

    # Summary
    Write-Host "══════════════════════════════════════════════════" -ForegroundColor DarkGray
    if ($DryRun) {
        Write-Host "Summary (DRY RUN) - ${AgentDisplayName}:" -ForegroundColor Magenta
        Write-Host "  Would install: $installed" -ForegroundColor Green
        Write-Host "  Would update:  $updated" -ForegroundColor Yellow
        Write-Host "  Would skip:    $skipped" -ForegroundColor Gray
    } else {
        Write-Host "Summary - ${AgentDisplayName}:" -ForegroundColor Cyan
        Write-Host "  Installed: $installed" -ForegroundColor Green
        Write-Host "  Updated:   $updated" -ForegroundColor Yellow
        Write-Host "  Skipped:   $skipped" -ForegroundColor Gray
    }
    Write-Host "══════════════════════════════════════════════════" -ForegroundColor DarkGray

    if ($installed -gt 0 -or $updated -gt 0) {
        Write-Host ""
        if ($DryRun) {
            Write-Host "[DRY RUN] Skills would be available in $AgentDisplayName!" -ForegroundColor Magenta
            Write-Host "[DRY RUN] Location: $SkillsDestDir" -ForegroundColor Magenta
        } else {
            Write-Success "Skills are now available in $AgentDisplayName!"
            Write-Info "Location: $SkillsDestDir"
        }
    }

    return [pscustomobject]@{
        Installed = $installed
        Updated = $updated
        Skipped = $skipped
    }
}

foreach ($agentKey in $selectedAgentKeys) {
    $agent = $agents | Where-Object { $_.Key -eq $agentKey }
    if (-not $agent) {
        Write-Error-Custom "Unknown agent key '$agentKey'. Skipping."
        continue
    }

    $agentHome = Resolve-AgentHome -AgentName $agent.DisplayName -EnvVarName $agent.EnvVar -DefaultFolderName $agent.DefaultFolder
    Write-Info "$($agent.DisplayName) home directory: $agentHome"

    # Create skills directory if it doesn't exist
    $skillsDestDir = Join-Path $agentHome "skills"
    if (-not (Test-Path $skillsDestDir)) {
        if ($DryRun) {
            Write-DryRun "Would create $($agent.DisplayName) skills directory: $skillsDestDir"
        } else {
            Write-Info "Creating $($agent.DisplayName) skills directory: $skillsDestDir"
            Write-Verbose-Custom "Executing: New-Item -ItemType Directory -Path '$skillsDestDir' -Force"
            New-Item -ItemType Directory -Path $skillsDestDir -Force | Out-Null
        }
    } else {
        Write-Verbose-Custom "$($agent.DisplayName) skills directory already exists: $skillsDestDir"
    }

    Install-SkillsForAgent -AgentDisplayName $agent.DisplayName -SkillsDestDir $skillsDestDir -Skills $skills | Out-Null
}

exit 0

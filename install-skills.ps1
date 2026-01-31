#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Install or update Claude Code skills to local Claude home directory.

.DESCRIPTION
    This script copies skills from this repository to your local Claude home directory (~/.claude/skills/).
    It will prompt for confirmation before installing or updating each skill, showing which files will be affected.
    Use the -y flag to skip confirmations and install/update all skills automatically.

.PARAMETER y
    Skip confirmation prompts and install/update all skills automatically.

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

# Find Claude home directory
$claudeHome = if ($env:CLAUDE_HOME) {
    Write-Verbose-Custom "Using CLAUDE_HOME environment variable: $env:CLAUDE_HOME"
    $env:CLAUDE_HOME
} elseif ($IsWindows -or $env:OS -match "Windows") {
    Write-Verbose-Custom "Windows detected, using USERPROFILE\.claude"
    Join-Path $env:USERPROFILE ".claude"
} else {
    Write-Verbose-Custom "Unix-like system detected, using HOME/.claude"
    Join-Path $env:HOME ".claude"
}

Write-Info "Claude home directory: $claudeHome"

# Create skills directory if it doesn't exist
$skillsDestDir = Join-Path $claudeHome "skills"
if (-not (Test-Path $skillsDestDir)) {
    if ($DryRun) {
        Write-DryRun "Would create skills directory: $skillsDestDir"
    } else {
        Write-Info "Creating skills directory: $skillsDestDir"
        Write-Verbose-Custom "Executing: New-Item -ItemType Directory -Path '$skillsDestDir' -Force"
        New-Item -ItemType Directory -Path $skillsDestDir -Force | Out-Null
    }
} else {
    Write-Verbose-Custom "Skills directory already exists: $skillsDestDir"
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

# Track statistics
$installed = 0
$updated = 0
$skipped = 0

# Process each skill
foreach ($skill in $skills) {
    $skillName = $skill.Name
    $sourcePath = $skill.FullName
    $destPath = Join-Path $skillsDestDir $skillName

    Write-Host "──────────────────────────────────────────────────" -ForegroundColor DarkGray
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
    $shouldInstall = $y -or $DryRun
    if (-not $shouldInstall) {
        Write-Host ""
        $action = if ($isUpdate) { "Update" } else { "Install" }
        $response = Read-Host "  $action this skill? [Y/n]"
        # Default to Yes - only skip if user explicitly enters 'n' or 'N'
        $shouldInstall = -not ($response -match '^[Nn]')
    }

    if ($shouldInstall) {
        if ($DryRun) {
            # Dry-run mode - just show what would happen
            if (Test-Path $destPath) {
                Write-DryRun "Would remove old version: $destPath"
            }
            Write-DryRun "Would copy from: $sourcePath"
            Write-DryRun "Would copy to: $destPath"

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
                    $updated++
                } else {
                    Write-Success "  ✓ Installed successfully"
                    $installed++
                }
            } catch {
                Write-Error-Custom "  ✗ Failed: $($_.Exception.Message)"
                Write-Verbose-Custom "Error details: $($_.Exception.ToString())"
            }
        }
    } else {
        Write-Warning-Custom "  ○ Skipped"
        $skipped++
    }

    Write-Host ""
}

# Summary
Write-Host "══════════════════════════════════════════════════" -ForegroundColor DarkGray
if ($DryRun) {
    Write-Host "Summary (DRY RUN):" -ForegroundColor Magenta
    Write-Host "  Would install: $installed" -ForegroundColor Green
    Write-Host "  Would update:  $updated" -ForegroundColor Yellow
    Write-Host "  Would skip:    $skipped" -ForegroundColor Gray
} else {
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "  Installed: $installed" -ForegroundColor Green
    Write-Host "  Updated:   $updated" -ForegroundColor Yellow
    Write-Host "  Skipped:   $skipped" -ForegroundColor Gray
}
Write-Host "══════════════════════════════════════════════════" -ForegroundColor DarkGray

if ($installed -gt 0 -or $updated -gt 0) {
    Write-Host ""
    if ($DryRun) {
        Write-Host "[DRY RUN] Skills would be available in Claude Code!" -ForegroundColor Magenta
        Write-Host "[DRY RUN] Location: $skillsDestDir" -ForegroundColor Magenta
    } else {
        Write-Success "Skills are now available in Claude Code!"
        Write-Info "Location: $skillsDestDir"
    }
}

exit 0

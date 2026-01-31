# Installation Guide

This guide explains how to install Claude Code skills from this repository to your local Claude home directory.

## Quick Start

### Windows (PowerShell)

```powershell
# Clone the repository
git clone https://github.com/vito-russomoliterni-mudbath/ai-agents-resources.git
cd ai-agents-resources

# Install skills (interactive mode)
.\install-skills.ps1

# Or install all skills automatically without prompts
.\install-skills.ps1 -y
```

## Installation Script Features

The `install-skills.ps1` script provides:

### ✓ Smart Updates
- Detects existing skills in `~/.claude/skills/`
- Shows exactly which files will be added, updated, or deleted
- Cleans up old files before installing new versions (prevents orphaned files)

### ✓ Interactive or Automatic
- **Interactive mode** (default): Prompts for confirmation before each skill
- **Automatic mode** (`-y` flag): Installs/updates all skills without prompts

### ✓ Clear Feedback
Shows color-coded status for each file:
- `+` Green = New file to be added
- `~` Yellow = Existing file to be updated
- `-` Red = Old file to be deleted

### ✓ Safe and Reversible
- Creates backups by removing old versions before copying new ones
- Shows summary at the end (installed, updated, skipped)
- Returns proper exit codes for scripting

## Command Reference

### Show Help
```powershell
.\install-skills.ps1 -help
```

### Interactive Installation (Default)
```powershell
.\install-skills.ps1
```

Prompts before each skill:
```
Skill: bug-fix
  Status: New installation
  Files to install:
    + SKILL.md
    + assets\bug-fix-checklist.md
    + references\debugging-strategies.md
    ...

  Install/update this skill? [y/N]:
```

### Automatic Installation
```powershell
.\install-skills.ps1 -y
```

Installs/updates all skills without prompting.

### Dry-Run Mode
```powershell
.\install-skills.ps1 -DryRun
```

Shows what would be installed/updated without making any changes to the filesystem. Perfect for:
- Previewing changes before installation
- Checking which skills need updates
- Verifying the script behavior

Example output:
```
════════════════════════════════════════════════════════
                    DRY RUN MODE
  No changes will be made to the filesystem
════════════════════════════════════════════════════════

Skill: bug-fix
  Status: New installation
  Files to install:
    + SKILL.md
    + assets\bug-fix-checklist.md
    ...
[DRY RUN] Would copy from: ...\skills\bug-fix
[DRY RUN] Would copy to: ...\skills\bug-fix
  [DRY RUN] Would install successfully
```

### Verbose Mode
```powershell
.\install-skills.ps1 -v
```

Shows detailed output including:
- Full source and destination paths
- File sizes for each file
- Size differences for updated files
- Progress messages for all operations

Example output:
```
[VERBOSE] Source: C:\repos\ai-agents-resources\skills\bug-fix
[VERBOSE] Destination: C:\Users\you\.claude\skills\bug-fix
[VERBOSE] Old version has 10 files
[VERBOSE] New version has 11 files
  Files to update:
    ~ SKILL.md
[VERBOSE]       Old: 8104 bytes, New: 8250 bytes (+146 bytes)
```

### Combined Flags
You can combine flags for different behaviors:

```powershell
# Verbose dry-run (see details without making changes)
.\install-skills.ps1 -v -DryRun

# Verbose automatic installation (see details while installing)
.\install-skills.ps1 -v -y

# All flags together (verbose dry-run, auto-confirm)
.\install-skills.ps1 -v -y -DryRun
```

## Installation Locations

The script automatically detects your Claude home directory:

- **Custom location:** `$env:CLAUDE_HOME/skills/` (if `CLAUDE_HOME` environment variable is set)
- **Windows default:** `%USERPROFILE%\.claude\skills\`
- **Linux/macOS default:** `~/.claude/skills/`

## What Gets Installed

Each skill is copied to `~/.claude/skills/{skill-name}/` with the following structure:

```
~/.claude/skills/
├── add-memory/
│   ├── SKILL.md
│   ├── assets/
│   ├── references/
│   └── ...
├── add-unit-tests/
├── agent-md-refactor/
├── bug-fix/
├── new-feature/
└── refactor/
```

## Updating Skills

To update existing skills to the latest version:

1. Pull the latest changes:
   ```powershell
   git pull origin main
   ```

2. Run the install script:
   ```powershell
   .\install-skills.ps1
   ```

The script will:
- Detect which skills have changed
- Show you what will be updated
- Remove old files that no longer exist in the new version
- Copy the new version

## Troubleshooting

### Script Execution Policy Error

If you see an error about execution policy:

```powershell
# Bypass execution policy for this script only
powershell.exe -ExecutionPolicy Bypass -File .\install-skills.ps1
```

### Permission Errors

If you encounter permission errors:
- Make sure you have write access to `~/.claude/skills/`
- Try running PowerShell as Administrator

### Skills Not Showing in Claude Code

After installation:
1. Restart Claude Code CLI
2. Check that files are in `~/.claude/skills/`
3. Verify `SKILL.md` files have proper YAML frontmatter

## Manual Installation

If you prefer to install skills manually:

1. Create the skills directory (if it doesn't exist):
   ```powershell
   mkdir ~\.claude\skills
   ```

2. Copy individual skill directories:
   ```powershell
   cp -r skills\bug-fix ~\.claude\skills\
   cp -r skills\new-feature ~\.claude\skills\
   # etc.
   ```

## Uninstalling Skills

To remove a skill:

```powershell
Remove-Item -Recurse -Force ~\.claude\skills\{skill-name}
```

Or remove all skills:

```powershell
Remove-Item -Recurse -Force ~\.claude\skills\*
```

## Support

For issues with the installation script:
- Check the [README.md](README.md) for general information
- Report issues at: https://github.com/vito-russomoliterni-mudbath/ai-agents-resources/issues

# Changelog

## [1.3.0] - 2026-01-31

### Enhanced
- **building-skills skill (v1.3.0)** - Added comprehensive gerund naming validation:
  - New workflow step to validate skill names follow gerund form (verb + -ing)
  - Prompts user with 3-4 gerund alternatives when name doesn't conform
  - Detailed "Skill Name Validation Process" section with examples
  - Common name conversion patterns table (e.g., `bug-fix` → `fixing-bugs`)
  - Clear guidance on valid vs invalid naming patterns

## [1.2.0] - 2026-01-31

### Added
- **New skill: building-skills** - Converts AI assistant workflows from various tools (Claude Code, Cursor, Windsurf, Aider) into properly formatted Claude skills following the Agent Skills specification.

### Changed
- **Skill names renamed to gerund form** - Following Claude skill best practices:
  - `add-memory` → `adding-memory`
  - `add-unit-tests` → `adding-tests`
  - `agent-md-refactor` → `refactoring-agent-instructions`
  - `bug-fix` → `fixing-bugs`
  - `new-feature` → `building-features`
  - `refactor` → `refactoring-code`
  - `ai-workflow-to-skill` → `building-skills`

- **Installation script behavior** - Changed default prompt from `[y/N]` to `[Y/n]`:
  - Pressing Enter now defaults to YES (install/update)
  - Only typing `n` or `N` explicitly skips the skill
  - More user-friendly for bulk installations

### Fixed
- Corrected PowerShell parameter syntax from `--DryRun` to `-DryRun` throughout documentation
- Updated all skill references in README.md, CLAUDE.md, and documentation files

## [1.1.0] - 2026-01-31

### Added
- **Verbose mode** (`-v` flag) - Shows detailed output including:
  - Full source and destination paths
  - File sizes for each file
  - Size differences for updated files (e.g., "+146 bytes" or "-50 bytes")
  - Progress messages for all operations
  - Environment detection details

- **Dry-run mode** (`-DryRun` flag) - Preview mode that:
  - Shows what would be installed/updated without making changes
  - Displays clear "DRY RUN MODE" header
  - Prefixes all operations with "[DRY RUN]"
  - Shows summary with "Would install" counts
  - Perfect for testing and verification

### Features
- Flags can be combined (e.g., `-v -y -DryRun`)
- Both flags work with interactive and automatic modes
- Verbose output shows file count comparisons
- Dry-run mode automatically skips confirmation prompts
- Color-coded verbose messages (dark gray) and dry-run messages (magenta)

### Examples

#### Verbose Dry-Run
```powershell
.\install-skills.ps1 -v -DryRun
```
Shows detailed preview without making changes.

#### Verbose Automatic Installation
```powershell
.\install-skills.ps1 -v -y
```
Installs all skills with detailed progress output.

#### Standard Dry-Run
```powershell
.\install-skills.ps1 -DryRun
```
Quick preview of what would be installed.

## [1.0.0] - 2026-01-31

### Initial Release
- Interactive installation with confirmation prompts
- Automatic installation mode (`-y` flag)
- Smart update detection (shows add/update/delete files)
- Claude home directory auto-detection
- Color-coded file operation display
- Clean removal of old versions before updating
- Comprehensive error handling
- Help documentation (`-help`)
- Invalid parameter detection

# Scripting Patterns Reference

Best practices and common patterns for automation scripts.

## Table of Contents
- [PowerShell 5.1 Best Practices](#powershell-51-best-practices)
- [Bash Best Practices](#bash-best-practices)
- [Common Automation Patterns](#common-automation-patterns)
- [Cross-Platform Patterns](#cross-platform-patterns-when-requested)

---

## PowerShell 5.1 Best Practices

### Script Structure

```powershell
# 1. Comment-based help (top of script)
<#
.SYNOPSIS
.DESCRIPTION
.PARAMETER
.EXAMPLE
#>

# 2. CmdletBinding and parameters
[CmdletBinding()]
param(...)

# 3. Error preferences
$ErrorActionPreference = 'Stop'

# 4. Helper functions
function Write-Log { ... }

# 5. Main logic
try {
    # Script logic
}
catch {
    # Error handling
    exit 1
}
```

### Parameter Validation

```powershell
[CmdletBinding()]
param(
    # Mandatory with help message
    [Parameter(Mandatory = $true, HelpMessage = "Enter the input path")]
    [string]$InputPath,

    # Validate file exists
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$FilePath,

    # Validate directory exists
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$DirectoryPath,

    # Validate from set of values
    [ValidateSet('Development', 'Staging', 'Production')]
    [string]$Environment = 'Development',

    # Validate range
    [ValidateRange(1, 100)]
    [int]$RetryCount = 3,

    # Validate not null or empty
    [ValidateNotNullOrEmpty()]
    [string]$Name,

    # Validate pattern (regex)
    [ValidatePattern('^[a-zA-Z0-9]+$')]
    [string]$Identifier
)
```

### Error Handling

```powershell
# Global error preference
$ErrorActionPreference = 'Stop'

# Try-catch with specific handling
try {
    # Risky operation
    $result = Get-Content -Path $filePath
}
catch [System.IO.FileNotFoundException] {
    Write-Error "File not found: $filePath"
    exit 1
}
catch [System.UnauthorizedAccessException] {
    Write-Error "Access denied: $filePath"
    exit 2
}
catch {
    Write-Error "Unexpected error: $($_.Exception.Message)"
    exit 99
}
finally {
    # Cleanup (always runs)
}
```

### Output Streams

```powershell
# Standard output (return values, pipeline)
Write-Output "This goes to pipeline/output"

# Information to user (not in pipeline)
Write-Host "User message" -ForegroundColor Green

# Verbose (with -Verbose flag)
Write-Verbose "Detailed information"

# Debug (with -Debug flag)
Write-Debug "Debug info"

# Warning
Write-Warning "Warning message"

# Error
Write-Error "Error message"
```

### Exit Codes

```powershell
# Success
exit 0

# General error
exit 1

# Specific error codes
exit 2  # Invalid arguments
exit 3  # File not found
exit 4  # Permission denied

# Use $LASTEXITCODE to check external command results
& external-command.exe
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
```

---

## Bash Best Practices

### Script Structure

```bash
#!/usr/bin/env bash
#
# Script description header
#

# Strict mode
set -euo pipefail

# Constants/defaults
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Functions
usage() { ... }
log() { ... }
main() { ... }

# Entry point
main "$@"
```

### Set Options Explained

```bash
# Recommended combination
set -euo pipefail

# Individual options:
set -e          # Exit on error
set -u          # Error on undefined variables
set -o pipefail # Fail pipe on any command failure

# Debug mode (verbose)
set -x          # Print commands as executed

# Disable options when needed
set +e          # Temporarily allow errors
command_that_might_fail
set -e          # Re-enable
```

### Variable Best Practices

```bash
# Always quote variables
echo "$variable"
cp "$source" "$destination"

# Default values
name="${NAME:-default_name}"
count="${COUNT:-0}"

# Required variables (error if unset)
: "${REQUIRED_VAR:?Error: REQUIRED_VAR is not set}"

# Readonly constants
readonly MAX_RETRIES=3
readonly CONFIG_FILE="/etc/app/config"

# Local variables in functions
my_function() {
    local result=""
    local -r constant="value"  # local readonly
    # ...
}
```

### Conditionals

```bash
# Use [[ ]] for conditionals (bash-specific, safer)
if [[ -f "$file" ]]; then
    echo "File exists"
fi

# String comparisons
if [[ "$string" == "value" ]]; then ...
if [[ "$string" != "value" ]]; then ...
if [[ "$string" =~ ^pattern.* ]]; then ...  # regex
if [[ -z "$string" ]]; then ...  # empty
if [[ -n "$string" ]]; then ...  # not empty

# Numeric comparisons
if [[ "$num" -eq 0 ]]; then ...
if [[ "$num" -lt 10 ]]; then ...
if [[ "$num" -gt 5 ]]; then ...

# File tests
if [[ -f "$path" ]]; then ...  # regular file
if [[ -d "$path" ]]; then ...  # directory
if [[ -e "$path" ]]; then ...  # exists
if [[ -r "$path" ]]; then ...  # readable
if [[ -w "$path" ]]; then ...  # writable
if [[ -x "$path" ]]; then ...  # executable
```

### Exit Codes

```bash
# Exit codes
exit 0   # Success
exit 1   # General error
exit 2   # Misuse of shell command
exit 126 # Command not executable
exit 127 # Command not found
exit 128 # Invalid exit argument

# Check last command's exit code
if [[ $? -ne 0 ]]; then
    echo "Command failed"
fi

# Or use && and ||
command && echo "Success" || echo "Failed"
```

---

## Common Automation Patterns

### File Processing

**PowerShell:**
```powershell
# Process all files in directory
Get-ChildItem -Path $InputDir -Filter "*.txt" | ForEach-Object {
    Write-Verbose "Processing: $($_.Name)"
    $content = Get-Content -Path $_.FullName
    # Process content...
}

# Recursive with filter
Get-ChildItem -Path $InputDir -Filter "*.log" -Recurse | Where-Object {
    $_.LastWriteTime -gt (Get-Date).AddDays(-7)
}
```

**Bash:**
```bash
# Process all files in directory
for file in "$input_dir"/*.txt; do
    [[ -f "$file" ]] || continue  # Skip if no matches
    echo "Processing: $(basename "$file")"
    # Process file...
done

# Recursive with find
find "$input_dir" -name "*.log" -mtime -7 | while read -r file; do
    echo "Processing: $file"
done
```

### Logging

**PowerShell:**
```powershell
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] [$Level] $Message"

    # To file
    Add-Content -Path $LogFile -Value $logLine

    # To console with color
    switch ($Level) {
        "ERROR"   { Write-Host $logLine -ForegroundColor Red }
        "WARNING" { Write-Host $logLine -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logLine -ForegroundColor Green }
        default   { Write-Host $logLine }
    }
}
```

**Bash:**
```bash
log() {
    local level="${1:-INFO}"
    local message="${2:-}"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # To file and console
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Usage
log "INFO" "Starting process"
log "ERROR" "Something failed"
```

### Configuration Files

**PowerShell:**
```powershell
# JSON config
$config = Get-Content -Path "config.json" -Raw | ConvertFrom-Json
$serverUrl = $config.server.url

# INI-style (simple key=value)
$config = @{}
Get-Content "config.ini" | ForEach-Object {
    if ($_ -match '^([^=]+)=(.*)$') {
        $config[$Matches[1].Trim()] = $Matches[2].Trim()
    }
}
```

**Bash:**
```bash
# Source a config file (key=value format)
if [[ -f "config.sh" ]]; then
    source "config.sh"
fi

# Parse INI-style
while IFS='=' read -r key value; do
    [[ "$key" =~ ^#.*$ ]] && continue  # Skip comments
    [[ -z "$key" ]] && continue         # Skip empty lines
    declare "$key=$value"
done < "config.ini"
```

### Retry Logic

**PowerShell:**
```powershell
function Invoke-WithRetry {
    param(
        [scriptblock]$ScriptBlock,
        [int]$MaxRetries = 3,
        [int]$DelaySeconds = 2
    )

    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            return & $ScriptBlock
        }
        catch {
            if ($i -eq $MaxRetries) { throw }
            Write-Warning "Attempt $i failed, retrying in $DelaySeconds seconds..."
            Start-Sleep -Seconds $DelaySeconds
        }
    }
}

# Usage
Invoke-WithRetry -ScriptBlock { Invoke-WebRequest -Uri $url }
```

**Bash:**
```bash
retry() {
    local max_attempts="${1:-3}"
    local delay="${2:-2}"
    shift 2
    local cmd=("$@")

    for ((i = 1; i <= max_attempts; i++)); do
        if "${cmd[@]}"; then
            return 0
        fi
        echo "Attempt $i failed, retrying in $delay seconds..." >&2
        sleep "$delay"
    done

    echo "Command failed after $max_attempts attempts" >&2
    return 1
}

# Usage
retry 3 2 curl -f "$url"
```

---

## Cross-Platform Patterns (When Requested)

Use these patterns only when the user explicitly requests cross-platform support.

### Path Handling (PowerShell 7+)

```powershell
# Cross-platform path joining
$fullPath = Join-Path -Path $baseDir -ChildPath "subdir" -AdditionalChildPath "file.txt"

# Get separator for current OS
$separator = [IO.Path]::DirectorySeparatorChar

# Normalize paths
$normalized = [IO.Path]::GetFullPath($path)

# Temp directory (cross-platform)
$tempDir = [IO.Path]::GetTempPath()
```

### Environment Variables (PowerShell 7+)

```powershell
# Cross-platform user info
$userName = [Environment]::UserName
$homeDir = [Environment]::GetFolderPath('UserProfile')

# Cross-platform temp
$tempDir = [IO.Path]::GetTempPath()

# Check platform
if ($IsWindows) { ... }
elseif ($IsLinux) { ... }
elseif ($IsMacOS) { ... }
```

### Command Equivalents

| Operation | PowerShell | Bash |
|-----------|------------|------|
| List files | `Get-ChildItem` | `ls` |
| Copy file | `Copy-Item` | `cp` |
| Move file | `Move-Item` | `mv` |
| Delete file | `Remove-Item` | `rm` |
| Create directory | `New-Item -ItemType Directory` | `mkdir -p` |
| Read file | `Get-Content` | `cat` |
| Write file | `Set-Content` | `echo >` |
| Find text | `Select-String` | `grep` |
| Current directory | `Get-Location` | `pwd` |
| Environment var | `$env:VAR` | `$VAR` |

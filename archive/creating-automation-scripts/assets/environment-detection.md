# Environment Detection

Code snippets for detecting the current shell environment.

## PowerShell Detection

### Check if Running in PowerShell

```powershell
# PowerShell version information
$PSVersionTable.PSVersion

# Returns Major.Minor.Build.Revision
# PowerShell 5.1: 5.1.x.x
# PowerShell 7+: 7.x.x.x
```

### Check Operating System (PowerShell 5.1)

```powershell
# In PowerShell 5.1 on Windows, these variables don't exist
# So we create them for compatibility
if (-not (Test-Path variable:IsWindows)) {
    $IsWindows = $true
    $IsLinux = $false
    $IsMacOS = $false
}

# Now use them
if ($IsWindows) {
    Write-Host "Running on Windows"
} elseif ($IsLinux) {
    Write-Host "Running on Linux"
} elseif ($IsMacOS) {
    Write-Host "Running on macOS"
}
```

### Check Operating System (Alternative)

```powershell
# Using .NET for cross-version compatibility
$os = [System.Environment]::OSVersion.Platform
switch ($os) {
    'Win32NT' { Write-Host "Windows" }
    'Unix'    { Write-Host "Linux or macOS" }
}

# More detailed on Windows
[System.Environment]::OSVersion.VersionString
```

## Bash Detection

### Check Shell Type

```bash
# Current shell from environment
echo "SHELL: $SHELL"

# Actual running shell
echo "Running as: $0"

# Bash version
echo "Bash version: $BASH_VERSION"
```

### Check Operating System

```bash
# Using uname
OS=$(uname -s)
case "$OS" in
    Linux*)     echo "Linux";;
    Darwin*)    echo "macOS";;
    CYGWIN*)    echo "Cygwin on Windows";;
    MINGW*)     echo "MinGW on Windows";;
    MSYS*)      echo "MSYS on Windows";;
    *)          echo "Unknown: $OS";;
esac
```

### Alternative: Using $OSTYPE

```bash
# Bash built-in variable
case "$OSTYPE" in
    linux*)     echo "Linux";;
    darwin*)    echo "macOS";;
    cygwin*)    echo "Cygwin";;
    msys*)      echo "MSYS/Git Bash";;
    win32*)     echo "Windows";;
    freebsd*)   echo "FreeBSD";;
    *)          echo "Unknown: $OSTYPE";;
esac
```

## Cross-Environment Detection

### Check if Command Exists

**Bash:**
```bash
# Check if a command is available
if command -v pwsh &> /dev/null; then
    echo "PowerShell 7+ is available"
elif command -v powershell &> /dev/null; then
    echo "Windows PowerShell is available"
fi

if command -v bash &> /dev/null; then
    echo "Bash is available"
fi
```

**PowerShell:**
```powershell
# Check if a command is available
if (Get-Command bash -ErrorAction SilentlyContinue) {
    Write-Host "Bash is available"
}

if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Write-Host "PowerShell 7+ is available"
}
```

## Decision Logic for Prompting User

Use this logic to decide when to prompt:

```
1. Detect current environment
2. If detection succeeds:
   - Note detected environment
   - Ask user: "I detected [environment]. Is this the target for your script?"
3. If detection fails or is ambiguous:
   - Prompt user to choose target environment
4. If user needs cross-platform:
   - Discuss options (PowerShell 7+, dual scripts)
```

### Sample AskUserQuestion Options

When prompting the user, offer these choices:

1. **PowerShell 5.1** - Native Windows scripting, pre-installed on Windows 10/11
2. **Bash** - Native Linux/macOS, also available on Windows via WSL or Git Bash
3. **PowerShell 7+** - Cross-platform PowerShell (requires installation)
4. **Both formats** - Generate .sh and .ps1 versions

## Environment Variables Reference

### PowerShell Environment Info

```powershell
# User information
[Environment]::UserName           # Current user
[Environment]::MachineName        # Computer name
[Environment]::UserDomainName     # Domain (Windows)

# Paths
[IO.Path]::GetTempPath()          # Temp directory
[Environment]::CurrentDirectory   # Current directory
$HOME                             # User home directory
$PSScriptRoot                     # Script's directory

# System info
[Environment]::Is64BitOperatingSystem
[Environment]::ProcessorCount
```

### Bash Environment Info

```bash
# User information
$USER                # Current user
$HOSTNAME            # Computer name
whoami               # Alternative for user

# Paths
$TMPDIR              # Temp directory (macOS)
/tmp                 # Temp directory (Linux)
$PWD                 # Current directory
$HOME                # User home directory
$(dirname "$0")      # Script's directory

# System info
uname -m             # Architecture (x86_64, arm64)
nproc                # Processor count (Linux)
sysctl -n hw.ncpu    # Processor count (macOS)
```

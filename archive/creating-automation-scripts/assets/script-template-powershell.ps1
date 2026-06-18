<#
.SYNOPSIS
    Brief one-line description of the script.

.DESCRIPTION
    Detailed description of what the script does, including any important
    notes about its behavior, prerequisites, or side effects.

.PARAMETER InputPath
    Description of the InputPath parameter.

.PARAMETER OutputPath
    Description of the OutputPath parameter. Optional.

.PARAMETER Verbose
    Enable verbose output (built-in with CmdletBinding).

.PARAMETER WhatIf
    Show what would be done without making changes (built-in with SupportsShouldProcess).

.EXAMPLE
    .\script-name.ps1 -InputPath "C:\data\input.txt"

    Description of what this example does.

.EXAMPLE
    .\script-name.ps1 -InputPath "C:\data\input.txt" -OutputPath "C:\data\output.txt" -Verbose

    Description of this more complex example.

.NOTES
    Author: Your Name
    Date: YYYY-MM-DD
    Version: 1.0.0
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Path to the input file")]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$InputPath,

    [Parameter(Mandatory = $false, HelpMessage = "Path to the output file")]
    [string]$OutputPath,

    [Parameter(Mandatory = $false, HelpMessage = "Enable dry run mode")]
    [switch]$DryRun
)

# Stop on errors
$ErrorActionPreference = 'Stop'

# Script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

#region Helper Functions

function Write-Log {
    <#
    .SYNOPSIS
        Write a timestamped log message.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Warning', 'Error', 'Verbose')]
        [string]$Level = 'Info'
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    switch ($Level) {
        'Info'    { Write-Host $logMessage }
        'Warning' { Write-Warning $Message }
        'Error'   { Write-Error $Message }
        'Verbose' { Write-Verbose $logMessage }
    }
}

function Test-Prerequisites {
    <#
    .SYNOPSIS
        Check if required commands/modules are available.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Commands
    )

    $missing = @()
    foreach ($cmd in $Commands) {
        if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
            $missing += $cmd
        }
    }

    if ($missing.Count -gt 0) {
        throw "Missing required commands: $($missing -join ', ')"
    }

    Write-Verbose "All prerequisites met"
}

function Invoke-WithRetry {
    <#
    .SYNOPSIS
        Execute a script block with retry logic.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock,

        [Parameter(Mandatory = $false)]
        [int]$MaxRetries = 3,

        [Parameter(Mandatory = $false)]
        [int]$RetryDelaySeconds = 2
    )

    $attempt = 0
    $lastError = $null

    while ($attempt -lt $MaxRetries) {
        $attempt++
        try {
            return & $ScriptBlock
        }
        catch {
            $lastError = $_
            Write-Log -Message "Attempt $attempt failed: $($_.Exception.Message)" -Level Warning
            if ($attempt -lt $MaxRetries) {
                Start-Sleep -Seconds $RetryDelaySeconds
            }
        }
    }

    throw "Operation failed after $MaxRetries attempts. Last error: $($lastError.Exception.Message)"
}

#endregion

#region Main Logic

function Invoke-MainLogic {
    <#
    .SYNOPSIS
        Main script logic.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [string]$Input,
        [string]$Output,
        [bool]$IsDryRun
    )

    Write-Log -Message "Starting script..."
    Write-Log -Message "Input: $Input" -Level Verbose
    Write-Log -Message "Output: $Output" -Level Verbose

    # Check prerequisites (add any required commands)
    # Test-Prerequisites -Commands @('git', 'dotnet')

    # Validate input
    if (-not (Test-Path $Input)) {
        throw "Input file not found: $Input"
    }

    # Main logic goes here
    if ($IsDryRun -or $WhatIfPreference) {
        Write-Log -Message "DRY RUN: Would process $Input"
    }
    else {
        if ($PSCmdlet.ShouldProcess($Input, "Process file")) {
            Write-Log -Message "Processing $Input..."
            # TODO: Add your processing logic here

            # Example: Read and process file
            # $content = Get-Content -Path $Input
            # Process content...

            # Example: Write output
            # if ($Output) {
            #     $content | Set-Content -Path $Output
            # }
        }
    }

    Write-Log -Message "Script completed successfully"
}

#endregion

#region Script Entry Point

try {
    # Set output path default if not specified
    if (-not $OutputPath) {
        $OutputPath = [System.IO.Path]::ChangeExtension($InputPath, ".output.txt")
        Write-Verbose "Output path defaulted to: $OutputPath"
    }

    # Run main logic
    Invoke-MainLogic -Input $InputPath -Output $OutputPath -IsDryRun $DryRun

    exit 0
}
catch {
    Write-Log -Message $_.Exception.Message -Level Error
    Write-Log -Message $_.ScriptStackTrace -Level Verbose
    exit 1
}

#endregion

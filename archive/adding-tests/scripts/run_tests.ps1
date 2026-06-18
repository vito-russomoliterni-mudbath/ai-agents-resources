# PowerShell script to detect and run tests for various frameworks
# Usage: .\run_tests.ps1 [project_path]

param(
    [string]$ProjectPath = ".",
    [switch]$Coverage,
    [switch]$Verbose
)

Set-Location $ProjectPath

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Test-FileExists {
    param([string[]]$Files)
    foreach ($file in $Files) {
        if (Test-Path $file) {
            return $true
        }
    }
    return $false
}

function Invoke-PythonTests {
    Write-ColorOutput "Detected Python project" "Cyan"

    # Check for pytest
    if (Test-FileExists @("pytest.ini", "pyproject.toml", "setup.cfg")) {
        Write-ColorOutput "Running pytest..." "Green"
        if ($Coverage) {
            pytest --cov --cov-report=term-missing
        } elseif ($Verbose) {
            pytest -v
        } else {
            pytest
        }
        return $LASTEXITCODE
    }

    # Fall back to unittest
    Write-ColorOutput "Running unittest..." "Green"
    python -m unittest discover
    return $LASTEXITCODE
}

function Invoke-JavaScriptTests {
    Write-ColorOutput "Detected JavaScript/TypeScript project" "Cyan"

    # Check for vitest
    if (Test-FileExists @("vitest.config.ts", "vitest.config.js", "vite.config.ts")) {
        Write-ColorOutput "Running vitest..." "Green"
        if ($Coverage) {
            if (Test-Path "node_modules\.bin\vitest") {
                npx vitest run --coverage
            } elseif (Get-Command bun -ErrorAction SilentlyContinue) {
                bun test --coverage
            } else {
                npm test -- --coverage
            }
        } else {
            if (Test-Path "node_modules\.bin\vitest") {
                npx vitest run
            } elseif (Get-Command bun -ErrorAction SilentlyContinue) {
                bun test
            } else {
                npm test
            }
        }
        return $LASTEXITCODE
    }

    # Check for jest
    if (Test-FileExists @("jest.config.js", "jest.config.ts", "jest.config.json")) {
        Write-ColorOutput "Running jest..." "Green"
        if ($Coverage) {
            npm test -- --coverage
        } else {
            npm test
        }
        return $LASTEXITCODE
    }

    # Default to npm test
    Write-ColorOutput "Running npm test..." "Green"
    npm test
    return $LASTEXITCODE
}

function Invoke-DotNetTests {
    Write-ColorOutput "Detected .NET project" "Cyan"

    Write-ColorOutput "Running dotnet test..." "Green"
    if ($Coverage) {
        dotnet test --collect:"XPlat Code Coverage"
    } elseif ($Verbose) {
        dotnet test --verbosity normal
    } else {
        dotnet test
    }
    return $LASTEXITCODE
}

function Invoke-JavaTests {
    Write-ColorOutput "Detected Java project" "Cyan"

    # Check for Maven
    if (Test-Path "pom.xml") {
        Write-ColorOutput "Running Maven tests..." "Green"
        mvn test
        return $LASTEXITCODE
    }

    # Check for Gradle
    if (Test-FileExists @("build.gradle", "build.gradle.kts")) {
        Write-ColorOutput "Running Gradle tests..." "Green"
        if (Test-Path "gradlew.bat") {
            .\gradlew.bat test
        } elseif (Test-Path "gradlew") {
            .\gradlew test
        } else {
            gradle test
        }
        return $LASTEXITCODE
    }

    Write-ColorOutput "Could not determine Java build tool" "Red"
    return 1
}

function Invoke-GoTests {
    Write-ColorOutput "Detected Go project" "Cyan"

    Write-ColorOutput "Running go test..." "Green"
    if ($Coverage) {
        go test -cover ./...
    } elseif ($Verbose) {
        go test -v ./...
    } else {
        go test ./...
    }
    return $LASTEXITCODE
}

# Main detection logic
Write-ColorOutput "Detecting test framework..." "Yellow"

# Python
if (Test-FileExists @("pytest.ini", "setup.py", "pyproject.toml", "requirements.txt")) {
    $exitCode = Invoke-PythonTests
}
# JavaScript/TypeScript
elseif (Test-FileExists @("package.json")) {
    $exitCode = Invoke-JavaScriptTests
}
# .NET
elseif ((Get-ChildItem -Filter "*.csproj" -Recurse).Count -gt 0) {
    $exitCode = Invoke-DotNetTests
}
# Java
elseif (Test-FileExists @("pom.xml", "build.gradle", "build.gradle.kts")) {
    $exitCode = Invoke-JavaTests
}
# Go
elseif (Test-FileExists @("go.mod")) {
    $exitCode = Invoke-GoTests
}
else {
    Write-ColorOutput "Could not detect test framework" "Red"
    $exitCode = 1
}

# Report results
Write-Host ""
if ($exitCode -eq 0) {
    Write-ColorOutput "✓ All tests passed" "Green"
} else {
    Write-ColorOutput "✗ Tests failed with exit code: $exitCode" "Red"
}

exit $exitCode

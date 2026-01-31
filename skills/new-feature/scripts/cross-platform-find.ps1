# Cross-platform file finding examples
# This script demonstrates PowerShell equivalents for common file operations

Write-Host "=== Cross-Platform Find Examples (PowerShell) ===" -ForegroundColor Blue
Write-Host ""

# Example 1: Find files by extension
Write-Host "1. Finding TypeScript files:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -Filter "*.ts" -File'
Write-Host ""

# Example 2: Find files matching multiple patterns
Write-Host "2. Finding component files:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -Include "*Component*.tsx","*Component*.jsx" -File'
Write-Host ""

# Example 3: Find files excluding directories
Write-Host "3. Finding Python files (excluding venv):" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -Filter "*.py" -File | Where-Object { $_.FullName -notmatch "venv|\.venv" }'
Write-Host ""

# Example 4: Find files by path pattern
Write-Host "4. Finding API route files:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -File | Where-Object { $_.FullName -match "routes|controllers|api" }'
Write-Host ""

# Example 5: Find files modified recently
Write-Host "5. Finding recently modified files:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -File | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-7) }'
Write-Host ""

# Example 6: Count files by type
Write-Host "6. Counting files by extension:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -File | Group-Object Extension | Sort-Object Count -Descending'
Write-Host ""

# Example 7: Find largest files
Write-Host "7. Finding largest files:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -File | Sort-Object Length -Descending | Select-Object -First 10 Name,Length'
Write-Host ""

# Example 8: Find empty files
Write-Host "8. Finding empty files:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -File | Where-Object { $_.Length -eq 0 }'
Write-Host ""

# Example 9: Search file content (like grep)
Write-Host "9. Searching file content:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -Include "*.ts","*.tsx" -File | Select-String "pattern"'
Write-Host ""

# Example 10: Find files and display paths
Write-Host "10. Finding files with full paths:" -ForegroundColor Green
Write-Host 'Get-ChildItem -Recurse -Filter "*.config.*" -File | Select-Object FullName'
Write-Host ""

# Cross-platform note
Write-Host ""
Write-Host "Note: In Claude Code, prefer using:" -ForegroundColor Blue
Write-Host "  - Glob tool for file pattern matching (cross-platform)"
Write-Host "  - Grep tool for content searching (cross-platform)"
Write-Host "  - Read tool for file examination"
Write-Host "  - Bash tool for Unix-like environments"
Write-Host "  - These PowerShell examples work on Windows, macOS, and Linux (with PowerShell Core)"

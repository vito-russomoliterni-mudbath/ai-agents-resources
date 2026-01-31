#!/bin/bash
# find-duplication.sh - Search for duplicated code patterns
# Usage: ./find-duplication.sh [path] [language]
# Example: ./find-duplication.sh src python
# Example: ./find-duplication.sh . typescript

PATH_TO_SCAN="${1:-.}"
LANGUAGE="${2:-}"

echo "Scanning for duplicated code in $PATH_TO_SCAN..."
echo ""

if [ -z "$LANGUAGE" ] || [ "$LANGUAGE" = "python" ]; then
    echo "=== Python: Looking for similar function patterns ==="
    find "$PATH_TO_SCAN" -name "*.py" -type f -exec grep -l "def " {} \; | head -20
    echo ""
    echo "Common duplication patterns to check manually:"
    echo "- Similar try/except blocks"
    echo "- Repeated validation code"
    echo "- Similar loop structures"
    echo "- Duplicated class methods"
fi

if [ -z "$LANGUAGE" ] || [ "$LANGUAGE" = "typescript" ] || [ "$LANGUAGE" = "javascript" ] || [ "$LANGUAGE" = "js" ]; then
    echo "=== TypeScript/JavaScript: Looking for similar patterns ==="
    find "$PATH_TO_SCAN" \( -name "*.ts" -o -name "*.js" -o -name "*.tsx" -o -name "*.jsx" \) -type f -exec grep -l "const.*=.*(" {} \; | head -20
    echo ""
    echo "Common duplication patterns to check manually:"
    echo "- Similar useState/useEffect in multiple components"
    echo "- Duplicated error handling"
    echo "- Similar fetch/API call patterns"
    echo "- Repeated validation logic"
fi

echo ""
echo "=== Manual Review Steps ==="
echo "1. Search codebase for suspicious patterns:"
echo "   grep -r 'pattern' $PATH_TO_SCAN --include='*.py' --include='*.ts' --include='*.js'"
echo ""
echo "2. Use IDE's 'Find Duplicates' feature (most IDEs have built-in)"
echo ""
echo "3. Tools to consider:"
echo "   - Python: pylint, radon, or jscpd"
echo "   - JavaScript/TypeScript: jscpd, ESLint"
echo "   - General: jscpd (works across languages)"
echo ""
echo "4. Common duplication sources:"
echo "   - Validation code (check email, phone, etc.)"
echo "   - Error handling and logging"
echo "   - Configuration loading"
echo "   - Data transformation"
echo "   - Permission checking"

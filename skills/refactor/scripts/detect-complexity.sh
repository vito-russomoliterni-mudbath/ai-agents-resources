#!/bin/bash
# detect-complexity.sh - Find complex functions that might benefit from refactoring
# Usage: ./detect-complexity.sh [path] [language]
# Example: ./detect-complexity.sh src python
# Example: ./detect-complexity.sh . typescript

PATH_TO_SCAN="${1:-.}"
LANGUAGE="${2:-}"

echo "Scanning for complex functions in $PATH_TO_SCAN..."
echo ""

if [ -z "$LANGUAGE" ] || [ "$LANGUAGE" = "python" ]; then
    echo "=== Python Functions > 30 lines ==="
    find "$PATH_TO_SCAN" -name "*.py" -type f | while read file; do
        awk '
            /^def / {
                if (NR > 1 && func_lines > 30) {
                    print FILENAME ":" start_line ": " func_name " (" func_lines " lines)"
                }
                func_name = $0
                start_line = NR
                func_lines = 1
                in_func = 1
            }
            in_func && /^[^ \t]/ && !/^def / {
                in_func = 0
                if (func_lines > 30) {
                    print FILENAME ":" start_line ": " func_name " (" func_lines " lines)"
                }
            }
            in_func { func_lines++ }
        ' "$file"
    done
fi

if [ -z "$LANGUAGE" ] || [ "$LANGUAGE" = "typescript" ] || [ "$LANGUAGE" = "javascript" ] || [ "$LANGUAGE" = "js" ] || [ "$LANGUAGE" = "ts" ]; then
    echo ""
    echo "=== TypeScript/JavaScript Functions > 30 lines ==="
    find "$PATH_TO_SCAN" -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | while read file; do
        wc -l "$file" | awk '$1 > 300 { print $2 " (" $1 " lines total)"}'
    done
fi

echo ""
echo "=== Methods/Functions with High Cyclomatic Complexity ==="
echo "(Use specialized complexity tools like Radon, Plato, or ESLint for precise metrics)"
echo ""
echo "Recommendations for refactoring candidates:"
echo "- Extract methods: Functions > 50 lines"
echo "- Break down logic: > 3 levels of nesting"
echo "- Reduce parameters: > 3-4 parameters"
echo "- Simplify conditionals: > 2 consecutive if/else chains"

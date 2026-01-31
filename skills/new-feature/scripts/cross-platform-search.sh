#!/usr/bin/env bash
# Cross-platform search examples
# This script demonstrates common search patterns for feature development

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Cross-Platform Search Examples ===${NC}\n"

# Example 1: Find similar components
echo -e "${GREEN}1. Finding similar React components:${NC}"
echo "find . -name '*Component*.tsx' -o -name '*Component*.jsx'"
echo "grep -r \"export.*Component\" src/components/"
echo ""

# Example 2: Find API endpoints
echo -e "${GREEN}2. Finding API endpoints:${NC}"
echo "find . -path '*/routes/*' -o -path '*/controllers/*' -o -path '*/api/*'"
echo "grep -r \"app\\.get\\|app\\.post\\|@Get\\|@Post\" src/"
echo ""

# Example 3: Find database models
echo -e "${GREEN}3. Finding database models:${NC}"
echo "find . -name '*model*.py' -o -name '*Model*.cs' -o -name '*model*.ts'"
echo "grep -r \"class.*Model\\|@Entity\\|sequelize\\.define\" src/"
echo ""

# Example 4: Find configuration files
echo -e "${GREEN}4. Finding configuration files:${NC}"
echo "find . -name '*.config.*' -o -name '*rc' -o -name '*.yaml' -o -name '*.yml'"
echo "ls .env* *.json *.toml 2>/dev/null"
echo ""

# Example 5: Find test files
echo -e "${GREEN}5. Finding test files:${NC}"
echo "find . -name '*.test.*' -o -name '*.spec.*' -o -name 'test_*.py'"
echo "grep -r \"describe\\(\\|it\\(\\|def test_\" tests/ spec/"
echo ""

# Example 6: Search for specific patterns
echo -e "${GREEN}6. Searching for authentication code:${NC}"
echo "grep -r \"auth\\|login\\|token\" src/ | grep -v node_modules"
echo "grep -rn \"@RequireAuth\\|@Authorized\\|login_required\" src/"
echo ""

# Example 7: Find imports/dependencies
echo -e "${GREEN}7. Finding where a module is imported:${NC}"
echo "grep -r \"import.*ModuleName\\|from.*ModuleName\" src/"
echo "grep -r \"require('module-name')\\|import 'module-name'\" src/"
echo ""

# Example 8: Search with context
echo -e "${GREEN}8. Search with surrounding lines (context):${NC}"
echo "grep -rn -C 3 \"function name\" src/  # 3 lines before and after"
echo "grep -rn -A 5 \"class Definition\" src/  # 5 lines after"
echo "grep -rn -B 2 \"error\" src/  # 2 lines before"
echo ""

# Example 9: Count occurrences
echo -e "${GREEN}9. Count pattern occurrences:${NC}"
echo "grep -rc \"TODO\" src/ | grep -v \":0$\"  # Non-zero counts only"
echo "grep -r \"console.log\" src/ | wc -l  # Total count"
echo ""

# Example 10: Find files modified recently
echo -e "${GREEN}10. Find recently modified files:${NC}"
echo "find . -name '*.ts' -mtime -7  # Modified in last 7 days"
echo "git log --since='7 days ago' --name-only --pretty=format: | sort -u"
echo ""

# Note about using Claude Code tools
echo -e "${BLUE}Note: These are examples. In Claude Code, prefer using:${NC}"
echo "  - Glob tool for file pattern matching"
echo "  - Grep tool for content searching"
echo "  - Read tool for file examination"
echo "  - Bash tool only when shell features are specifically needed"

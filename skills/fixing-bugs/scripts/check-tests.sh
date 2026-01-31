#!/bin/bash

# check-tests.sh
#
# Find and run relevant tests for a bug fix.
# This script helps you:
# 1. Locate tests related to the bug
# 2. Run specific test suites
# 3. Check coverage of bug-related code
# 4. Verify fix doesn't break existing tests
#
# Usage: ./check-tests.sh [options]
# Options:
#   --bug-id ID              Issue/bug identifier
#   --language LANG          Language (python, javascript, typescript)
#   --path PATH              Root path to search
#   --run                    Run found tests
#   --coverage               Generate coverage report
#   --verbose               Verbose output
#   --help                  Show this help

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

BUG_ID="${1:-}"
LANGUAGE="${LANGUAGE:-}"
SEARCH_PATH="${SEARCH_PATH:-.}"
RUN_TESTS="${RUN_TESTS:-false}"
GENERATE_COVERAGE="${GENERATE_COVERAGE:-false}"
VERBOSE="${VERBOSE:-false}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Test results tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

log() {
    echo -e "${BLUE}[LOG]${NC} $*"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

verbose_log() {
    if [ "$VERBOSE" = "true" ]; then
        echo -e "${MAGENTA}[VERBOSE]${NC} $*"
    fi
}

print_header() {
    echo ""
    echo "=========================================="
    echo "$1"
    echo "=========================================="
    echo ""
}

# ============================================================================
# DETECTION
# ============================================================================

detect_language() {
    print_header "DETECTING PROJECT LANGUAGE"

    if [ -z "$LANGUAGE" ]; then
        if [ -f "package.json" ]; then
            LANGUAGE="javascript"
            log "Detected: JavaScript/TypeScript project"
        elif [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
            LANGUAGE="python"
            log "Detected: Python project"
        elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
            LANGUAGE="java"
            log "Detected: Java project"
        elif [ -f "go.mod" ]; then
            LANGUAGE="go"
            log "Detected: Go project"
        else
            warning "Could not auto-detect language"
            error "Please specify --language LANG"
            exit 1
        fi
    else
        log "Using specified language: $LANGUAGE"
    fi
}

find_related_files() {
    print_header "FINDING RELATED FILES"

    if [ -z "$BUG_ID" ]; then
        warning "No bug ID specified, searching for all test files"
        return
    fi

    log "Searching for files related to: $BUG_ID"

    case "$LANGUAGE" in
        python)
            # Look for test files with bug ID in name or content
            log "Python test files:"
            find "$SEARCH_PATH" -type f -name "*test*.py" \
                -o -name "test_*" \
                | head -20 | while read -r file; do
                verbose_log "  Found: $file"
                if grep -l "$BUG_ID\|issue.*$BUG_ID\|bug.*$BUG_ID" "$file" 2>/dev/null; then
                    echo "  ✓ Related: $file"
                fi
            done
            ;;

        javascript|typescript)
            log "JavaScript/TypeScript test files:"
            find "$SEARCH_PATH" -type f \( -name "*.test.ts" -o -name "*.test.js" -o -name "*.spec.ts" -o -name "*.spec.js" \) \
                | head -20 | while read -r file; do
                verbose_log "  Found: $file"
                if grep -l "$BUG_ID\|issue.*$BUG_ID\|bug.*$BUG_ID" "$file" 2>/dev/null; then
                    echo "  ✓ Related: $file"
                fi
            done
            ;;

        java)
            log "Java test files:"
            find "$SEARCH_PATH" -type f -name "*Test.java" \
                | head -20 | while read -r file; do
                verbose_log "  Found: $file"
                if grep -l "$BUG_ID\|issue.*$BUG_ID\|bug.*$BUG_ID" "$file" 2>/dev/null; then
                    echo "  ✓ Related: $file"
                fi
            done
            ;;

        go)
            log "Go test files:"
            find "$SEARCH_PATH" -type f -name "*_test.go" \
                | head -20 | while read -r file; do
                verbose_log "  Found: $file"
                if grep -l "$BUG_ID\|issue.*$BUG_ID\|bug.*$BUG_ID" "$file" 2>/dev/null; then
                    echo "  ✓ Related: $file"
                fi
            done
            ;;
    esac
}

# ============================================================================
# TEST EXECUTION
# ============================================================================

run_python_tests() {
    print_header "RUNNING PYTHON TESTS"

    if ! command -v pytest &>/dev/null; then
        warning "pytest not found, trying unittest"
        python -m unittest discover -s tests -p "test_*.py" -v
        return $?
    fi

    local test_args=""

    if [ -n "$BUG_ID" ]; then
        log "Running tests matching: $BUG_ID"
        test_args="-k $BUG_ID"
    else
        log "Running all tests..."
    fi

    if [ "$GENERATE_COVERAGE" = "true" ]; then
        pytest $test_args --cov --cov-report=html
        log "Coverage report generated in htmlcov/"
    else
        pytest $test_args -v
    fi
}

run_javascript_tests() {
    print_header "RUNNING JAVASCRIPT/TYPESCRIPT TESTS"

    local test_command=""
    local test_args=""

    # Determine test runner
    if [ -f "package.json" ]; then
        if grep -q "\"jest\"" package.json; then
            test_command="npm test"
            test_args="--"
        elif grep -q "\"vitest\"" package.json; then
            test_command="npm run test"
            test_args="--"
        elif grep -q "\"mocha\"" package.json; then
            test_command="npm test"
        fi
    fi

    if [ -z "$test_command" ]; then
        error "Could not determine JavaScript test runner"
        return 1
    fi

    if [ -n "$BUG_ID" ]; then
        log "Running tests matching: $BUG_ID"
        $test_command $test_args --testNamePattern="$BUG_ID"
    else
        log "Running all tests..."
        $test_command
    fi
}

run_java_tests() {
    print_header "RUNNING JAVA TESTS"

    if [ -f "pom.xml" ]; then
        if [ -n "$BUG_ID" ]; then
            log "Running tests matching: $BUG_ID"
            mvn test -Dtest="*$BUG_ID*"
        else
            log "Running all tests..."
            mvn test
        fi
    elif [ -f "build.gradle" ]; then
        if [ -n "$BUG_ID" ]; then
            log "Running tests matching: $BUG_ID"
            ./gradlew test --tests "*$BUG_ID*"
        else
            log "Running all tests..."
            ./gradlew test
        fi
    fi
}

run_go_tests() {
    print_header "RUNNING GO TESTS"

    if [ -n "$BUG_ID" ]; then
        log "Running tests matching: $BUG_ID"
        go test -v -run "$BUG_ID" ./...
    else
        log "Running all tests..."
        go test -v ./...
    fi

    if [ "$GENERATE_COVERAGE" = "true" ]; then
        go test -coverprofile=coverage.out ./...
        go tool cover -html=coverage.out -o coverage.html
        log "Coverage report generated: coverage.html"
    fi
}

run_all_tests() {
    print_header "RUNNING ALL TESTS"

    case "$LANGUAGE" in
        python)
            run_python_tests
            ;;
        javascript|typescript)
            run_javascript_tests
            ;;
        java)
            run_java_tests
            ;;
        go)
            run_go_tests
            ;;
        *)
            error "Unsupported language: $LANGUAGE"
            exit 1
            ;;
    esac
}

# ============================================================================
# COVERAGE ANALYSIS
# ============================================================================

analyze_coverage() {
    print_header "COVERAGE ANALYSIS"

    case "$LANGUAGE" in
        python)
            log "Generating Python coverage report..."
            if command -v coverage &>/dev/null; then
                coverage report -m
                coverage html
                log "Coverage report: htmlcov/index.html"
            else
                warning "coverage tool not found"
            fi
            ;;

        javascript|typescript)
            log "Coverage report available after running tests with --coverage flag"
            if [ -d "coverage" ]; then
                log "Coverage directory found: coverage/"
                log "Open coverage/index.html in browser"
            fi
            ;;

        java)
            log "Coverage report generated by Maven Surefire or Gradle Test"
            log "Check target/site/jacoco/ or build/reports/jacoco/"
            ;;

        go)
            log "Go coverage available in coverage.html"
            ;;
    esac
}

# ============================================================================
# RECOMMENDATIONS
# ============================================================================

generate_recommendations() {
    print_header "RECOMMENDATIONS"

    echo ""
    echo "After running tests:"
    echo ""

    case "$LANGUAGE" in
        python)
            cat << 'EOF'
1. Add regression test for the bug:
   - Location: tests/test_regression.py
   - Template: Use test-for-bug-template.py
   - Run: pytest tests/test_regression.py -v

2. Check coverage of affected module:
   - python -m pytest --cov=module_name

3. Run linting:
   - pylint src/
   - flake8 src/
   - black --check src/

4. Type checking:
   - mypy src/ --strict
EOF
            ;;

        javascript|typescript)
            cat << 'EOF'
1. Add regression test for the bug:
   - Location: src/__tests__/regression.test.ts
   - Template: Use test-for-bug-template.ts
   - Run: npm test -- regression

2. Check coverage:
   - npm test -- --coverage

3. Run linting:
   - npm run lint
   - npm run format

4. Type checking:
   - tsc --noEmit
EOF
            ;;

        java)
            cat << 'EOF'
1. Add regression test:
   - Location: src/test/java/RegressionTest.java
   - Run: mvn test -Dtest=RegressionTest

2. Generate coverage report:
   - mvn jacoco:report
   - View: target/site/jacoco/index.html

3. Run checkstyle:
   - mvn checkstyle:check
EOF
            ;;

        go)
            cat << 'EOF'
1. Add regression test:
   - Location: bug_test.go
   - Run: go test -v -run TestBugFix

2. Generate coverage:
   - go test -cover ./...
   - go test -coverprofile=coverage.out ./...
   - go tool cover -html=coverage.out

3. Run linting:
   - go fmt ./...
   - go vet ./...
   - golangci-lint run
EOF
            ;;
    esac

    echo ""
    echo "Next steps:"
    echo "1. Review test results above"
    echo "2. Implement fix if not done"
    echo "3. Add regression test from template"
    echo "4. Run tests again to verify fix"
    echo ""
}

# ============================================================================
# REPORTING
# ============================================================================

generate_test_report() {
    print_header "TEST REPORT"

    local report_file="test_report_${BUG_ID}_$(date +%s).txt"

    {
        echo "Test Report - $(date)"
        echo "Bug ID: $BUG_ID"
        echo "Language: $LANGUAGE"
        echo ""
        echo "Test Run Results:"
        echo "Total: $TOTAL_TESTS"
        echo "Passed: $PASSED_TESTS"
        echo "Failed: $FAILED_TESTS"
        echo ""

        if [ -f "coverage.txt" ]; then
            echo "Coverage:"
            cat coverage.txt
        fi
    } | tee "$report_file"

    log "Report saved: $report_file"
}

# ============================================================================
# LISTING
# ============================================================================

list_all_tests() {
    print_header "AVAILABLE TESTS"

    case "$LANGUAGE" in
        python)
            log "Python test files:"
            find "$SEARCH_PATH" -type f -name "test_*.py" -o -name "*_test.py" | sort
            ;;

        javascript|typescript)
            log "JavaScript/TypeScript test files:"
            find "$SEARCH_PATH" -type f \( -name "*.test.ts" -o -name "*.test.js" -o -name "*.spec.ts" -o -name "*.spec.js" \) | sort
            ;;

        java)
            log "Java test files:"
            find "$SEARCH_PATH" -type f -name "*Test.java" -o -name "*Tests.java" | sort
            ;;

        go)
            log "Go test files:"
            find "$SEARCH_PATH" -type f -name "*_test.go" | sort
            ;;
    esac

    echo ""
    log "To run a specific test file:"
    case "$LANGUAGE" in
        python)
            echo "  pytest path/to/test_file.py -v"
            ;;
        javascript)
            echo "  npm test -- path/to/test_file"
            ;;
    esac
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    print_header "BUG TEST CHECKER"

    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi

    if [ "$1" = "--list-tests" ]; then
        detect_language
        list_all_tests
        exit 0
    fi

    detect_language
    find_related_files

    if [ "$RUN_TESTS" = "true" ] || [ -z "$1" ]; then
        run_all_tests
        if [ "$GENERATE_COVERAGE" = "true" ]; then
            analyze_coverage
        fi
    fi

    generate_recommendations
}

show_help() {
    cat << 'EOF'
check-tests.sh - Find and run relevant tests for bug fixes

USAGE:
    ./check-tests.sh [OPTIONS]

OPTIONS:
    --bug-id ID         Bug/issue identifier to search for
    --language LANG     Language: python, javascript, typescript, java, go
                        (auto-detected if not specified)
    --path PATH         Root path to search (default: current directory)
    --run               Run tests after finding them
    --coverage          Generate coverage report
    --list-tests        List all test files and exit
    --verbose          Verbose output
    --help             Show this help message

EXAMPLES:
    # Find tests related to bug-123
    ./check-tests.sh --bug-id bug-123

    # Run all Python tests with coverage
    ./check-tests.sh --language python --run --coverage

    # List all test files
    ./check-tests.sh --list-tests

    # Find and run JavaScript tests for issue-456
    ./check-tests.sh --bug-id issue-456 --language javascript --run

EOF
}

# ============================================================================
# ENTRY POINT
# ============================================================================

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --bug-id)
            BUG_ID="$2"
            shift 2
            ;;
        --language)
            LANGUAGE="$2"
            shift 2
            ;;
        --path)
            SEARCH_PATH="$2"
            shift 2
            ;;
        --run)
            RUN_TESTS="true"
            shift
            ;;
        --coverage)
            GENERATE_COVERAGE="true"
            RUN_TESTS="true"
            shift
            ;;
        --verbose)
            VERBOSE="true"
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        --list-tests)
            detect_language
            list_all_tests
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

main

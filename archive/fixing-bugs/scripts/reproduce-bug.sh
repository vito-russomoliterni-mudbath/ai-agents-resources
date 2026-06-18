#!/bin/bash

# reproduce-bug.sh
#
# Template script for systematically reproducing bugs.
# This script provides a structured framework to:
# 1. Document the bug
# 2. Set up the environment
# 3. Execute reproduction steps
# 4. Capture results for analysis
#
# Usage: ./reproduce-bug.sh [options]
# Options:
#   --bug-id ID              Unique identifier for the bug
#   --environment ENV        Environment to test in (local, dev, staging)
#   --verbose               Verbose output
#   --help                  Show this help

set -e  # Exit on error

# ============================================================================
# CONFIGURATION
# ============================================================================

# Bug metadata - CUSTOMIZE FOR YOUR BUG
BUG_ID="${1:-bug-001}"
BUG_TITLE="[Replace with bug title]"
BUG_DESCRIPTION="[Replace with bug description]"
ENVIRONMENT="${ENVIRONMENT:-local}"
VERBOSE="${VERBOSE:-false}"
OUTPUT_DIR="./bug-reproduction-${BUG_ID}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
        echo -e "${BLUE}[VERBOSE]${NC} $*"
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
# SETUP
# ============================================================================

setup_reproduction_environment() {
    print_header "SETUP: Preparing Reproduction Environment"

    log "Creating output directory: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"

    log "Recording system information..."
    {
        echo "=== System Information ==="
        echo "Timestamp: $(date)"
        echo "Hostname: $(hostname)"
        echo "OS: $(uname -s)"
        echo "Shell: $SHELL"
        echo ""
    } > "$OUTPUT_DIR/environment.txt"

    log "Verifying prerequisites..."
    verify_prerequisites

    log "Setting up environment for: $ENVIRONMENT"
    setup_environment "$ENVIRONMENT"

    success "Environment setup complete"
}

verify_prerequisites() {
    # CUSTOMIZE: Add checks for required tools
    local required_tools=("python" "pip" "git")

    for tool in "${required_tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            verbose_log "✓ Found: $tool ($(command -v $tool))"
        else
            error "Required tool not found: $tool"
            exit 1
        fi
    done
}

setup_environment() {
    local env=$1

    case "$env" in
        local)
            log "Setting up local environment..."
            # CUSTOMIZE: Add local setup steps
            if [ -f ".venv/bin/activate" ]; then
                source .venv/bin/activate
                verbose_log "Activated virtual environment"
            fi
            ;;
        dev)
            log "Setting up development environment..."
            # CUSTOMIZE: Add dev setup steps
            export APP_ENV="development"
            export DEBUG="true"
            ;;
        staging)
            log "Setting up staging environment..."
            # CUSTOMIZE: Add staging setup steps
            export APP_ENV="staging"
            ;;
        *)
            error "Unknown environment: $env"
            exit 1
            ;;
    esac
}

# ============================================================================
# REPRODUCTION STEPS
# ============================================================================

document_bug() {
    print_header "BUG DOCUMENTATION"

    echo "Bug ID: $BUG_ID"
    echo "Title: $BUG_TITLE"
    echo "Description: $BUG_DESCRIPTION"
    echo "Environment: $ENVIRONMENT"
    echo ""

    # CUSTOMIZE: Add bug-specific information
    echo "Expected Behavior:"
    echo "  [Replace with what should happen]"
    echo ""
    echo "Actual Behavior:"
    echo "  [Replace with what actually happens]"
    echo ""
    echo "Steps to Reproduce:"
    echo "  1. [First step]"
    echo "  2. [Second step]"
    echo "  3. [Third step]"
    echo ""
}

# CUSTOMIZE: Implement reproduction steps for your specific bug
step_1_setup_data() {
    print_header "STEP 1: Setup Test Data"

    log "Preparing test data..."

    # Example: Create test user
    # python -c "from app.models import User; User.create(email='test@example.com')"

    # Example: Load test fixtures
    # python manage.py loaddata test_data.json

    success "Test data prepared"
}

step_2_trigger_bug() {
    print_header "STEP 2: Trigger the Bug"

    log "Executing code that triggers the bug..."

    # CUSTOMIZE: Replace with actual reproduction code
    # This could be:
    # - Running a specific command
    # - Calling an API endpoint
    # - Executing a function
    # - Using a tool with specific parameters

    # Example: Call buggy function
    # python -c "from app import buggy_function; buggy_function(test_param)"

    # Example: Make API request
    # curl -X POST http://localhost:8000/api/bug-endpoint -d '{"param": "value"}'

    # Example: Run test
    # pytest tests/test_bug.py::test_bug -v

    log "Code executed"
}

step_3_observe_failure() {
    print_header "STEP 3: Observe Failure"

    log "Capturing failure details..."

    # CUSTOMIZE: Collect failure evidence
    {
        echo "=== Failure Evidence ==="
        echo "Time: $(date)"
        echo ""

        # Capture output
        echo "Output:"
        # example_command 2>&1 || true
        echo ""

        # Capture error logs
        if [ -f "app.log" ]; then
            echo "Recent logs:"
            tail -20 app.log
        fi
    } | tee -a "$OUTPUT_DIR/failure_details.txt"

    warning "Failure captured in $OUTPUT_DIR/failure_details.txt"
}

step_4_verify_repro() {
    print_header "STEP 4: Verify Reproducibility"

    log "Testing if bug reproduces consistently..."

    local success_count=0
    local fail_count=0
    local iterations=3

    for i in $(seq 1 $iterations); do
        log "Attempt $i/$iterations..."

        # CUSTOMIZE: Run reproduction code again
        # if example_command &>/dev/null; then
        #     ((success_count++))
        #     log "  ✓ Bug reproduced"
        # else
        #     ((fail_count++))
        #     log "  ✗ Bug NOT reproduced"
        # fi
    done

    echo ""
    echo "Results: $success_count/$iterations attempts reproduced the bug"

    if [ $success_count -eq 0 ]; then
        warning "Bug could not be reproduced consistently"
        warning "This may be a timing/race condition issue"
        return 1
    fi

    success "Bug reproduced consistently"
    return 0
}

# ============================================================================
# ANALYSIS
# ============================================================================

analyze_reproduction() {
    print_header "ANALYSIS: Understanding the Bug"

    log "Analyzing reproduction data..."

    # CUSTOMIZE: Add analysis relevant to your bug
    {
        echo "=== Analysis ==="
        echo ""

        echo "Question 1: When does the bug occur?"
        echo "  - Consistently or intermittently?"
        echo "  - Under specific conditions?"
        echo ""

        echo "Question 2: What's affected?"
        echo "  - A single component?"
        echo "  - Multiple systems?"
        echo "  - Integration between systems?"
        echo ""

        echo "Question 3: What changed recently?"
        echo "  - Relevant commits:"
        git log --oneline -10
        echo ""

        echo "Question 4: Is this a known issue?"
        # grep -r "bug-specific-term" . --include="*.md" || true
        echo ""
    } | tee -a "$OUTPUT_DIR/analysis.txt"
}

# ============================================================================
# CLEAN UP
# ============================================================================

cleanup_reproduction() {
    print_header "CLEANUP"

    log "Cleaning up reproduction environment..."

    # CUSTOMIZE: Add cleanup steps
    # - Remove test data
    # - Restore original state
    # - Close connections

    # Example:
    # python -c "from app.models import User; User.delete().where(User.email == 'test@example.com').execute()"

    success "Cleanup complete"
}

# ============================================================================
# REPORTING
# ============================================================================

generate_report() {
    print_header "REPRODUCTION REPORT"

    local report_file="$OUTPUT_DIR/bug_reproduction_report.md"

    {
        echo "# Bug Reproduction Report"
        echo ""
        echo "**Generated:** $(date)"
        echo "**Bug ID:** $BUG_ID"
        echo ""

        echo "## Bug Information"
        echo ""
        echo "**Title:** $BUG_TITLE"
        echo ""
        echo "**Description:** $BUG_DESCRIPTION"
        echo ""
        echo "**Environment:** $ENVIRONMENT"
        echo ""

        echo "## Reproduction Steps"
        echo ""
        echo "1. Setup test data"
        echo "2. Trigger the bug"
        echo "3. Observe failure"
        echo "4. Verify consistency"
        echo ""

        echo "## Results"
        echo ""
        if [ -f "$OUTPUT_DIR/failure_details.txt" ]; then
            echo "### Failure Details"
            echo "\`\`\`"
            cat "$OUTPUT_DIR/failure_details.txt"
            echo "\`\`\`"
        fi

        echo ""
        echo "## Analysis"
        echo ""
        if [ -f "$OUTPUT_DIR/analysis.txt" ]; then
            cat "$OUTPUT_DIR/analysis.txt"
        fi

        echo ""
        echo "## Next Steps"
        echo ""
        echo "1. Investigate root cause using debugging-strategies.md"
        echo "2. Create test case to verify fix"
        echo "3. Implement fix"
        echo "4. Run regression tests"
        echo ""

    } > "$report_file"

    log "Report generated: $report_file"
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    print_header "BUG REPRODUCTION FRAMEWORK"
    echo "Bug ID: $BUG_ID"
    echo "Output: $OUTPUT_DIR"
    echo ""

    # Execute reproduction workflow
    setup_reproduction_environment
    document_bug
    step_1_setup_data
    step_2_trigger_bug
    step_3_observe_failure

    if step_4_verify_repro; then
        analyze_reproduction
        generate_report
        echo ""
        success "Bug successfully reproduced!"
        echo ""
        echo "Output files in: $OUTPUT_DIR"
        ls -la "$OUTPUT_DIR"
    else
        warning "Bug reproduction inconclusive"
    fi

    # cleanup_reproduction  # Uncomment if you want automatic cleanup
}

# ============================================================================
# ENTRY POINT
# ============================================================================

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    cat << 'EOF'
reproduce-bug.sh - Systematic bug reproduction framework

USAGE:
    ./reproduce-bug.sh [OPTIONS]

OPTIONS:
    --bug-id ID         Bug identifier (default: bug-001)
    --environment ENV   Environment: local, dev, staging (default: local)
    --verbose          Verbose output
    --help             Show this help message

CUSTOMIZATION:
    Edit this script to customize for your specific bug:
    1. Update BUG_TITLE and BUG_DESCRIPTION
    2. Implement step_1_setup_data() - prepare test data
    3. Implement step_2_trigger_bug() - execute buggy code
    4. Implement step_3_observe_failure() - capture error details
    5. Add environment setup in setup_environment()

EXAMPLE:
    ./reproduce-bug.sh --bug-id issue-123 --environment dev --verbose

EOF
    exit 0
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --bug-id)
            BUG_ID="$2"
            shift 2
            ;;
        --environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE="true"
            shift
            ;;
        *)
            error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Run main execution
main

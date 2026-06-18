#!/usr/bin/env bash
#
# Script: script-name.sh
# Description: Brief description of what this script does
# Usage: ./script-name.sh [options] <arguments>
#
# Author: Your Name
# Date: YYYY-MM-DD
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Script directory (useful for relative paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values for options
VERBOSE=false
DRY_RUN=false

# Colors for output (optional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#######################################
# Print usage information
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Usage text to stdout
#######################################
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <argument>

Description:
    Brief description of what the script does.

Arguments:
    argument    Description of the required argument

Options:
    -h, --help      Show this help message and exit
    -v, --verbose   Enable verbose output
    -n, --dry-run   Show what would be done without making changes

Examples:
    $(basename "$0") input.txt
    $(basename "$0") -v --dry-run input.txt

EOF
}

#######################################
# Log a message with timestamp
# Globals:
#   VERBOSE
# Arguments:
#   Message to log
# Outputs:
#   Timestamped message to stderr
#######################################
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

#######################################
# Log verbose message (only if VERBOSE=true)
# Globals:
#   VERBOSE
# Arguments:
#   Message to log
# Outputs:
#   Message to stderr if VERBOSE
#######################################
log_verbose() {
    if [[ "$VERBOSE" == true ]]; then
        log "VERBOSE: $*"
    fi
}

#######################################
# Log error message and exit
# Globals:
#   None
# Arguments:
#   Error message
#   Exit code (optional, default: 1)
# Outputs:
#   Error message to stderr
#######################################
die() {
    local message="${1:-Unknown error}"
    local code="${2:-1}"
    echo -e "${RED}ERROR: ${message}${NC}" >&2
    exit "$code"
}

#######################################
# Log success message
# Globals:
#   None
# Arguments:
#   Success message
# Outputs:
#   Success message to stderr
#######################################
success() {
    echo -e "${GREEN}SUCCESS: $*${NC}" >&2
}

#######################################
# Log warning message
# Globals:
#   None
# Arguments:
#   Warning message
# Outputs:
#   Warning message to stderr
#######################################
warn() {
    echo -e "${YELLOW}WARNING: $*${NC}" >&2
}

#######################################
# Check if required commands are available
# Globals:
#   None
# Arguments:
#   Command names to check
# Returns:
#   0 if all commands exist, exits otherwise
#######################################
check_requirements() {
    local missing=()
    for cmd in "$@"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing required commands: ${missing[*]}"
    fi
}

#######################################
# Parse command line arguments
# Globals:
#   VERBOSE
#   DRY_RUN
# Arguments:
#   Command line arguments
# Returns:
#   Sets global variables based on arguments
#######################################
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            --)
                shift
                break
                ;;
            -*)
                die "Unknown option: $1"
                ;;
            *)
                # First non-option argument
                break
                ;;
        esac
    done

    # Store remaining arguments
    ARGS=("$@")
}

#######################################
# Main script logic
# Globals:
#   ARGS
#   VERBOSE
#   DRY_RUN
# Arguments:
#   None
# Returns:
#   0 on success, non-zero on error
#######################################
main() {
    # Parse arguments
    parse_args "$@"

    # Validate required arguments
    if [[ ${#ARGS[@]} -lt 1 ]]; then
        die "Missing required argument. Use --help for usage."
    fi

    local input="${ARGS[0]}"

    log "Starting script..."
    log_verbose "Input: $input"
    log_verbose "Verbose mode: $VERBOSE"
    log_verbose "Dry run: $DRY_RUN"

    # Check requirements (add any required commands)
    # check_requirements curl jq

    # Validate input
    if [[ ! -f "$input" ]]; then
        die "Input file not found: $input"
    fi

    # Main logic goes here
    if [[ "$DRY_RUN" == true ]]; then
        log "DRY RUN: Would process $input"
    else
        log "Processing $input..."
        # TODO: Add your processing logic here
    fi

    success "Script completed successfully"
}

# Run main function with all arguments
main "$@"

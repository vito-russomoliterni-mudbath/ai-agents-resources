#!/usr/bin/env bash

# SYNOPSIS
#     Install or update skills to local agent home directories (Claude Code, Codex, Gemini, OpenCode, Mistral Vibe).

# Default variables
SKIP_PROMPTS=0
VERBOSE=0
DRY_RUN=0
SKIP_AGENT_PROMPT=0
COPY_MODE=0

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

show_help() {
    cat << EOF
Install or update skills to local agent home directories.

By default on Linux/macOS, skills are installed as symlinks so edits propagate
live. On other platforms (or when --copy is passed), files are copied instead.

In addition to skills, this script installs OpenCode subagents (subagents/*.md)
and a dispatch script (skills/orchestrator/scripts/dispatch.sh) when OpenCode is selected.

Options:
  -y                  Skip confirmation prompts and install/update all skills automatically
  --skip-agent-prompt Skip the agent selection prompt and install to all agents
  --copy              Force copy behavior instead of symlinks
  -v                  Show detailed output
  --dry-run           Show what would be done without making changes
  -h, --help          Show help message

Examples:
  ./install-skills.sh
  ./install-skills.sh -y
  ./install-skills.sh --skip-agent-prompt
  ./install-skills.sh --dry-run
  ./install-skills.sh --copy -y
EOF
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -y) SKIP_PROMPTS=1 ;;
        -v) VERBOSE=1 ;;
        --dry-run|-DryRun) DRY_RUN=1 ;;
        --copy) COPY_MODE=1 ;;
        --skip-agent-prompt|-SkipAgentPrompt) SKIP_AGENT_PROMPT=1 ;;
        -h|--help|-help) show_help; exit 0 ;;
        *) echo -e "${RED}Error: Invalid parameter(s): $1${NC}"; echo "Use --help for usage information"; exit 1 ;;
    esac
    shift
done

if [[ "$DRY_RUN" -eq 1 ]]; then
    echo -e "${MAGENTA}════════════════════════════════════════════════════════"
    echo -e "                    DRY RUN MODE                        "
    echo -e "  No changes will be made to the filesystem             "
    echo -e "════════════════════════════════════════════════════════${NC}\n"
fi

msg_success() { echo -e "${GREEN}$1${NC}"; }
msg_info() { echo -e "${CYAN}$1${NC}"; }
msg_warning() { echo -e "${YELLOW}$1${NC}"; }
msg_error() { echo -e "${RED}$1${NC}"; }
msg_verbose() { [[ "$VERBOSE" -eq 1 ]] && echo -e "${GRAY}[VERBOSE] $1${NC}"; }
msg_dryrun() { [[ "$DRY_RUN" -eq 1 ]] && echo -e "${MAGENTA}[DRY RUN] $1${NC}"; }

install_item() {
    local source="$1"
    local dest="$2"
    local label="$3"

    # Create parent directory if needed
    local parent_dir
    parent_dir="$(dirname "$dest")"
    if [[ ! -d "$parent_dir" ]]; then
        if [[ "$DRY_RUN" -eq 1 ]]; then
            msg_dryrun "[$label] Would create directory: $parent_dir"
        else
            mkdir -p "$parent_dir"
        fi
    fi

    # Dry run
    if [[ "$DRY_RUN" -eq 1 ]]; then
        if [[ -e "$dest" ]]; then
            msg_dryrun "[$label] Would remove existing: $dest"
        fi
        if [[ "$COPY_MODE" -eq 1 ]]; then
            msg_dryrun "[$label] Would copy from: $source"
        else
            msg_dryrun "[$label] Would symlink from: $source"
        fi
        msg_dryrun "[$label] Would install to: $dest"
        return 0
    fi

    # Remove existing destination
    if [[ -e "$dest" ]]; then
        rm -rf "$dest"
    fi

    # Force copy mode
    if [[ "$COPY_MODE" -eq 1 ]]; then
        cp -R "$source" "$dest" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            msg_verbose "[$label] Copied: $source -> $dest"
            return 0
        fi
        msg_error "[$label] Failed to copy"
        return 1
    fi

    # Try symlink with resolved absolute path
    local resolved_source
    resolved_source="$(realpath "$source" 2>/dev/null || readlink -f "$source" 2>/dev/null || echo "$source")"
    if ln -s "$resolved_source" "$dest" 2>/dev/null; then
        msg_verbose "[$label] Symlinked: $dest -> $resolved_source"
        return 0
    fi

    # Symlink failed — fall back to copy
    msg_warning "[$label] Symlink failed, falling back to copy"
    cp -R "$source" "$dest" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        msg_verbose "[$label] Copied: $source -> $dest"
        return 0
    fi
    msg_error "[$label] Failed to install"
    return 1
}

# Agents configuration
declare -A AGENT_NAMES=([claude]="Claude Code" [codex]="Codex" [gemini]="Gemini (Antigravity)" [gemini_cli]="Gemini CLI" [opencode]="OpenCode" [vibe]="Mistral Vibe")
declare -A AGENT_ENV=([claude]="CLAUDE_HOME" [codex]="CODEX_HOME" [gemini]="GEMINI_HOME" [gemini_cli]="GEMINI_HOME" [opencode]="OPENCODE_HOME" [vibe]="VIBE_HOME")
declare -A AGENT_DEFAULT_DIR=([claude]=".claude" [codex]=".codex" [gemini]=".gemini" [gemini_cli]=".gemini" [opencode]=".config/opencode" [vibe]=".vibe")
declare -A AGENT_SKILLS_SUBDIR=([claude]="skills" [codex]="skills" [gemini]="antigravity/global_skills" [gemini_cli]="skills" [opencode]="skills" [vibe]="skills")

SELECTED_AGENTS=("claude" "codex" "gemini" "gemini_cli" "opencode" "vibe")

if [[ "$SKIP_AGENT_PROMPT" -eq 0 ]]; then
    echo -e "\n${CYAN}Select which agent to install skills for:${NC}"
    echo -e "${GRAY}  [1] Claude Code${NC}"
    echo -e "${GRAY}  [2] Codex${NC}"
    echo -e "${GRAY}  [3] Gemini (CLI + Antigravity)${NC}"
    echo -e "${GRAY}  [4] OpenCode${NC}"
    echo -e "${GRAY}  [5] Mistral Vibe${NC}"
    echo -e "${GRAY}  [6] All (default)${NC}"
    read -p "Choose an option [1/2/3/4/5/6]: " agent_choice

    case "${agent_choice,,}" in
        1|c|claude) SELECTED_AGENTS=("claude") ;;
        2|x|codex) SELECTED_AGENTS=("codex") ;;
        3|g|gemini) SELECTED_AGENTS=("gemini" "gemini_cli") ;;
        4|o|opencode) SELECTED_AGENTS=("opencode") ;;
        5|v|vibe) SELECTED_AGENTS=("vibe") ;;
        6|a|all|"") SELECTED_AGENTS=("claude" "codex" "gemini" "gemini_cli" "opencode" "vibe") ;;
        *) msg_warning "Unrecognized selection '$agent_choice'. Defaulting to all agents." ;;
    esac
else
    msg_verbose "Skipping agent prompt; defaulting to all agents"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE_DIR="$SCRIPT_DIR/skills"

msg_verbose "Script directory: $SCRIPT_DIR"
msg_verbose "Source skills directory: $SKILLS_SOURCE_DIR"

if [[ ! -d "$SKILLS_SOURCE_DIR" ]]; then
    msg_error "Error: Skills directory not found at $SKILLS_SOURCE_DIR"
    exit 1
fi

shopt -s nullglob
SKILLS=( "$SKILLS_SOURCE_DIR"/*/ )
shopt -u nullglob

if [[ ${#SKILLS[@]} -eq 0 ]]; then
    msg_warning "No skills found in $SKILLS_SOURCE_DIR"
    exit 0
fi

msg_info "\nFound ${#SKILLS[@]} skill(s) to install/update\n"

resolve_agent_home() {
    local agent_key="$1"
    local env_var="${AGENT_ENV[$agent_key]}"
    local default_dir="${AGENT_DEFAULT_DIR[$agent_key]}"
    
    if [[ -n "${!env_var}" ]]; then
        msg_verbose "Using $env_var environment variable for $agent_key: ${!env_var}"
        echo "${!env_var}"
    else
        echo "$HOME/$default_dir"
    fi
}

install_skills_for_agent() {
    local agent_key="$1"
    local agent_name="${AGENT_NAMES[$agent_key]}"
    local dest_dir="$2"
    
    echo -e "\n${CYAN}Installing skills for $agent_name${NC}"
    echo -e "${GRAY}Target directory: $dest_dir${NC}"
    
    local installed=0
    local updated=0
    local skipped=0
    
    for skill_path in "${SKILLS[@]}"; do
        skill_path="${skill_path%/}"
        local skill_name="$(basename "$skill_path")"
        local source_path="$skill_path"
        local skill_dest="$dest_dir/$skill_name"
        
        echo -e "${GRAY}──────────────────────────────────────────────────${NC}"
        echo -e "${GRAY}Agent: $agent_name${NC}"
        echo -e -n "${GRAY}Skill: ${NC}"
        echo -e "${MAGENTA}$skill_name${NC}"
        
        msg_verbose "Source: $source_path"
        msg_verbose "Destination: $skill_dest"
        
        local is_update=0
        if [[ -d "$skill_dest" ]]; then
            is_update=1
            msg_warning "  Status: Already exists (will be updated)"
        else
            msg_info "  Status: New installation"
        fi
        
        local should_install=$SKIP_PROMPTS
        if [[ "$DRY_RUN" -eq 1 ]]; then
            should_install=1
        fi
        
        if [[ "$should_install" -eq 0 ]]; then
            echo ""
            local action="Install"
            [[ "$is_update" -eq 1 ]] && action="Update"
            read -p "  $action this skill for $agent_name? [Y/n] " response
            if [[ "$response" =~ ^[Nn] ]]; then
                should_install=0
            else
                should_install=1
            fi
        fi
        
        if [[ "$should_install" -eq 1 ]]; then
            local action_label="$agent_name / $skill_name"
            install_item "$source_path" "$skill_dest" "$action_label"
            local ret=$?

            if [[ "$DRY_RUN" -eq 1 ]]; then
                if [[ "$is_update" -eq 1 ]]; then
                    echo -e "${MAGENTA}  [DRY RUN] Would update successfully${NC}"
                    ((updated++))
                else
                    echo -e "${MAGENTA}  [DRY RUN] Would install successfully${NC}"
                    ((installed++))
                fi
            elif [[ $ret -eq 0 ]]; then
                if [[ "$is_update" -eq 1 ]]; then
                    msg_success "  ✓ Updated successfully"
                    ((updated++))
                else
                    msg_success "  ✓ Installed successfully"
                    ((installed++))
                fi
            else
                msg_error "  ✗ Failed to install"
            fi
        else
            msg_warning "  ○ Skipped"
            ((skipped++))
        fi
        
        echo ""
    done
    
    echo -e "${GRAY}══════════════════════════════════════════════════${NC}"
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo -e "${MAGENTA}Summary (DRY RUN) - $agent_name:${NC}"
        echo -e "${GREEN}  Would install: $installed${NC}"
        echo -e "${YELLOW}  Would update:  $updated${NC}"
        echo -e "${GRAY}  Would skip:    $skipped${NC}"
    else
        echo -e "${CYAN}Summary - $agent_name:${NC}"
        echo -e "${GREEN}  Installed: $installed${NC}"
        echo -e "${YELLOW}  Updated:   $updated${NC}"
        echo -e "${GRAY}  Skipped:   $skipped${NC}"
    fi
    echo -e "${GRAY}══════════════════════════════════════════════════${NC}"
    
    if (( installed > 0 || updated > 0 )); then
        echo ""
        if [[ "$DRY_RUN" -eq 1 ]]; then
            echo -e "${MAGENTA}[DRY RUN] Skills would be available in $agent_name!${NC}"
            echo -e "${MAGENTA}[DRY RUN] Location: $dest_dir${NC}"
        else
            msg_success "Skills are now available in $agent_name!"
            msg_info "Location: $dest_dir"
        fi
    fi
}

install_subagents() {
    local agent_home="$1"
    local dest_dir="$agent_home/agents"
    local source_dir="$SCRIPT_DIR/subagents"

    if [[ ! -d "$source_dir" ]]; then
        msg_verbose "No subagents directory found at $source_dir"
        return
    fi

    echo -e "\n${CYAN}Installing subagents for OpenCode${NC}"
    echo -e "${GRAY}Target directory: $dest_dir${NC}"

    shopt -s nullglob
    local files=( "$source_dir"/*.md )
    shopt -u nullglob

    if [[ ${#files[@]} -eq 0 ]]; then
        msg_warning "  No subagent files found in $source_dir"
        return
    fi

    local installed=0

    for file in "${files[@]}"; do
        local filename
        filename="$(basename "$file")"
        local dest="$dest_dir/$filename"

        echo -e "${GRAY}  Subagent: ${NC}${MAGENTA}$filename${NC}"

        install_item "$file" "$dest" "OpenCode Subagent / $filename"
        local ret=$?

        if [[ "$DRY_RUN" -eq 1 ]] || [[ $ret -eq 0 ]]; then
            ((installed++))
        fi
    done

    echo ""
    echo -e "${GRAY}══════════════════════════════════════════════════${NC}"
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo -e "${MAGENTA}Summary (DRY RUN) - OpenCode Subagents:${NC}"
        echo -e "${MAGENTA}  Would install: $installed${NC}"
    else
        echo -e "${CYAN}Summary - OpenCode Subagents:${NC}"
        echo -e "${GREEN}  Installed: $installed${NC}"
    fi
    echo -e "${GRAY}══════════════════════════════════════════════════${NC}"
}

install_dispatch_script() {
    local source="$SCRIPT_DIR/skills/orchestrator/scripts/dispatch.sh"
    local dest_dir="$HOME/.local/bin"
    local dest="$dest_dir/dispatch-openagent"

    if [[ ! -f "$source" ]]; then
        msg_verbose "No dispatch script found at $source"
        return
    fi

    echo -e "\n${CYAN}Installing dispatch script${NC}"
    echo -e "${GRAY}Source: $source${NC}"
    echo -e "${GRAY}Destination: $dest${NC}"

    if [[ ! -d "$dest_dir" ]]; then
        if [[ "$DRY_RUN" -eq 1 ]]; then
            msg_dryrun "Would create directory: $dest_dir"
        else
            mkdir -p "$dest_dir"
        fi
    fi

    install_item "$source" "$dest" "Dispatch Script"

    if [[ "$DRY_RUN" -eq 0 ]] && [[ -f "$dest" ]]; then
        chmod +x "$dest"
        msg_verbose "Made executable: $dest"
    fi

    echo ""
    echo -e "${GRAY}══════════════════════════════════════════════════${NC}"
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo -e "${MAGENTA}Summary (DRY RUN) - Dispatch Script:${NC}"
        echo -e "${MAGENTA}  Would install: dispatch-openagent -> $dest${NC}"
    else
        echo -e "${CYAN}Summary - Dispatch Script:${NC}"
        if [[ -f "$dest" ]]; then
            echo -e "${GREEN}  Installed: dispatch-openagent -> $dest${NC}"
        fi
    fi
    echo -e "${GRAY}══════════════════════════════════════════════════${NC}"
}

for agent_key in "${SELECTED_AGENTS[@]}"; do
    agent_home=$(resolve_agent_home "$agent_key")
    msg_info "${AGENT_NAMES[$agent_key]} home directory: $agent_home"
    
    dest_dir="$agent_home/${AGENT_SKILLS_SUBDIR[$agent_key]}"
    if [[ ! -d "$dest_dir" ]]; then
        if [[ "$DRY_RUN" -eq 1 ]]; then
            msg_dryrun "Would create ${AGENT_NAMES[$agent_key]} skills directory: $dest_dir"
        else
            msg_info "Creating ${AGENT_NAMES[$agent_key]} skills directory: $dest_dir"
            mkdir -p "$dest_dir"
        fi
    fi
    
    install_skills_for_agent "$agent_key" "$dest_dir"

    if [[ "$agent_key" == "opencode" ]]; then
        install_subagents "$agent_home"
        install_dispatch_script
    fi
done

exit 0

#!/usr/bin/env bash
# Dotfiles deployment script
# Creates symlinks from this repository to target locations
# Supports: --dry-run, --force, --backup modes

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Operation modes
DRY_RUN=false
FORCE=false
BACKUP=false

# Counters for summary
CREATED=0
SKIPPED=0
BACKED_UP=0
ERRORS=0

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Deploy dotfiles by creating symlinks from this repository to target locations.

OPTIONS:
    --dry-run       Show what would be done without making changes
    --force         Overwrite existing files and symlinks
    --backup        Backup existing files before replacing (adds .bak suffix)
    --help          Show this help message

EXAMPLES:
    $(basename "$0") --dry-run          # Preview changes
    $(basename "$0") --backup           # Deploy with backups
    $(basename "$0") --force            # Overwrite everything

EXIT CODES:
    0    Success (all links created or already correct)
    1    Error occurred during deployment

EOF
}

log_info() {
    echo -e "${BLUE}==>${NC} $*"
}

log_success() {
    echo -e "${GREEN}✓${NC} $*"
}

log_skip() {
    echo -e "${YELLOW}→${NC} $*"
}

log_error() {
    echo -e "${RED}✗${NC} $*" >&2
}

log_dry_run() {
    echo -e "${CYAN}[DRY-RUN]${NC} $*"
}

log_detail() {
    echo -e "${GRAY}  $*${NC}"
}

# ============================================================================
# CORE FUNCTIONS
# ============================================================================

# Ensure target directory exists
ensure_dir() {
    local dir="$1"
    
    if [[ -d "$dir" ]]; then
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would create directory: $dir"
        return 0
    fi
    
    if mkdir -p "$dir" 2>/dev/null; then
        log_detail "Created directory: $dir"
        return 0
    else
        log_error "Failed to create directory: $dir"
        return 1
    fi
}

# Backup existing file
backup_file() {
    local target="$1"
    local backup="${target}.bak"
    local counter=1
    
    # Find unique backup name
    while [[ -e "$backup" ]]; do
        backup="${target}.bak.${counter}"
        ((counter++))
    done
    
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would backup: $target → $backup"
        return 0
    fi
    
    if mv "$target" "$backup" 2>/dev/null; then
        log_detail "Backed up: $target → $backup"
        ((BACKED_UP++))
        return 0
    else
        log_error "Failed to backup: $target"
        return 1
    fi
}

# Handle existing target (file, symlink, or directory)
handle_existing_target() {
    local target="$1"
    local source="$2"
    
    # Check if it's already a correct symlink
    if [[ -L "$target" ]]; then
        local current_link
        current_link="$(readlink "$target")"
        
        if [[ "$current_link" == "$source" ]]; then
            log_skip "Already linked: $target"
            ((SKIPPED++))
            return 2  # Special code: already correct
        fi
        
        # It's a symlink but points elsewhere
        if [[ "$FORCE" == true ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                log_dry_run "Would remove incorrect symlink: $target → $current_link"
                return 0
            fi
            rm "$target"
            log_detail "Removed incorrect symlink: $target"
            return 0
        elif [[ "$BACKUP" == true ]]; then
            backup_file "$target"
            return 0
        else
            log_skip "Symlink exists (different target): $target → $current_link"
            log_detail "Use --force to replace or --backup to preserve"
            ((SKIPPED++))
            return 1
        fi
    fi
    
    # It's a regular file or directory
    if [[ -e "$target" ]]; then
        if [[ "$FORCE" == true ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                log_dry_run "Would remove existing: $target"
                return 0
            fi
            rm -rf "$target"
            log_detail "Removed existing: $target"
            return 0
        elif [[ "$BACKUP" == true ]]; then
            backup_file "$target"
            return 0
        else
            log_skip "File exists: $target"
            log_detail "Use --force to replace or --backup to preserve"
            ((SKIPPED++))
            return 1
        fi
    fi
    
    return 0
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    # Ensure parent directory exists
    local target_dir
    target_dir="$(dirname "$target")"
    if ! ensure_dir "$target_dir"; then
        ((ERRORS++))
        return 1
    fi
    
    # Handle existing target
    local ret
    handle_existing_target "$target" "$source" || ret=$?
    if [[ ${ret:-0} -ne 0 ]]; then
        if [[ $ret -eq 2 ]]; then
            return 0  # Already correct, continue
        fi
        return 1  # Skip this file
    fi
    
    # Create the symlink
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would link: $description"
        log_detail "$target → $source"
        return 0
    fi
    
    if ln -s "$source" "$target" 2>/dev/null; then
        log_success "Linked: $description"
        log_detail "$target → $source"
        ((CREATED++))
        return 0
    else
        log_error "Failed to link: $description"
        log_detail "$target → $source"
        ((ERRORS++))
        return 1
    fi
}

# Deploy a single file
deploy_file() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    if [[ ! -e "$source" ]]; then
        log_error "Source not found: $source"
        ((ERRORS++))
        return 1
    fi
    
    create_symlink "$source" "$target" "$description"
}

# Deploy directory (as single symlink)
deploy_directory() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    if [[ ! -d "$source" ]]; then
        log_error "Source directory not found: $source"
        ((ERRORS++))
        return 1
    fi
    
    create_symlink "$source" "$target" "$description"
}

# Deploy multiple files with glob pattern
deploy_glob() {
    local source_pattern="$1"
    local target_dir="$2"
    local description_prefix="$3"
    
    local source_dir
    source_dir="$(dirname "$source_pattern")"
    
    local files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$source_dir" -maxdepth 1 -type f -name "$(basename "$source_pattern")" -print0 | sort -z)
    
    if [[ ${#files[@]} -eq 0 ]]; then
        log_skip "No files found matching: $source_pattern"
        return 0
    fi
    
    for source in "${files[@]}"; do
        local filename
        filename="$(basename "$source")"
        local target="${target_dir}/${filename}"
        deploy_file "$source" "$target" "${description_prefix}${filename}" || true
    done
}

# Deploy scripts with executable permission
deploy_scripts() {
    local source_dir="$1"
    local target_dir="$2"
    
    local scripts=()
    while IFS= read -r -d '' script; do
        scripts+=("$script")
    done < <(find "$source_dir" -maxdepth 1 -type f -name "*.sh" -print0 | sort -z)
    
    if [[ ${#scripts[@]} -eq 0 ]]; then
        log_skip "No scripts found in: $source_dir"
        return 0
    fi
    
    for source in "${scripts[@]}"; do
        local filename
        filename="$(basename "$source")"
        local target="${target_dir}/${filename}"
        
        # Make source executable if not already
        if [[ ! -x "$source" ]] && [[ "$DRY_RUN" == false ]]; then
            chmod +x "$source" 2>/dev/null || true
        fi
        
        deploy_file "$source" "$target" "script: ${filename}"
    done
}

# ============================================================================
# DEPLOYMENT MAPPINGS
# ============================================================================

deploy_all() {
    log_info "Starting dotfiles deployment..."
    echo
    
    # 1. ZSH - Main config
    log_info "Deploying ZSH configuration..."
    deploy_file \
        "$REPO_ROOT/zsh/.zshrc" \
        "$HOME/.zshrc" \
        "zsh: .zshrc" || true
    
    # 2. ZSH - Modular configs
    deploy_glob \
        "$REPO_ROOT/zsh/*.zsh" \
        "$HOME/.config/zsh" \
        "zsh: "
    echo
    
    # 3. Neovim - Entire directory
    log_info "Deploying Neovim configuration..."
    deploy_directory \
        "$REPO_ROOT/nvim" \
        "$HOME/.config/nvim" \
        "nvim: config directory" || true
    echo
    
    # 4. Tmux - Config file
    log_info "Deploying Tmux configuration..."
    deploy_file \
        "$REPO_ROOT/tmux/.tmux.conf" \
        "$HOME/.tmux.conf" \
        "tmux: .tmux.conf" || true
    echo
    
    # 5. Scripts - Executable helpers
    log_info "Deploying helper scripts..."
    deploy_scripts \
        "$REPO_ROOT/scripts" \
        "$HOME/.local/bin"
    echo
    
    # 6. Opencode - Configuration files
    log_info "Deploying Opencode configuration..."
    deploy_file \
        "$REPO_ROOT/opencode/opencode.json" \
        "$HOME/.config/opencode/opencode.json" \
        "opencode: opencode.json" || true
    
    deploy_file \
        "$REPO_ROOT/opencode/oh-my-opencode.json" \
        "$HOME/.config/opencode/oh-my-opencode.json" \
        "opencode: oh-my-opencode.json" || true
    echo
}

# ============================================================================
# VALIDATION
# ============================================================================

validate_environment() {
    # Check we're in the dotfiles repo
    if [[ ! -d "$REPO_ROOT/zsh" ]] || [[ ! -d "$REPO_ROOT/nvim" ]]; then
        log_error "Not in dotfiles repository root"
        log_detail "Expected structure: zsh/, nvim/, tmux/, scripts/, opencode/"
        exit 1
    fi
    
    # Check write permissions for home directory
    if [[ ! -w "$HOME" ]]; then
        log_error "No write permission for home directory: $HOME"
        exit 1
    fi
    
    return 0
}

# ============================================================================
# SUMMARY
# ============================================================================

print_summary() {
    echo
    echo "========================================"
    log_info "Deployment Summary"
    echo "========================================"
    
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${CYAN}Mode: DRY RUN (no changes made)${NC}"
    elif [[ "$FORCE" == true ]]; then
        echo -e "${YELLOW}Mode: FORCE (overwrote existing)${NC}"
    elif [[ "$BACKUP" == true ]]; then
        echo -e "${YELLOW}Mode: BACKUP (preserved existing)${NC}"
    else
        echo -e "Mode: SAFE (skipped existing)"
    fi
    
    echo
    echo -e "${GREEN}Created:${NC}    $CREATED symlinks"
    echo -e "${YELLOW}Skipped:${NC}    $SKIPPED files"
    
    if [[ "$BACKUP" == true ]] && [[ $BACKED_UP -gt 0 ]]; then
        echo -e "${YELLOW}Backed up:${NC}  $BACKED_UP files"
    fi
    
    if [[ $ERRORS -gt 0 ]]; then
        echo -e "${RED}Errors:${NC}     $ERRORS"
        echo
        echo -e "${RED}Deployment completed with errors!${NC}"
        return 1
    else
        echo
        echo -e "${GREEN}✓ Deployment completed successfully!${NC}"
        
        if [[ "$DRY_RUN" == true ]]; then
            echo -e "${CYAN}Run without --dry-run to apply changes${NC}"
        fi
        
        return 0
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            --backup)
                BACKUP=true
                shift
                ;;
            --help|-h)
                print_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                echo
                print_help
                exit 1
                ;;
        esac
    done
    
    # Validate --force and --backup are mutually exclusive
    if [[ "$FORCE" == true ]] && [[ "$BACKUP" == true ]]; then
        log_error "Cannot use --force and --backup together"
        exit 1
    fi
    
    # Validate environment
    validate_environment
    
    # Run deployment
    deploy_all
    
    # Print summary and exit
    if print_summary; then
        exit 0
    else
        exit 1
    fi
}

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

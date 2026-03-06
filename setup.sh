#!/usr/bin/env bash
set -e

# Dotfiles setup script
# Usage: ./setup.sh [aliases|all]
# Remote: curl -fsSL <url>/setup.sh | bash -s -- [aliases|all]
# Set DOTFILES_REPO and DOTFILES_BRANCH for remote install

REPO_URL="${DOTFILES_REPO:-https://github.com/Roman505050/dotfiles}"
REPO_URL="${REPO_URL%.git}"
BRANCH="${DOTFILES_BRANCH:-main}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

# Detect shell config file
get_shell_rc() {
  if [[ -n "$ZSH_VERSION" ]] || [[ -f "$HOME/.zshrc" ]]; then
    echo "$HOME/.zshrc"
  else
    echo "$HOME/.bashrc"
  fi
}

# Add source line to shell rc if not present
add_source() {
  local rc_file="$1"
  local source_line="$2"
  local marker="# dotfiles: $3"

  if [[ ! -f "$rc_file" ]]; then
    touch "$rc_file"
  fi

  if grep -q "$marker" "$rc_file" 2>/dev/null; then
    log_info "Already configured in $rc_file"
    return
  fi

  echo "" >> "$rc_file"
  echo "$marker" >> "$rc_file"
  echo "$source_line" >> "$rc_file"
  log_info "Added to $rc_file"
}

# Install aliases
install_aliases() {
  local rc_file
  rc_file=$(get_shell_rc)
  local aliases_file="$HOME/.config/dotfiles-aliases"

  log_info "Installing aliases..."

  # Try local clone first (when running ./setup.sh from repo)
  local script_dir=""
  if [[ -f "${BASH_SOURCE[0]}" ]] && [[ "${BASH_SOURCE[0]}" == *"setup"* ]]; then
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  elif [[ -f "$0" ]] && [[ "$0" == *"setup"* ]]; then
    script_dir="$(cd "$(dirname "$0")" && pwd)"
  fi
  if [[ -n "$script_dir" ]] && [[ -f "$script_dir/.config/.aliases" ]]; then
    mkdir -p "$(dirname "$aliases_file")"
    cp "$script_dir/.config/.aliases" "$aliases_file"
    log_info "Copied aliases from local repo"
  elif [[ ! -f "$aliases_file" ]]; then
    local base_url="${REPO_URL/github.com/raw.githubusercontent.com}/${BRANCH}"
    log_info "Downloading aliases..."
    mkdir -p "$(dirname "$aliases_file")"
    if command -v curl &>/dev/null; then
      curl -fsSL "$base_url/.config/.aliases" -o "$aliases_file"
    elif command -v wget &>/dev/null; then
      wget -q "$base_url/.config/.aliases" -O "$aliases_file"
    else
      log_error "Need curl or wget to download. Run from cloned repo or install curl/wget."
      exit 1
    fi
  fi

  add_source "$rc_file" "[[ -f $aliases_file ]] && source $aliases_file" "aliases"
  log_info "Aliases installed. Run 'source $rc_file' or open new terminal."
}

# Install all configs
install_all() {
  log_info "Installing all dotfiles..."
  install_aliases
  # Add more install_* functions here as you add configs
  log_info "Done! Run 'source $(get_shell_rc)' or open new terminal."
}

# Show help
show_help() {
  cat << EOF
Dotfiles Setup

Usage:
  setup.sh [command]

Commands:
  aliases    Install shell aliases (Docker, Git, Python, etc.)
  all        Install all configs
  help       Show this help

Remote install:
  curl -fsSL <setup.sh_url> | bash -s -- aliases

EOF
}

# Main
case "${1:-help}" in
  aliases)
    install_aliases
    ;;
  all)
    install_all
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    log_error "Unknown command: $1"
    show_help
    exit 1
    ;;
esac

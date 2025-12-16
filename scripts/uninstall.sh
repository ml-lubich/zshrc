#!/usr/bin/env bash

set -euo pipefail

# Comprehensive uninstall script for zshrc setup
# - Safely removes installed components
# - Restores backups if available
# - Never removes system files or user data
# - Asks for confirmation before destructive operations

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
  printf '[uninstall] %s\n' "$*"
}

err() {
  printf '[uninstall][error] %s\n' "$*" >&2
}

warn() {
  printf '[uninstall][warn] %s\n' "$*" >&2
}

confirm() {
  local prompt="$1"
  local response
  read -p "$prompt (y/N): " response
  case "$response" in
    [yY][eE][sS]|[yY]) return 0 ;;
    *) return 1 ;;
  esac
}

restore_backup() {
  local file="$1"
  local backup_pattern="${file}.pre-mlubich-backup*"
  
  # Find the most recent backup
  local latest_backup
  latest_backup=$(ls -t ${backup_pattern} 2>/dev/null | head -1)
  
  if [ -n "$latest_backup" ] && [ -f "$latest_backup" ]; then
    if confirm "Restore backup for $file?"; then
      log "Restoring $file from $latest_backup"
      cp "$latest_backup" "$file"
      return 0
    fi
  fi
  return 1
}

uninstall_oh_my_zsh() {
  if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    log "Oh My Zsh not found."
    return 0
  fi

  if confirm "Remove Oh My Zsh (~/.oh-my-zsh)?"; then
    rm -rf "${HOME}/.oh-my-zsh"
    log "Oh My Zsh removed."
  else
    log "Skipping Oh My Zsh removal."
  fi
}

uninstall_powerlevel10k() {
  if [ ! -d "${HOME}/.powerlevel10k" ]; then
    log "Powerlevel10k not found."
    return 0
  fi

  if confirm "Remove Powerlevel10k (~/.powerlevel10k)?"; then
    rm -rf "${HOME}/.powerlevel10k"
    log "Powerlevel10k removed."
  else
    log "Skipping Powerlevel10k removal."
  fi
}

uninstall_nvm() {
  if [ ! -d "${HOME}/.nvm" ]; then
    log "NVM not found."
    return 0
  fi

  if confirm "Remove NVM (~/.nvm)?"; then
    rm -rf "${HOME}/.nvm"
    log "NVM removed."
  else
    log "Skipping NVM removal."
  fi
}

uninstall_fonts_macos() {
  local font_dir="$HOME/Library/Fonts"
  local fonts=(
    "MesloLGS NF Regular.ttf"
    "MesloLGS NF Bold.ttf"
    "MesloLGS NF Italic.ttf"
    "MesloLGS NF Bold Italic.ttf"
  )
  
  local found=false
  for font in "${fonts[@]}"; do
    if [ -f "${font_dir}/${font}" ]; then
      found=true
      break
    fi
  done

  if [ "$found" = false ]; then
    log "MesloLGS fonts not found."
    return 0
  fi

  if confirm "Remove MesloLGS NF fonts?"; then
    for font in "${fonts[@]}"; do
      if [ -f "${font_dir}/${font}" ]; then
        rm -f "${font_dir}/${font}"
        log "Removed ${font}"
      fi
    done
    log "MesloLGS fonts removed."
  else
    log "Skipping font removal."
  fi
}

uninstall_fonts_linux() {
  local font_dir="$HOME/.local/share/fonts"
  local fonts=(
    "MesloLGS NF Regular.ttf"
    "MesloLGS NF Bold.ttf"
    "MesloLGS NF Italic.ttf"
    "MesloLGS NF Bold Italic.ttf"
  )
  
  local found=false
  for font in "${fonts[@]}"; do
    if [ -f "${font_dir}/${font}" ]; then
      found=true
      break
    fi
  done

  if [ "$found" = false ]; then
    log "MesloLGS fonts not found."
    return 0
  fi

  if confirm "Remove MesloLGS NF fonts?"; then
    for font in "${fonts[@]}"; do
      if [ -f "${font_dir}/${font}" ]; then
        rm -f "${font_dir}/${font}"
        log "Removed ${font}"
      fi
    done
    if command -v fc-cache >/dev/null 2>&1; then
      fc-cache -f "$font_dir"
    fi
    log "MesloLGS fonts removed."
  else
    log "Skipping font removal."
  fi
}

uninstall_zshrc() {
  if [ ! -f "${HOME}/.zshrc" ]; then
    log ".zshrc not found."
    return 0
  fi

  if ! restore_backup "${HOME}/.zshrc"; then
    if confirm "Remove ~/.zshrc? (No backup found to restore)"; then
      rm -f "${HOME}/.zshrc"
      log ".zshrc removed."
    else
      log "Keeping .zshrc"
    fi
  fi
}

uninstall_p10k_config() {
  if [ ! -f "${HOME}/.p10k.zsh" ]; then
    log ".p10k.zsh not found."
    return 0
  fi

  if ! restore_backup "${HOME}/.p10k.zsh"; then
    if confirm "Remove ~/.p10k.zsh? (No backup found to restore)"; then
      rm -f "${HOME}/.p10k.zsh"
      log ".p10k.zsh removed."
    else
      log "Keeping .p10k.zsh"
    fi
  fi
}

uninstall_homebrew_packages() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Homebrew not found. Skipping package removal."
    return 0
  fi

  local packages=(
    "fzf"
    "autojump"
    "eza"
    "bat"
    "thefuck"
    "lazygit"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
  )

  if confirm "Uninstall Homebrew packages installed by this setup?"; then
    for package in "${packages[@]}"; do
      if brew list "$package" >/dev/null 2>&1; then
        log "Uninstalling $package..."
        brew uninstall "$package" || warn "Failed to uninstall $package"
      fi
    done
    log "Homebrew packages uninstalled."
  else
    log "Skipping Homebrew package removal."
  fi
}

main() {
  log "Starting uninstall process..."
  log "This will remove components installed by the zshrc setup script."
  log "Your backups will be preserved and can be restored."
  echo ""

  if ! confirm "Continue with uninstall?"; then
    log "Uninstall cancelled."
    exit 0
  fi

  local os
  case "$(uname -s)" in
    Darwin)  os="macos" ;;
    Linux)   os="linux" ;;
    *)       os="unknown" ;;
  esac

  uninstall_zshrc
  uninstall_p10k_config
  uninstall_oh_my_zsh
  uninstall_powerlevel10k
  uninstall_nvm
  
  if [ "$os" = "macos" ]; then
    uninstall_fonts_macos
  elif [ "$os" = "linux" ]; then
    uninstall_fonts_linux
  fi

  uninstall_homebrew_packages

  cat <<'EOF'

=====================================================
✅ Uninstall complete!

📝 Note: The following were NOT removed (by design):
  - Homebrew itself (you may want to keep it)
  - iTerm2 (macOS terminal app)
  - Xcode Command Line Tools (macOS)
  - Python installations
  - Node.js installations (via NVM, if you kept NVM)
  - System files or other user data

🔄 To restore your previous configuration:
  - Check for backup files: ~/.zshrc.pre-mlubich-backup-*
  - Restore manually: cp ~/.zshrc.pre-mlubich-backup-* ~/.zshrc

📖 To reinstall, run: ./scripts/install.sh
=====================================================
EOF
}

main "$@"

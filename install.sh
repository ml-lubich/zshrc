#!/usr/bin/env bash

set -euo pipefail

# Simple cross‑platform Zsh + Powerlevel10k bootstrap for macOS and Linux.
# - Installs Homebrew (or Linuxbrew) if missing
# - Installs latest stable Python from the system package manager / Homebrew
# - Installs MesloLGS Nerd Fonts required for Powerlevel10k
# - Installs Powerlevel10k
# - Backs up any existing ~/.zshrc and replaces it with the one from this repo
# - Optionally installs Oh My Zsh (recommended for P10k)
#
# This script is intentionally minimal and explicit:
#  - No silent fallbacks
#  - Logs every major action

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
  printf '[setup] %s\n' "$*"
}

err() {
  printf '[setup][error] %s\n' "$*" >&2
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    err "Required command '$1' not found. Please install it and re-run."
    exit 1
  fi
}

detect_os() {
  case "$(uname -s)" in
    Darwin)  echo "macos" ;;
    Linux)   echo "linux" ;;
    *)       err "Unsupported OS: $(uname -s)"; exit 1 ;;
  esac
}

install_homebrew_macos() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew already installed."
    return 0
  fi

  log "Installing Homebrew for macOS..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_homebrew_linux() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew (Linuxbrew) already installed."
    return 0
  fi

  log "Installing Homebrew (Linuxbrew)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

ensure_brew_in_path() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  # Default Homebrew locations
  if [ -d "/opt/homebrew/bin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -d "/usr/local/Homebrew/bin" ]; then
    eval "$(/usr/local/Homebrew/bin/brew shellenv)"
  elif [ -d "$HOME/.linuxbrew/bin" ]; then
    eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
  fi

  if ! command -v brew >/dev/null 2>&1; then
    err "Homebrew appears to be installed but is not in PATH. Please add it manually and re-run."
    exit 1
  fi
}

install_python_latest() {
  if command -v python3 >/dev/null 2>&1 && python3 --version | grep -q "Python 3\.[0-9]"; then
    log "Python already installed: $(python3 --version)"
    return 0
  fi
  log "Installing latest Python via Homebrew..."
  brew install python || {
    err "Failed to install Python via Homebrew."
    exit 1
  }
}

install_dev_tools() {
  log "Installing development tools via Homebrew..."
  
  local tools=(
    "fzf"
    "autojump"
    "eza"
    "bat"
    "thefuck"
    "lazygit"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
  )
  
  for tool in "${tools[@]}"; do
    if brew list "$tool" >/dev/null 2>&1; then
      log "$tool already installed."
    else
      log "Installing $tool..."
      brew install "$tool" || {
        err "Failed to install $tool"
        exit 1
      }
    fi
  done
  
  # Install fzf key bindings
  if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    log "Setting up fzf key bindings..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc || true
  fi
}

install_nvm() {
  if [ -d "${HOME}/.nvm" ]; then
    log "NVM already installed."
    return 0
  fi
  
  log "Installing NVM (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || {
    err "Failed to install NVM."
    exit 1
  }
}

install_zsh_and_git_linux() {
  if command -v zsh >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
    log "zsh and git already installed on Linux."
    return 0
  fi

  if command -v apt-get >/dev/null 2>&1; then
    log "Installing zsh and git via apt-get..."
    sudo apt-get update
    sudo apt-get install -y zsh git curl
  elif command -v dnf >/dev/null 2>&1; then
    log "Installing zsh and git via dnf..."
    sudo dnf install -y zsh git curl
  elif command -v yum >/dev/null 2>&1; then
    log "Installing zsh and git via yum..."
    sudo yum install -y zsh git curl
  else
    err "Could not detect package manager to install zsh/git. Please install them manually."
    exit 1
  fi
}

install_meslo_fonts_macos() {
  log "Installing MesloLGS Nerd Fonts (macOS)..."
  local font_dir="$HOME/Library/Fonts"
  mkdir -p "$font_dir"

  # Official MesloLGS NF release from Powerlevel10k docs
  base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
  for font in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
    local url="${base_url}/MesloLGS%20NF%20${font#MesloLGS NF }"
    local dest="${font_dir}/${font}"
    if [ -f "$dest" ]; then
      log "Font already present: $dest"
      continue
    fi
    log "Downloading $font..."
    curl -fsSL -o "$dest" "$url" || {
      err "Failed to download font: $font"
      exit 1
    }
  done

  log "MesloLGS Nerd Fonts installed. You may need to restart your terminal."
}

install_meslo_fonts_linux() {
  log "Installing MesloLGS Nerd Fonts (Linux)..."
  local font_dir="$HOME/.local/share/fonts"
  mkdir -p "$font_dir"

  base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
  for font in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
    local url="${base_url}/MesloLGS%20NF%20${font#MesloLGS NF }"
    local dest="${font_dir}/${font}"
    if [ -f "$dest" ]; then
      log "Font already present: $dest"
      continue
    fi
    log "Downloading $font..."
    curl -fsSL -o "$dest" "$url" || {
      err "Failed to download font: $font"
      exit 1
    }
  done

  log "Refreshing font cache..."
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$font_dir"
  fi

  log "MesloLGS Nerd Fonts installed. Configure your terminal to use a MesloLGS NF font."
}

install_powerlevel10k() {
  if [ -d "${HOME}/.powerlevel10k" ]; then
    log "Powerlevel10k already present in ~/.powerlevel10k."
    return 0
  fi
  log "Installing Powerlevel10k theme into ~/.powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/.powerlevel10k"
}

install_oh_my_zsh() {
  if [ -d "${HOME}/.oh-my-zsh" ]; then
    log "Oh My Zsh already installed."
    return 0
  fi

  log "Installing Oh My Zsh (non-interactive)..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

configure_zshrc() {
  local target="${HOME}/.zshrc"

  if [ -f "$target" ] && [ ! -f "${target}.pre-mlubich-backup" ]; then
    log "Backing up existing ~/.zshrc to ~/.zshrc.pre-mlubich-backup"
    cp "$target" "${target}.pre-mlubich-backup"
  fi

  if [ -f "${REPO_DIR}/zshrc" ]; then
    log "Copying repo zshrc to ~/.zshrc"
    cp "${REPO_DIR}/zshrc" "$target"
  else
    log "Repo zshrc not found; generating a minimal ~/.zshrc that loads Powerlevel10k."
    cat >"$target" <<'EOF'
# ~/.zshrc generated by ml-lubich zshrc bootstrap

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

if [ -d "$ZSH" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

[[ -r "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"
EOF
  fi
}

configure_p10k_config() {
  local target="${HOME}/.p10k.zsh"

  if [ -f "$target" ]; then
    log "~/.p10k.zsh already exists; leaving it untouched."
    return 0
  fi

  if [ -f "${REPO_DIR}/p10k.zsh" ]; then
    log "Copying repo p10k.zsh to ~/.p10k.zsh"
    cp "${REPO_DIR}/p10k.zsh" "$target"
  else
    log "No p10k.zsh in repo. A default Powerlevel10k config will be generated when you run 'p10k configure'."
  fi
}

set_default_shell_to_zsh() {
  if [ "${SHELL:-}" = "$(command -v zsh)" ]; then
    log "zsh is already the default shell."
    return 0
  fi

  if command -v zsh >/dev/null 2>&1; then
    log "Changing default shell to zsh (you may be prompted for your password)..."
    chsh -s "$(command -v zsh)" || {
      err "Failed to change default shell to zsh. You can run 'chsh -s \"$(command -v zsh)\"' manually."
    }
  else
    err "zsh is not installed; cannot set as default shell."
  fi
}

main() {
  require_cmd curl
  require_cmd git

  local os
  os="$(detect_os)"
  log "Detected OS: ${os}"

  if [ "$os" = "macos" ]; then
    install_homebrew_macos
    ensure_brew_in_path
    install_python_latest
    install_dev_tools
    install_meslo_fonts_macos
  else
    install_zsh_and_git_linux
    install_homebrew_linux
    ensure_brew_in_path
    install_python_latest
    install_dev_tools
    install_meslo_fonts_linux
  fi

  install_oh_my_zsh
  install_powerlevel10k
  install_nvm
  configure_zshrc
  configure_p10k_config
  set_default_shell_to_zsh

  cat <<'EOF'

=====================================================
✅ Bootstrap complete!

📋 Next steps:
  1. Close this terminal and open a NEW one (or run: source ~/.zshrc)
  2. Configure your terminal/editor to use "MesloLGS NF" font:
     - Terminal: Preferences → Profiles → Text → Font → MesloLGS NF
     - VS Code: Settings → Terminal Font → "MesloLGS NF"
     - iTerm2: Preferences → Profiles → Text → Font → MesloLGS NF
  3. Your Powerlevel10k config is already installed from this repo.
     If you want to reconfigure, run: p10k configure

🔧 Installed tools:
  - Homebrew (package manager)
  - Python (latest)
  - Oh My Zsh (zsh framework)
  - Powerlevel10k (prompt theme)
  - MesloLGS NF fonts (required for icons)
  - fzf (fuzzy finder)
  - autojump (smart directory navigation)
  - eza (better ls)
  - bat (better cat)
  - thefuck (typo corrector - type 'fuck' or 'f' after a typo)
  - lazygit (git TUI)
  - zsh-autosuggestions (auto-complete)
  - zsh-syntax-highlighting (syntax highlighting)
  - NVM (Node Version Manager)

💡 Custom commands:
  - mygit [project] - Navigate to ~/Desktop/git/[project]
  - mygit -n [project] - Create new project and open in VS Code
  - f / fuck - Fix last command typo
  - lg - Open lazygit
  - ls / ll / tree - Use eza instead of ls

🔄 If something looks off, restore your previous config from:
  ~/.zshrc.pre-mlubich-backup

📖 See README.md for detailed setup instructions.
=====================================================
EOF
}

main "$@"




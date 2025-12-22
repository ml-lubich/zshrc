#!/usr/bin/env bash

set -euo pipefail

# Comprehensive cross-platform Zsh + Powerlevel10k bootstrap for macOS and Linux.
# - Installs Homebrew (or Linuxbrew) if missing
# - Installs Xcode Command Line Tools (macOS)
# - Installs iTerm2 (macOS, optional)
# - Installs Python (latest stable or specified version)
# - Installs Node.js via NVM (latest LTS or specified version)
# - Installs MesloLGS Nerd Fonts required for Powerlevel10k
# - Installs Powerlevel10k
# - Installs Oh My Zsh (recommended for P10k)
# - Copies this repo's zsh configuration to ~/.zshrc (with backup)
# - Copies this repo's p10k.zsh to ~/.p10k.zsh (only if it doesn't exist)
# - Backs up existing configurations before modification
#
# This script is configurable via config.sh or environment variables
# See config.sh for all available options

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source configuration if it exists (from scripts directory)
[ -f "${SCRIPT_DIR}/config.sh" ] && source "${SCRIPT_DIR}/config.sh"

# Set defaults if not set by config.sh
PYTHON_VERSION="${PYTHON_VERSION:-latest}"
NODE_VERSION="${NODE_VERSION:-lts}"
INSTALL_ITERM2="${INSTALL_ITERM2:-true}"
INSTALL_XCODE_TOOLS="${INSTALL_XCODE_TOOLS:-true}"
BACKUP_EXISTING="${BACKUP_EXISTING:-true}"
INSTALL_DEV_TOOLS="${INSTALL_DEV_TOOLS:-true}"
INSTALL_OH_MY_ZSH="${INSTALL_OH_MY_ZSH:-true}"
INSTALL_POWERLEVEL10K="${INSTALL_POWERLEVEL10K:-true}"
INSTALL_FONTS="${INSTALL_FONTS:-true}"
INSTALL_NVM="${INSTALL_NVM:-true}"
SET_DEFAULT_SHELL="${SET_DEFAULT_SHELL:-true}"

log() {
  printf '[setup] %s\n' "$*"
}

err() {
  printf '[setup][error] %s\n' "$*" >&2
}

warn() {
  printf '[setup][warning] %s\n' "$*" >&2
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

detect_linux_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "${ID:-unknown}"
  elif [ -f /etc/redhat-release ]; then
    echo "rhel"
  else
    echo "unknown"
  fi
}

install_xcode_tools() {
  if [ "$INSTALL_XCODE_TOOLS" != "true" ]; then
    log "Skipping Xcode Command Line Tools installation (INSTALL_XCODE_TOOLS=false)"
    return 0
  fi

  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools already installed."
    return 0
  fi

  log "Installing Xcode Command Line Tools..."
  log "This may take several minutes. You may be prompted to accept a license agreement."
  xcode-select --install || {
    if [ $? -eq 1 ]; then
      log "Xcode Command Line Tools installation already in progress or completed."
    else
      err "Failed to install Xcode Command Line Tools."
      exit 1
    fi
  }
  
  # Wait for installation to complete
  log "Waiting for Xcode Command Line Tools installation to complete..."
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
  log "Xcode Command Line Tools installed successfully."
}

install_iterm2() {
  if [ "$INSTALL_ITERM2" != "true" ]; then
    log "Skipping iTerm2 installation (INSTALL_ITERM2=false)"
    return 0
  fi

  if [ -d "/Applications/iTerm.app" ]; then
    log "iTerm2 already installed."
    return 0
  fi

  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew not found. Cannot install iTerm2 via Homebrew."
    warn "You can install iTerm2 manually from: https://iterm2.com/"
    return 0
  fi

  log "Installing iTerm2 via Homebrew Cask..."
  brew install --cask iterm2 || {
    err "Failed to install iTerm2."
    exit 1
  }
  log "iTerm2 installed successfully."
  log "You can launch iTerm2 from Applications or by running: open -a iTerm"
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
  # Install prerequisites
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y build-essential curl file git
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y curl file git
  elif command -v yum >/dev/null 2>&1; then
    sudo yum groupinstall -y "Development Tools"
    sudo yum install -y curl file git
  fi

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

install_python() {
  local python_version="$1"
  
  # Check if Python 3 is already installed
  if command -v python3 >/dev/null 2>&1; then
    local current_version
    current_version=$(python3 --version 2>&1 | grep -oE "Python 3\.[0-9]+" || echo "")
    if [ -n "$current_version" ]; then
      log "Python already installed: $current_version"
      
      # If specific version requested, check if it matches
      if [ "$python_version" != "latest" ]; then
        if echo "$current_version" | grep -q "Python $python_version"; then
          log "Requested Python version $python_version is already installed."
          return 0
        else
          log "Python $python_version requested, but $current_version is installed."
          log "Installing Python $python_version via Homebrew..."
        fi
      else
        return 0
      fi
    fi
  fi

  if ! command -v brew >/dev/null 2>&1; then
    err "Homebrew required to install Python. Please install Homebrew first."
    exit 1
  fi

  if [ "$python_version" = "latest" ]; then
    log "Installing latest stable Python via Homebrew..."
    brew install python || {
      err "Failed to install Python via Homebrew."
      exit 1
    }
  else
    log "Installing Python $python_version via Homebrew..."
    brew install "python@${python_version}" || {
      err "Failed to install Python $python_version via Homebrew."
      exit 1
    }
  fi
}

install_nvm() {
  if [ "$INSTALL_NVM" != "true" ]; then
    log "Skipping NVM installation (INSTALL_NVM=false)"
    return 0
  fi

  if [ -d "${HOME}/.nvm" ]; then
    log "NVM already installed."
    return 0
  fi
  
  log "Installing NVM (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || {
    err "Failed to install NVM."
    exit 1
  }
  
  # Source NVM to install Node.js
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  if [ -n "$NODE_VERSION" ]; then
    log "Installing Node.js ${NODE_VERSION} via NVM..."
    if [ "$NODE_VERSION" = "latest" ] || [ "$NODE_VERSION" = "lts" ]; then
      nvm install --lts || {
        err "Failed to install Node.js LTS via NVM."
        exit 1
      }
      nvm use --lts
      nvm alias default lts/*
    else
      nvm install "$NODE_VERSION" || {
        err "Failed to install Node.js ${NODE_VERSION} via NVM."
        exit 1
      }
      nvm use "$NODE_VERSION"
      nvm alias default "$NODE_VERSION"
    fi
    
    log "Node.js installed: $(node --version 2>/dev/null || echo 'version check failed')"
    log "npm installed: $(npm --version 2>/dev/null || echo 'version check failed')"
  fi
}

install_dev_tools() {
  if [ "$INSTALL_DEV_TOOLS" != "true" ]; then
    log "Skipping development tools installation (INSTALL_DEV_TOOLS=false)"
    return 0
  fi

  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew not found. Cannot install development tools."
    return 0
  fi

  log "Installing development tools via Homebrew..."
  
  local tools=(
    "fzf"
    "ripgrep"
    "fd"
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

install_zsh_and_git_linux() {
  if command -v zsh >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
    log "zsh and git already installed on Linux."
    return 0
  fi

  local distro
  distro="$(detect_linux_distro)"

  case "$distro" in
    ubuntu|debian)
      log "Installing zsh and git via apt-get..."
      sudo apt-get update
      sudo apt-get install -y zsh git curl build-essential
      ;;
    fedora|rhel|centos)
      if command -v dnf >/dev/null 2>&1; then
        log "Installing zsh and git via dnf..."
        sudo dnf install -y zsh git curl
      elif command -v yum >/dev/null 2>&1; then
        log "Installing zsh and git via yum..."
        sudo yum install -y zsh git curl
      fi
      ;;
    *)
      err "Unsupported Linux distribution: $distro"
      err "Please install zsh and git manually and re-run."
      exit 1
      ;;
  esac
}

install_dev_tools_linux() {
  if [ "$INSTALL_DEV_TOOLS" != "true" ]; then
    log "Skipping development tools installation (INSTALL_DEV_TOOLS=false)"
    return 0
  fi

  log "Installing development tools on Linux..."
  
  local distro
  distro="$(detect_linux_distro)"
  
  # Install system packages (ripgrep, fd, bat) via package manager
  case "$distro" in
    ubuntu|debian)
      log "Installing ripgrep, fd, and bat via apt-get..."
      sudo apt-get update
      sudo apt-get install -y ripgrep bat || warn "Some packages may not be available via apt"
      # On Ubuntu/Debian, fd is called fdfind
      if ! command -v fd >/dev/null 2>&1; then
        if sudo apt-get install -y fd-find 2>/dev/null; then
          log "Creating fd symlink for fdfind..."
          sudo ln -sf "$(which fdfind)" /usr/local/bin/fd || true
        fi
      fi
      ;;
    fedora|rhel|centos)
      if command -v dnf >/dev/null 2>&1; then
        log "Installing ripgrep, fd, and bat via dnf..."
        sudo dnf install -y ripgrep fd-find bat || warn "Some packages may not be available via dnf"
      elif command -v yum >/dev/null 2>&1; then
        log "Installing ripgrep, fd, and bat via yum..."
        sudo yum install -y ripgrep fd-find bat || warn "Some packages may not be available via yum"
      fi
      ;;
  esac
  
  # Install remaining tools via Homebrew (Linuxbrew) if available
  if command -v brew >/dev/null 2>&1; then
    log "Installing additional tools via Homebrew..."
    local brew_tools=(
      "fzf"
      "autojump"
      "eza"
      "thefuck"
      "lazygit"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
    )
    
    for tool in "${brew_tools[@]}"; do
      if brew list "$tool" >/dev/null 2>&1; then
        log "$tool already installed via Homebrew."
      else
        log "Installing $tool via Homebrew..."
        brew install "$tool" || {
          warn "Failed to install $tool via Homebrew. Continuing..."
        }
      fi
    done
    
    # Install fzf key bindings
    if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
      log "Setting up fzf key bindings..."
      "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc || true
    fi
  else
    warn "Homebrew not available. Some tools (fzf, autojump, eza, etc.) may not be installed."
    warn "Consider installing Homebrew (Linuxbrew) for full tool support."
  fi
}

install_meslo_fonts_macos() {
  if [ "$INSTALL_FONTS" != "true" ]; then
    log "Skipping font installation (INSTALL_FONTS=false)"
    return 0
  fi

  log "Installing MesloLGS Nerd Fonts (macOS)..."
  local font_dir="$HOME/Library/Fonts"
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

  log "MesloLGS Nerd Fonts installed. You may need to restart your terminal."
}

install_meslo_fonts_linux() {
  if [ "$INSTALL_FONTS" != "true" ]; then
    log "Skipping font installation (INSTALL_FONTS=false)"
    return 0
  fi

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
  if [ "$INSTALL_POWERLEVEL10K" != "true" ]; then
    log "Skipping Powerlevel10k installation (INSTALL_POWERLEVEL10K=false)"
    return 0
  fi

  if [ -d "${HOME}/.powerlevel10k" ]; then
    log "Powerlevel10k already present in ~/.powerlevel10k. Updating..."
    # Update if it's a git repo, otherwise leave it alone
    if [ -d "${HOME}/.powerlevel10k/.git" ]; then
      (cd "${HOME}/.powerlevel10k" && git pull --depth=1 || log "Could not update Powerlevel10k (this is OK)")
    fi
    return 0
  fi
  log "Installing Powerlevel10k theme into ~/.powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/.powerlevel10k"
}

install_oh_my_zsh() {
  if [ "$INSTALL_OH_MY_ZSH" != "true" ]; then
    log "Skipping Oh My Zsh installation (INSTALL_OH_MY_ZSH=false)"
    return 0
  fi

  if [ -d "${HOME}/.oh-my-zsh" ]; then
    log "Oh My Zsh already installed."
    return 0
  fi

  log "Installing Oh My Zsh (non-interactive)..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

configure_zshrc() {
  local target="${HOME}/.zshrc"

  if [ "$BACKUP_EXISTING" = "true" ] && [ -f "$target" ] && [ ! -f "${target}.pre-mlubich-backup" ]; then
    log "Backing up existing ~/.zshrc to ~/.zshrc.pre-mlubich-backup"
    cp "$target" "${target}.pre-mlubich-backup"
  fi

  if [ -f "${REPO_DIR}/zshrc" ]; then
    # Check if files are identical (for idempotency)
    if [ -f "$target" ] && cmp -s "${REPO_DIR}/zshrc" "$target" 2>/dev/null; then
      log "~/.zshrc is already up to date."
      return 0
    fi
    log "Updating ~/.zshrc from repo"
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

  # Only update if repo file exists and target doesn't, or if user explicitly wants updates
  if [ -f "$target" ]; then
    # If repo file exists and differs, log but don't overwrite (user may have customized)
    if [ -f "${REPO_DIR}/p10k.zsh" ]; then
      if ! cmp -s "${REPO_DIR}/p10k.zsh" "$target" 2>/dev/null; then
        log "~/.p10k.zsh already exists and differs from repo version."
        log "Keeping existing config. To update, remove ~/.p10k.zsh and run install.sh again."
      else
        log "~/.p10k.zsh is already up to date."
      fi
    else
      log "~/.p10k.zsh already exists; leaving it untouched."
    fi
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
  if [ "$SET_DEFAULT_SHELL" != "true" ]; then
    log "Skipping default shell change (SET_DEFAULT_SHELL=false)"
    return 0
  fi

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
  log "Starting installation with configuration:"
  log "  PYTHON_VERSION=${PYTHON_VERSION}"
  log "  NODE_VERSION=${NODE_VERSION}"
  log "  INSTALL_ITERM2=${INSTALL_ITERM2}"
  log "  INSTALL_XCODE_TOOLS=${INSTALL_XCODE_TOOLS}"
  log ""

  if [ "$os" = "macos" ]; then
    install_xcode_tools
    install_homebrew_macos
    ensure_brew_in_path
    install_iterm2
    install_python "$PYTHON_VERSION"
    install_dev_tools
    install_meslo_fonts_macos
  else
    install_zsh_and_git_linux
    install_homebrew_linux
    ensure_brew_in_path
    install_python "$PYTHON_VERSION"
    install_dev_tools_linux
    install_meslo_fonts_linux
  fi

  if [ "$INSTALL_OH_MY_ZSH" = "true" ]; then
    install_oh_my_zsh
  fi
  
  if [ "$INSTALL_POWERLEVEL10K" = "true" ]; then
    install_powerlevel10k
  fi
  
  if [ "$INSTALL_NVM" = "true" ]; then
    install_nvm
  fi
  
  configure_zshrc
  configure_p10k_config
  
  if [ "$SET_DEFAULT_SHELL" = "true" ]; then
    set_default_shell_to_zsh
  fi

  cat <<EOF

=====================================================
✅ Bootstrap complete!

📋 Next steps:
  1. Close this terminal and open a NEW one (or run: source ~/.zshrc)
  2. Configure your terminal/editor to use "MesloLGS NF" font:
     - Terminal: Preferences → Profiles → Text → Font → MesloLGS NF
     - VS Code: Settings → Terminal Font → "MesloLGS NF"
     - iTerm2: Preferences → Profiles → Text → Font → MesloLGS NF
     - Cursor IDE: Settings → Terminal Font → "MesloLGS NF"
  3. Your Powerlevel10k config is already installed from this repo.
     If you want to reconfigure, run: p10k configure

🔧 Installed tools:
  - Homebrew (package manager)
  - Python ($(python3 --version 2>/dev/null || echo 'version check failed'))
  - Node.js ($(node --version 2>/dev/null || echo 'not installed'))
  - npm ($(npm --version 2>/dev/null || echo 'not installed'))
  - Oh My Zsh (zsh framework)
  - Powerlevel10k (prompt theme)
  - MesloLGS NF fonts (required for icons)
  - fzf (fuzzy finder with ripgrep and fd integration)
  - ripgrep (fast text search - used by fzf)
  - fd (fast file finder - used by fzf)
  - autojump (smart directory navigation)
  - eza (better ls)
  - bat (better cat)
  - thefuck (typo corrector - type 'fuck' or 'f' after a typo)
  - lazygit (git TUI)
  - zsh-autosuggestions (auto-complete)
  - zsh-syntax-highlighting (syntax highlighting)
  - NVM (Node Version Manager)
EOF

  if [ "$os" = "macos" ] && [ "$INSTALL_ITERM2" = "true" ]; then
    cat <<EOF
  - iTerm2 (terminal emulator)
EOF
  fi

  cat <<EOF

💡 Custom commands:
  - mygit [project] - Navigate to ~/Desktop/git/[project]
  - mygit -n [project] - Create new project and open in VS Code
  - f / fuck - Fix last command typo
  - lg - Open lazygit
  - ls / ll / tree - Use eza instead of ls

🔄 If something looks off, restore your previous config from:
  ~/.zshrc.pre-mlubich-backup

📖 See README.md for detailed setup instructions.

🔧 To customize installation, edit config.sh or set environment variables:
  PYTHON_VERSION=3.10 ./install.sh
  INSTALL_ITERM2=false ./install.sh

🔄 To uninstall, run: ./uninstall.sh
=====================================================
EOF
}

main "$@"

# ==============================================================================
# 1. INSTANT PROMPT & HOMEBREW (Must be first)
# ==============================================================================

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set Homebrew path (supports both Apple Silicon and Intel Macs, plus Linux)
if [ -d "/opt/homebrew/bin" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
elif [ -d "/usr/local/bin" ]; then
  export PATH="/usr/local/bin:$PATH"
elif [ -d "$HOME/.linuxbrew/bin" ]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
fi

# ==============================================================================
# 2. OH MY ZSH CONFIGURATION
# ==============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
# Added 'colored-man-pages' (colorizes manual pages)
# Added 'web-search' (allows typing 'google something' in terminal)
# Added 'extract' (unzip/untar anything with command 'x filename')
plugins=(
  git
  z
  fzf
  colored-man-pages
  web-search
  extract
)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 3. EXTERNAL PLUGINS (Homebrew-installed)
# ==============================================================================

# Source zsh-autosuggestions (from Homebrew)
# Support both Apple Silicon and Intel Macs
if [ -f /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/local/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f "$(brew --prefix)/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Source zsh-syntax-highlighting (from Homebrew) - Must be sourced LAST among plugins
# Support both Apple Silicon and Intel Macs
if [ -f /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/local/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/local/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f "$(brew --prefix)/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$(brew --prefix)/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enhanced FZF configuration with ripgrep and fd
# Use fd (or fdfind on Ubuntu) for file finding
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v fdfind >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Use ripgrep for content search
if command -v rg >/dev/null 2>&1; then
  if command -v bat >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --preview "bat --style=numbers --color=always --line-range :500 {}"'
  else
    export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'
  fi
  export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window down:3:hidden:wrap --bind "?:toggle-preview"'
fi

# FZF aliases for common workflows
# Search file names (bat preview only when bat is installed)
if command -v bat >/dev/null 2>&1; then
  alias ff='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
else
  alias ff='fzf'
fi

# Search file content with ripgrep + fzf
# Usage: rgg "search term"
rgg() {
  if [ -z "$1" ]; then
    echo "Usage: rgg <search-term>"
    return 1
  fi
  local preview_cmd
  if command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --style=numbers --color=always --highlight-line {2} {1} --line-range $(( {2}-30 )):$(( {2}+30 ))'
  else
    preview_cmd='sed -n "{2}p" {1}'
  fi
  rg --line-number --no-heading --smart-case "$1" . | \
    fzf --delimiter : \
        --preview "$preview_cmd" \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
}

# ==============================================================================
# 4. SETTINGS (History, Vim, Completion)
# ==============================================================================

# Enable Vim keybindings
bindkey -v

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history

# Auto-correction and completion
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Disable dirty check for faster Git operations
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Zsh completion settings
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select

# ==============================================================================
# 5. ALIASES & FUNCTIONS
# ==============================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Git Aliases
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gco='git checkout'
alias gl='git pull'
alias gcb='git checkout -b'
alias gpush='git push origin $(git_current_branch)'

# Custom Functions
# mygit: Generalizable project navigation function
# Set MYGIT_PROJECTS_DIR to customize the projects directory (default: ~/dev)
export MYGIT_PROJECTS_DIR="${MYGIT_PROJECTS_DIR:-$HOME/dev}"
export MYGIT_EDITOR="${MYGIT_EDITOR:-code}"

mygit() {
  # 1. If no arguments, go to root projects folder
  if [ -z "$1" ]; then
    mkdir -p "$MYGIT_PROJECTS_DIR"
    cd "$MYGIT_PROJECTS_DIR"
    return
  fi

  # 2. Check for new project flag (-n)
  if [ "$1" = "-n" ]; then
    shift # Remove the -n so $1 becomes the project name
    
    if [ -z "$1" ]; then
      echo "Error: Please provide a name (e.g., mygit -n new-app)"
      return 1
    fi

    local project_path="$MYGIT_PROJECTS_DIR/$1"
    echo "Creating new project: $1"
    mkdir -p "$project_path"
    cd "$project_path"
    echo "Opening in IDE..."
    $MYGIT_EDITOR . 2>/dev/null || {
      echo "Editor '$MYGIT_EDITOR' not found. Set MYGIT_EDITOR to your preferred editor."
    }
    return
  fi

  # 3. Standard Mode: Open EXISTING project
  local project_path="$MYGIT_PROJECTS_DIR/$1"
  
  if [ -d "$project_path" ]; then
    cd "$project_path"
    echo "Opening in IDE..."
    $MYGIT_EDITOR . 2>/dev/null || {
      echo "Editor '$MYGIT_EDITOR' not found. Set MYGIT_EDITOR to your preferred editor."
    }
  else
    echo "Project '$1' not found."
    echo "Did you mean to create it? Use: mygit -n $1"
  fi
}

# --- Autocomplete Logic ---
# TAB will autocomplete folder names from inside MYGIT_PROJECTS_DIR
_mygit() {
  _files -W "$MYGIT_PROJECTS_DIR" -/
}
compdef _mygit mygit

# ==============================================================================
# 6. ENVIRONMENT VARIABLES & PATHS (Crucial Section)
# ==============================================================================

# a) NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# b) Custom & Third Party Tools
# Add machine-specific paths in ~/.zshrc.local instead of here.
export PATH="$HOME/.local/bin:$PATH"

# ==============================================================================
# 7. THEME CONFIGURATION (Must be last)
# ==============================================================================

# Add virtualenv support to P10k
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(virtualenv)

# Source Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
# 8. MODERN TOOLS & UPGRADES (Requires: brew install eza bat thefuck lazygit)
# ==============================================================================

# 1. 'eza' (Better ls)
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --git'
  alias ll='eza -l -a --icons --git --group-directories-first'
  alias tree='eza --tree --icons'
else
  alias ll='ls -lah'
fi

# 2. 'bat' (Better cat)
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# 3. 'thefuck' (Typo corrector)
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
  alias f='fuck'
fi

# 4. 'lazygit' (Git UI)
if command -v lazygit >/dev/null 2>&1; then
  alias lg='lazygit'
fi

# User-local overrides (never overwritten by install)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local


# ==============================================================================
# 1. INSTANT PROMPT & HOMEBREW (Must be first)
# ==============================================================================

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set Homebrew path for Apple Silicon
export PATH="/opt/homebrew/bin:$PATH"

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
  autojump 
  colored-man-pages 
  web-search 
  extract
)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 3. EXTERNAL PLUGINS (Homebrew-installed)
# ==============================================================================

# Source zsh-autosuggestions (from Homebrew)
if [ -f /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Source zsh-syntax-highlighting (from Homebrew) - Must be sourced LAST among plugins
if [ -f /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
alias ll='ls -lah'

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
mygit() {
  # 1. If no arguments, go to root git folder
  if [ -z "$1" ]; then
    cd ~/Desktop/git
    return
  fi

  # 2. Check for new project flag (-n)
  if [ "$1" = "-n" ]; then
    shift # Remove the -n so $1 becomes the project name
    
    if [ -z "$1" ]; then
      echo "❌ Error: Please provide a name (e.g., mygit -n new-app)"
      return 1
    fi

    local project_path="$HOME/Desktop/git/$1"
    echo "🆕 Creating new project: $1"
    mkdir -p "$project_path"
    cd "$project_path"
    echo "🚀 Opening in IDE..."
    code .
    return
  fi

  # 3. Standard Mode: Open EXISTING project
  local project_path="$HOME/Desktop/git/$1"
  
  if [ -d "$project_path" ]; then
    cd "$project_path"
    echo "🚀 Opening in IDE..."
    code .
  else
    echo "❌ Project '$1' not found."
    echo "👉 Did you mean to create it? Use: mygit -n $1"
  fi
}

# --- Autocomplete Logic ---
# TAB will autocomplete folder names from inside ~/Desktop/git
_mygit() {
  _files -W ~/Desktop/git -/
}
compdef _mygit mygit

# ==============================================================================
# 6. ENVIRONMENT VARIABLES & PATHS (Crucial Section)
# ==============================================================================

# a) NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# b) JAVA (Zulu 8 Strict Config)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
# Only add bin to path. We prepend this so it overrides system Java.
export PATH="$JAVA_HOME/bin:$PATH"

# c) Custom & Third Party Tools
# Prepend these so they take precedence over system tools
export PATH="/Users/mlubich/.antigravity/antigravity/bin:$PATH"
export PATH="/Users/mlubich/.local/bin:$PATH"

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
# -l: long list, -a: all files, --icons: show icons, --git: show git status
alias ls='eza --icons --git'
alias ll='eza -l -a --icons --git --group-directories-first'
alias tree='eza --tree --icons'

# 2. 'bat' (Better cat)
# Uses syntax highlighting for files
alias cat='bat'
# Set bat as the default man page viewer (colored man pages on steroids)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# 3. 'thefuck' (Typo corrector)
# If you type a command wrong, just type 'fuck' (or 'f') to fix it
eval $(thefuck --alias)
alias f='fuck'

# 4. 'lazygit' (Git UI)
alias lg='lazygit'


# Zsh Configuration with Powerlevel10k

A comprehensive, automated setup script for macOS and Linux that installs and configures a complete development environment with Powerlevel10k, modern development tools, and a beautiful terminal experience.

## 📑 Table of Contents

- [✨ Features](#-features)
- [🚀 Quick Start](#-quick-start)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [📦 What Gets Installed](#-what-gets-installed)
  - [Core Components](#core-components)
  - [Development Tools](#development-tools)
  - [Zsh Plugins](#zsh-plugins)
  - [Terminal Applications (macOS)](#terminal-applications-macos)
- [🎨 Font Setup](#-font-setup)
- [📝 Understanding the Configuration Files](#-understanding-the-configuration-files)
  - [zshrc (Main Shell Configuration)](#zshrc-main-shell-configuration)
  - [config/p10k.zsh (Theme Appearance)](#configp10kzsh-theme-appearance)
- [🎯 Custom Commands & Aliases](#-custom-commands--aliases)
  - [Navigation](#navigation)
  - [Git Aliases](#git-aliases)
  - [Custom Functions](#custom-functions)
  - [Modern Tool Aliases](#modern-tool-aliases)
- [🔍 FZF (Fuzzy Finder) Usage Guide](#-fzf-fuzzy-finder-usage-guide)
- [⚙️ Configuration](#️-configuration)
- [🔧 Customization](#-customization)
- [🔄 Updating](#-updating)
- [🗑️ Uninstalling](#️-uninstalling)
- [🐛 Troubleshooting](#-troubleshooting)
- [🧪 Testing](#-testing)
- [📁 File Structure](#-file-structure)
- [🛡️ Safety & Design Principles](#️-safety--design-principles)
- [📚 Additional Resources](#-additional-resources)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [👤 Author](#-author)

## ✨ Features

- **Powerlevel10k** - Beautiful, fast, and highly customizable Zsh prompt with instant prompt
- **Oh My Zsh** - Zsh framework with plugins and themes
- **MesloLGS NF Fonts** - Required Nerd Fonts for Powerlevel10k icons
- **Modern Development Tools** - fzf, autojump, eza, bat, thefuck, lazygit, ripgrep, fd
- **Zsh Plugins** - Auto-suggestions and syntax highlighting
- **NVM** - Node Version Manager for multiple Node.js versions
- **Python** - Latest stable version via Homebrew
- **iTerm2** - Automatic installation on macOS (optional)
- **Xcode Command Line Tools** - Automatic installation on macOS
- **Cross-platform** - Works on macOS and Linux (Ubuntu, RHEL, Fedora, etc.)

## 🚀 Quick Start

### Prerequisites

- macOS or Linux (Unix-like system)
- `curl` and `git` installed
- Internet connection
- Administrator/sudo access (for package installation)

### Installation

1. **Clone this repository:**
   ```bash
   git clone git@github.com:ml-lubich/zshrc.git
   cd zshrc
   ```

2. **Run the installation script:**
   ```bash
   ./scripts/install.sh
   ```
   
   Note: Scripts are already executable. If you encounter permission issues, run `chmod +x scripts/*.sh`

   The script is **idempotent** - you can run it multiple times safely. It will:
   - Check if components are already installed
   - Update existing installations when appropriate
   - Skip unnecessary operations
   - Never overwrite user customizations unnecessarily

3. **Restart your terminal** (or run `source ~/.zshrc`)

4. **Configure your terminal/editor fonts** (see [Font Setup](#-font-setup) below)

That's it! Your environment is now fully configured.

## 📦 What Gets Installed

### Core Components

- **Homebrew** (or Linuxbrew on Linux) - Package manager
- **Xcode Command Line Tools** (macOS) - Required development tools
- **Python** - Latest stable version (configurable via `PYTHON_VERSION`)
- **Zsh** - Z shell (installed on Linux if not present)
- **Oh My Zsh** - Zsh configuration framework
- **Powerlevel10k** - Zsh theme with instant prompt
- **MesloLGS NF Fonts** - All 4 variants (Regular, Bold, Italic, Bold Italic)
- **NVM** - Node Version Manager for Node.js

### Development Tools

- **fzf** - Fuzzy finder for files, commands, history (with ripgrep and fd integration)
- **ripgrep** - Fast text search (used by fzf)
- **fd** - Fast file finder (used by fzf)
- **autojump** - Smart directory navigation (`j project-name`)
- **eza** - Modern replacement for `ls` with icons and git status
- **bat** - Better `cat` with syntax highlighting
- **thefuck** - Typo corrector (type `fuck` or `f` after a typo)
- **lazygit** - Terminal UI for Git (`lg` command)

### Zsh Plugins

- **zsh-autosuggestions** - Suggests commands as you type
- **zsh-syntax-highlighting** - Highlights commands in real-time
- **Oh My Zsh plugins**: git, z, fzf, autojump, colored-man-pages, web-search, extract

### Terminal Applications (macOS)

- **iTerm2** - Enhanced terminal emulator (optional, can be disabled)

## 🎨 Font Setup

Powerlevel10k requires **MesloLGS NF** fonts to display icons correctly. The installer automatically downloads and installs these fonts, but you need to configure your terminal/editor to use them.

### macOS Terminal

1. Open Terminal → Preferences (⌘,)
2. Select your profile → Text tab
3. Click "Font" → Select "MesloLGS NF Regular" (or any MesloLGS NF variant)
4. Set size to 12-14pt

### iTerm2 (macOS)

1. Open iTerm2 → Preferences (⌘,)
2. Profiles → Text → Font
3. Select "MesloLGS NF Regular"
4. Set size to 12-14pt

### Linux Terminal (GNOME Terminal)

1. Edit → Preferences
2. Select your profile → Text
3. Custom font → Select "MesloLGS NF Regular"

### VS Code Integrated Terminal

**⚠️ CRITICAL:** VS Code has TWO separate font settings:
- **Editor Font** (`editor.fontFamily`) - For code editing - ❌ NOT what you need!
- **Terminal Font** (`terminal.integrated.fontFamily`) - For terminal display - ✅ THIS is what you need!

**Step-by-Step Instructions:**

1. Open VS Code Settings:
   - Press `⌘,` (Cmd+Comma) on macOS
   - Or: Code → Settings → Settings

2. Search for the CORRECT setting:
   - Type: **"terminal font"** (NOT "editor font")
   - Look for: **"Terminal > Integrated: Font Family"**

3. Set the font:
   - In the search results, find **"Terminal > Integrated: Font Family"**
   - Set value to: `MesloLGS NF` (type exactly: `MesloLGS NF`)
   - **IMPORTANT:** Put `MesloLGS NF` FIRST if you include fallbacks
   - Example: `MesloLGS NF, monospace` (NOT `monospace, MesloLGS NF`)
   - Or just: `MesloLGS NF` (recommended)
   - Make sure it's the TERMINAL setting, not Editor setting!

4. **Restart VS Code terminal:**
   - Close the terminal panel completely
   - Reopen: Terminal → New Terminal (or `Ctrl+` `)
   - Icons should now display correctly!

**Or add directly to `settings.json`:**

1. Open Command Palette (`⌘⇧P`)
2. Type: "Preferences: Open User Settings (JSON)"
3. Add this line:
   ```json
   {
     "terminal.integrated.fontFamily": "MesloLGS NF"
   }
   ```
4. Save and restart VS Code terminal

**Location:** `~/Library/Application Support/Code/User/settings.json` (macOS)

**Troubleshooting:**
- If you still see blocks:
  1. **Font order matters:** Put `MesloLGS NF` FIRST (not after `monospace`)
     - ✅ Correct: `MesloLGS NF` or `MesloLGS NF, monospace`
     - ❌ Wrong: `monospace, MesloLGS NF`
  2. **Restart VS Code COMPLETELY:** Quit (Cmd+Q) and reopen, don't just close terminal
  3. **Font name must be exactly:** `MesloLGS NF` (case-sensitive, with space)
  4. **Verify font is installed:** Check `~/Library/Fonts/MesloLGS*.ttf` exists
  5. **Close and reopen terminal panel** after changing font

### Cursor IDE

**⚠️ CRITICAL:** Set the TERMINAL font, not the editor font!

**Step-by-Step Instructions:**

1. Open Settings:
   - Press `⌘,` (Cmd+Comma) on macOS
   - Or: Cursor → Settings → Settings

2. Search for the CORRECT setting:
   - Type: **"terminal font"** (NOT "editor font")
   - Look for: **"Terminal > Integrated: Font Family"**

3. Set the font:
   - Find **"Terminal > Integrated: Font Family"**
   - Set value to: `MesloLGS NF` (exactly as shown)
   - Make sure it's the TERMINAL setting!

4. **Restart Cursor terminal:**
   - Close terminal panel completely
   - Reopen terminal
   - Icons should now display correctly!

**Or add to `settings.json`:**

1. Open Command Palette (`⌘⇧P`)
2. Type: "Preferences: Open User Settings (JSON)"
3. Add:
   ```json
   {
     "terminal.integrated.fontFamily": "MesloLGS NF"
   }
   ```
4. Save and restart Cursor terminal

**Troubleshooting:**
- Make sure you set `terminal.integrated.fontFamily`, NOT `editor.fontFamily`
- Font name must be exactly: `MesloLGS NF`
- Restart Cursor completely if needed

### Other Editors

- **Sublime Text**: Preferences → Settings → Add `"font_face": "MesloLGS NF"`
- **Atom**: Settings → Editor → Font Family → `"MesloLGS NF"`
- **JetBrains IDEs**: Settings → Editor → Font → Select "MesloLGS NF"
- **Vim/Neovim**: Configure terminal font in your terminal settings (see above)

### Verify Font Installation

**macOS:**
```bash
ls ~/Library/Fonts/ | grep -i meslo
```

**Linux:**
```bash
fc-list | grep -i meslo
```

## 📝 Understanding the Configuration Files

This repository provides two main configuration files:

### `zshrc` (Main Shell Configuration)
The **`zshrc`** file in the repo root is the **core shell configuration**. It contains:
- Oh My Zsh framework setup
- Plugin configurations (git, z, fzf, autojump, etc.)
- Custom functions (like `mygit`)
- Aliases (git shortcuts, tool aliases)
- Environment variables (NVM, PATH, etc.)
- Tool integrations (fzf, ripgrep, bat, etc.)
- History and completion settings

**This file is copied to `~/.zshrc`** and is the heart of your shell setup.

### `config/p10k.zsh` (Theme Appearance)
The **`config/p10k.zsh`** file is **only the visual theme configuration**. It contains:
- Prompt segment definitions
- Colors and styling
- Layout and positioning
- Icon configurations

**This file is copied to `~/.p10k.zsh`** and only affects how your prompt looks, not what it does.

**Why separate?** This separation allows you to:
- Customize your prompt appearance (`p10k configure`) without touching core shell functionality
- Share shell configurations while keeping personal theme preferences
- Update functionality (`zshrc`) independently from visual styling (`p10k.zsh`)

## 🎯 Custom Commands & Aliases

### Navigation

- `..` - Go up one directory
- `...` - Go up two directories
- `ll` - List files with details (using eza)
- `tree` - Show directory tree (using eza)
- `j <directory>` - Jump to frequently used directory (autojump)

### Git Aliases

- `gs` - `git status`
- `ga` - `git add .`
- `gc "message"` - `git commit -m "message"`
- `gp` - `git push`
- `gco` - `git checkout`
- `gl` - `git pull`
- `gcb branch-name` - `git checkout -b branch-name`
- `gpush` - Push current branch to origin
- `lg` - Open lazygit (Git TUI)

### Custom Functions

#### `mygit [project]`
Navigate to a project in `~/Desktop/git/[project]` and open in your default editor.

**Environment Variables:**
- `MYGIT_PROJECTS_DIR` - Customize projects directory (default: `~/Desktop/git`)
- `MYGIT_EDITOR` - Customize editor command (default: `code` for VS Code)

**Usage:**
```bash
mygit my-project    # Opens ~/Desktop/git/my-project in editor
mygit              # Navigates to ~/Desktop/git
```

#### `mygit -n [project]`
Create a new project directory and open in editor.

```bash
mygit -n new-app    # Creates ~/Desktop/git/new-app and opens in editor
```

**Example customization:**
```bash
export MYGIT_PROJECTS_DIR="$HOME/projects"
export MYGIT_EDITOR="cursor"
```

### Modern Tool Aliases

- `ls` / `ll` / `tree` - Uses `eza` instead of `ls` (with icons and git status)
- `cat` - Uses `bat` instead (with syntax highlighting)
- `f` / `fuck` - Fix last command typo (thefuck)
- `lg` - Open lazygit (Git TUI)
- `ff` - File finder with bat preview
- `rgg "term"` - Search file content with ripgrep + fzf + bat preview

## 🔍 FZF (Fuzzy Finder) Usage Guide

fzf is a powerful fuzzy finder that integrates with ripgrep and fd for fast file and content searching.

### Basic File Search

**Search by file name:**
```bash
fzf                    # Interactive file picker
ff                     # Alias for fzf with preview
```

**Press `Ctrl+T`** while typing a command to insert a selected file path.

### Search File Content with ripgrep

**Search for text inside files:**
```bash
# Basic search
rg "search term" | fzf

# With preview (shows context around matches)
rgg "search term"     # Custom alias with bat preview
```

**Example workflow:**
```bash
# 1. Search for "function" in all files
rgg "function"

# 2. Navigate results with arrow keys
# 3. Press Enter to open the file at the matching line
# 4. Press ? to toggle preview window
```

### Advanced FZF Workflows

**Search command history:**
- Press `Ctrl+R` to search your command history
- Type to filter, press Enter to execute

**Search and open file in editor:**
```bash
code "$(fzf)"         # Open selected file in VS Code
vim "$(fzf)"          # Open selected file in vim
```

**Search with fd (faster than find):**
```bash
fd . | fzf            # Search all files
fd -e py | fzf        # Search only Python files
fd -e js -e ts | fzf  # Search JavaScript and TypeScript files
```

### FZF Key Bindings

- `Enter` - Select item
- `Ctrl+C` / `Esc` - Cancel
- `Ctrl+T` - Insert selected file path into command line
- `Ctrl+R` - Search command history
- `Ctrl+J` / `Ctrl+K` - Navigate up/down
- `?` - Toggle preview window (when available)
- `Tab` - Select multiple items (multi-select mode)

## ⚙️ Configuration

### Environment Variables

You can customize the installation by setting environment variables before running `install.sh`:

```bash
# Python version (default: "latest")
PYTHON_VERSION=3.10 ./install.sh

# Node.js version (default: "lts")
NODE_VERSION=20 ./install.sh

# Skip iTerm2 installation on macOS
INSTALL_ITERM2=false ./install.sh

# Skip Xcode Command Line Tools
INSTALL_XCODE_TOOLS=false ./install.sh

# Skip font installation
INSTALL_FONTS=false ./install.sh

# Combine multiple options
PYTHON_VERSION=3.10 NODE_VERSION=20 INSTALL_ITERM2=false ./install.sh
```

### Configuration File

Create a `config.sh` file in the repository root to persist your configuration:

```bash
# config.sh
export PYTHON_VERSION="latest"
export NODE_VERSION="lts"
export INSTALL_ITERM2="true"
export INSTALL_XCODE_TOOLS="true"
export BACKUP_EXISTING="true"
export INSTALL_DEV_TOOLS="true"
export INSTALL_OH_MY_ZSH="true"
export INSTALL_POWERLEVEL10K="true"
export INSTALL_FONTS="true"
export INSTALL_NVM="true"
export SET_DEFAULT_SHELL="true"
```

### Configuration Files Location

- **`~/.zshrc`** - Main Zsh configuration file (copied from repo `zshrc`)
  - Contains: Oh My Zsh setup, plugins, aliases, functions, tool configurations
  - This is the **core shell configuration** - all your shell behavior lives here
  - Includes: `mygit` function, git aliases, fzf setup, NVM, modern tool aliases, etc.
  
- **`~/.p10k.zsh`** - Powerlevel10k theme configuration (copied from repo `config/p10k.zsh`)
  - Contains: Visual appearance of your prompt (colors, segments, layout)
  - This is **only the theme styling** - how your prompt looks
  - Generated by `p10k configure` or copied from repo template
  
- **`config.sh`** (in repo) - Installation configuration
  - Customizes installation behavior (Python version, Node version, etc.)

**Why separate files?**
- `zshrc` = **Functionality** (what your shell does)
- `p10k.zsh` = **Appearance** (how your prompt looks)
- Separating them makes it easy to customize the theme without touching core shell config

## 🔧 Customization

### Changing Powerlevel10k Theme

Run the configuration wizard:
```bash
p10k configure
```

### Adding More Oh My Zsh Plugins

Edit `~/.zshrc` and add to the `plugins` array:
```zsh
plugins=(
  git
  z
  fzf
  # Add more plugins here
  docker
  kubectl
  python
)
```

Then reload:
```bash
source ~/.zshrc
```

### Custom Aliases

Add to `~/.zshrc`:
```zsh
# Your custom aliases
alias myalias='your command here'
alias gs='git status'
```

## 🔄 Updating

To update your configuration:

```bash
cd ~/Desktop/git/zshrc  # or wherever you cloned it
git pull
./install.sh
```

The script is idempotent, so running it multiple times is safe. It will:
- Update Powerlevel10k if installed via git
- Update `~/.zshrc` if the repo version changed
- Skip components that are already installed and up-to-date

## 🗑️ Uninstalling

To remove components installed by this setup:

```bash
./uninstall.sh
```

The uninstall script will:
- Ask for confirmation before removing each component
- Restore backups if available
- **Never remove** system files, Homebrew itself, or user data
- Preserve backups for recovery

**What gets removed (with confirmation):**
- Oh My Zsh
- Powerlevel10k
- NVM
- MesloLGS NF fonts
- Homebrew packages (fzf, autojump, eza, etc.)
- `~/.zshrc` (with backup restoration option)
- `~/.p10k.zsh` (with backup restoration option)

**What is NOT removed:**
- Homebrew itself
- iTerm2
- Xcode Command Line Tools
- Python installations
- Node.js installations (if NVM is kept)
- System files or other user data

## 🐛 Troubleshooting

### Fonts Not Displaying Correctly

1. Verify fonts are installed (see [Font Setup](#-font-setup))
2. Ensure your terminal/editor is using "MesloLGS NF" font
3. Restart terminal/editor after font change
4. Clear font cache on Linux: `fc-cache -fv`

### Powerlevel10k Prompt Not Showing

1. Check that `~/.p10k.zsh` exists
2. Verify `~/.zshrc` sources it: `[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh`
3. Run `source ~/.zshrc`
4. Check for errors: `zsh -n ~/.zshrc`

### Command Not Found Errors

1. Ensure Homebrew is in PATH:
   ```bash
   eval "$(/opt/homebrew/bin/brew shellenv)"  # macOS Apple Silicon
   # or
   eval "$(/usr/local/Homebrew/bin/brew shellenv)"  # macOS Intel
   eval "$($HOME/.linuxbrew/bin/brew shellenv)"  # Linux
   ```
2. Restart terminal or run `source ~/.zshrc`
3. Check if tool is installed: `brew list <package>`

### NVM Not Working

1. Ensure NVM is installed: `test -d ~/.nvm`
2. Check `~/.zshrc` includes NVM setup
3. Restart terminal or run: `source ~/.nvm/nvm.sh`
4. Verify NVM is loaded: `command -v nvm`

### Python Version Issues

1. Check installed Python: `python3 --version`
2. Verify Homebrew Python: `brew list python`
3. Check PATH: `which python3`
4. Use specific version: `PYTHON_VERSION=3.10 ./install.sh`

### Installation Fails on Linux

1. Ensure you have sudo access
2. Install prerequisites manually:
   ```bash
   # Ubuntu/Debian
   sudo apt-get update && sudo apt-get install -y build-essential curl file git zsh

   # RHEL/Fedora
   sudo dnf groupinstall -y "Development Tools"
   sudo dnf install -y curl file git zsh
   ```
3. Re-run `./install.sh`

### Restore Previous Configuration

If something goes wrong, restore your backup:
```bash
cp ~/.zshrc.pre-mlubich-backup ~/.zshrc
source ~/.zshrc
```

## 🧪 Testing

This repository includes comprehensive tests. To run them:

```bash
# Install test dependencies
pip install -r requirements.txt

# Run tests
pytest

# Run with coverage report
pytest --cov=. --cov-report=html

# View coverage report
open htmlcov/index.html  # macOS
xdg-open htmlcov/index.html  # Linux
```

Test coverage target: **90%+**

## 📁 File Structure

```
zshrc/
├── scripts/
│   ├── install.sh      # Main installation script (idempotent)
│   ├── uninstall.sh    # Uninstallation script
│   └── config.sh       # Configuration file (optional)
├── zshrc               # Main Zsh configuration template
│                        # → Copied to ~/.zshrc (contains all shell functionality)
│                        #   Includes: Oh My Zsh, plugins, aliases, functions, tools
├── config/             # Configuration templates
│   └── p10k.zsh        # Powerlevel10k theme configuration
│                        # → Copied to ~/.p10k.zsh (only visual prompt styling)
├── README.md           # This file
├── .gitignore          # Git ignore rules
├── requirements.txt    # Python dependencies (includes test dependencies)
├── pytest.ini          # Pytest configuration
├── .coveragerc         # Coverage configuration
├── docs/               # Documentation
│   ├── architecture.md
│   ├── requirements.md
│   ├── testing.md
│   ├── design.md
│   ├── api.md
│   └── INSTALLATION_GUIDE.md
└── tests/              # Test suite
    ├── __init__.py
    ├── conftest.py
    ├── test_install.py
    ├── test_install_script.py
    ├── test_install.sh
    └── test_zshrc_config.py
```

## 🛡️ Safety & Design Principles

### Safety Features

- **Backup mechanism** - Automatically backs up existing configs before modification
- **Idempotent** - Safe to run multiple times
- **No system file modification** - Only modifies user-space files
- **Confirmation prompts** - Uninstall script asks for confirmation
- **Error handling** - Fails fast with clear error messages

### Design Principles

- **Extensibility** - Easy to add new tools and configurations
- **Portability** - Works on macOS and Linux
- **User-friendly** - Clear logging and helpful error messages
- **Maintainable** - Well-organized, documented code
- **Testable** - Comprehensive test coverage

## 📚 Additional Resources

- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [fzf Documentation](https://github.com/junegunn/fzf)
- [MesloLGS NF Fonts](https://github.com/romkatv/powerlevel10k-media)
- [Homebrew Documentation](https://brew.sh/)
- [Zsh Documentation](https://www.zsh.org/)

## 🤝 Contributing

This is a personal configuration repository. Feel free to fork and customize for your own needs!

## 📄 License

Personal use. See repository for details.

## 👤 Author

**Misha Lubich**
- GitHub: [@ml-lubich](https://github.com/ml-lubich)
- Email: michaelle.lubich@gmail.com

---

**Note**: This setup is optimized for macOS but works on Linux as well. Some paths and commands may vary by OS. The installer automatically detects your OS and uses the appropriate installation methods.

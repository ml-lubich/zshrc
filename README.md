# Zsh Configuration with Powerlevel10k

A comprehensive, automated setup script for macOS and Linux that installs and configures a complete development environment with:

- **Powerlevel10k** - Beautiful, fast, and highly customizable Zsh prompt
- **Oh My Zsh** - Zsh framework with plugins and themes
- **MesloLGS NF Fonts** - Required Nerd Fonts for Powerlevel10k icons
- **Modern Development Tools** - fzf, autojump, eza, bat, thefuck, lazygit
- **Zsh Plugins** - Auto-suggestions and syntax highlighting
- **NVM** - Node Version Manager with Node.js and npm
- **Python** - Latest stable or specified version via Homebrew
- **iTerm2** - Terminal emulator for macOS (optional)
- **Xcode Command Line Tools** - Developer tools for macOS

## 🚀 Quick Start

### Prerequisites

- macOS (Apple Silicon or Intel) or Linux (Ubuntu, Debian, Fedora, RHEL, CentOS)
- `curl` and `git` installed
- Internet connection
- Administrator/sudo access (for some installations)

### Installation

1. **Clone this repository:**
   ```bash
   git clone git@github.com:ml-lubich/zshrc.git
   cd zshrc
   ```

2. **Run the installation script:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Restart your terminal** (or run `source ~/.zshrc`)

4. **Configure your terminal/editor fonts** (see [Font Setup](#-font-setup) below)

That's it! Your environment is now fully configured.

## 📦 What Gets Installed

### Core Components

- **Homebrew** (or Linuxbrew on Linux) - Package manager
- **Python** - Latest stable version or specified version (configurable)
- **Node.js & npm** - Latest LTS or specified version via NVM (configurable)
- **Zsh** - Z shell (if not already installed on Linux)
- **Oh My Zsh** - Zsh configuration framework
- **Powerlevel10k** - Zsh theme with instant prompt
- **MesloLGS NF Fonts** - All 4 variants (Regular, Bold, Italic, Bold Italic)

### macOS-Specific Components

- **Xcode Command Line Tools** - Required developer tools (automatically installed)
- **iTerm2** - Terminal emulator (optional, can be disabled)

### Development Tools

- **fzf** - Fuzzy finder for files, commands, history (with ripgrep and fd integration)
- **ripgrep** - Fast text search engine (used by fzf for content search)
- **fd** - Fast file finder (used by fzf for file search, called `fdfind` on Ubuntu)
- **autojump** - Smart directory navigation (`j project-name`)
- **eza** - Modern replacement for `ls` with icons and git status
- **bat** - Better `cat` with syntax highlighting
- **thefuck** - Typo corrector (type `fuck` or `f` after a typo)
- **lazygit** - Terminal UI for Git (`lg` command)
- **NVM** - Node Version Manager for multiple Node.js versions

### Zsh Plugins

- **zsh-autosuggestions** - Suggests commands as you type
- **zsh-syntax-highlighting** - Highlights commands in real-time
- **Oh My Zsh plugins**: git, z, fzf, autojump, colored-man-pages, web-search, extract

## ⚙️ Configuration

The installation is fully configurable via `config.sh` or environment variables.

### Using config.sh

Edit `config.sh` to customize installation:

```bash
# Python version to install
export PYTHON_VERSION="3.10"  # Options: "latest", "3.10", "3.11", "3.12", etc.

# Node.js version to install via NVM
export NODE_VERSION="lts"  # Options: "latest", "lts", or specific version like "20", "18"

# Install iTerm2 on macOS (default: true)
export INSTALL_ITERM2="false"

# Install Xcode Command Line Tools on macOS (default: true)
export INSTALL_XCODE_TOOLS="true"

# Backup existing configuration files (default: true)
export BACKUP_EXISTING="true"

# Install development tools via Homebrew (default: true)
export INSTALL_DEV_TOOLS="true"

# Install Oh My Zsh (default: true)
export INSTALL_OH_MY_ZSH="true"

# Install Powerlevel10k (default: true)
export INSTALL_POWERLEVEL10K="true"

# Install MesloLGS NF Fonts (default: true)
export INSTALL_FONTS="true"

# Install NVM (default: true)
export INSTALL_NVM="true"

# Set default shell to zsh (default: true)
export SET_DEFAULT_SHELL="true"
```

### Using Environment Variables

You can also set environment variables directly:

```bash
PYTHON_VERSION=3.10 ./install.sh
INSTALL_ITERM2=false ./install.sh
NODE_VERSION=20 ./install.sh
```

## 🎨 Font Setup

Powerlevel10k requires **MesloLGS NF** fonts to display icons correctly. The installer automatically downloads and installs these fonts, but you need to configure your terminal/editor to use them.

### Terminal Applications

#### macOS Terminal
1. Open Terminal → Preferences (⌘,)
2. Select your profile → Text tab
3. Click "Font" → Select "MesloLGS NF Regular" (or any MesloLGS NF variant)
4. Set size to 12-14pt

#### iTerm2 (macOS)
1. Open iTerm2 → Preferences (⌘,)
2. Profiles → Text → Font
3. Select "MesloLGS NF Regular"
4. Set size to 12-14pt
5. **Pro Tip**: You can also set this as the default for all profiles

#### Linux Terminal (GNOME Terminal)
1. Edit → Preferences
2. Select your profile → Text
3. Custom font → Select "MesloLGS NF Regular"

#### VS Code Integrated Terminal
1. Open VS Code Settings (⌘, or Ctrl+,)
2. Search for "terminal font"
3. Set `terminal.integrated.fontFamily` to: `"MesloLGS NF"`
4. Or add to `settings.json`:
   ```json
   {
     "terminal.integrated.fontFamily": "MesloLGS NF",
     "terminal.integrated.fontSize": 12
   }
   ```

#### Cursor IDE
1. Open Settings (⌘, or Ctrl+,)
2. Search for "terminal font"
3. Set to: `"MesloLGS NF"`
4. Or add to `settings.json`:
   ```json
   {
     "terminal.integrated.fontFamily": "MesloLGS NF",
     "terminal.integrated.fontSize": 12
   }
   ```

#### Other Editors
- **Sublime Text**: Preferences → Settings → Add `"font_face": "MesloLGS NF"`
- **Atom**: Settings → Editor → Font Family → `"MesloLGS NF"`
- **JetBrains IDEs**: Settings → Editor → Font → Select "MesloLGS NF"

### Verify Font Installation

**macOS:**
```bash
ls ~/Library/Fonts/ | grep -i meslo
```

**Linux:**
```bash
fc-list | grep -i meslo
```

## 🎯 Custom Commands & Aliases

### Navigation
- `..` - Go up one directory
- `...` - Go up two directories
- `ll` - List files with details (using eza)
- `tree` - Show directory tree (using eza)

### Git Aliases
- `gs` - `git status`
- `ga` - `git add .`
- `gc "message"` - `git commit -m "message"`
- `gp` - `git push`
- `gco` - `git checkout`
- `gl` - `git pull`
- `gcb branch-name` - `git checkout -b branch-name`
- `gpush` - Push current branch to origin

### Custom Functions

#### `mygit [project]`
Navigate to a project in `~/Desktop/git/[project]` and open in VS Code.

```bash
mygit my-project    # Opens ~/Desktop/git/my-project in VS Code
mygit              # Navigates to ~/Desktop/git
```

#### `mygit -n [project]`
Create a new project directory and open in VS Code.

```bash
mygit -n new-app    # Creates ~/Desktop/git/new-app and opens in VS Code
```

### Modern Tool Aliases
- `ls` / `ll` / `tree` - Uses `eza` instead of `ls` (with icons and git status)
- `cat` - Uses `bat` instead (with syntax highlighting)
- `f` / `fuck` - Fix last command typo (thefuck)
- `lg` - Open lazygit (Git TUI)

## 🔍 FZF (Fuzzy Finder) Usage Guide

fzf is a powerful fuzzy finder that integrates with ripgrep and fd for fast file and content searching. Here are the most useful patterns:

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

**Search with ripgrep and preview:**
```bash
# Search with line numbers and preview
rg --line-number --no-heading --smart-case "YOUR_QUERY" . | \
  fzf --delimiter : \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1} --line-range $(( {2}-30 )):$(( {2}+30 ))' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
```

### FZF Key Bindings

- `Enter` - Select item
- `Ctrl+C` / `Esc` - Cancel
- `Ctrl+T` - Insert selected file path into command line
- `Ctrl+R` - Search command history
- `Ctrl+J` / `Ctrl+K` - Navigate up/down
- `?` - Toggle preview window (when available)
- `Tab` - Select multiple items (multi-select mode)

### Custom FZF Aliases

The configuration includes these custom aliases:

- `ff` - File finder with bat preview
- `rgg "term"` - Search file content with ripgrep + fzf + bat preview

### Tips & Tricks

1. **Fast file navigation**: Type `Ctrl+T` anywhere in a command to insert a file path
2. **History search**: `Ctrl+R` to search and reuse previous commands
3. **Multi-select**: Press `Tab` to select multiple files, then `Enter` to process them
4. **Preview**: Most fzf commands include syntax-highlighted previews using `bat`
5. **Smart case**: ripgrep searches are case-insensitive by default, case-sensitive if you use uppercase

## 🔧 Configuration Files

### `~/.zshrc`
Your main Zsh configuration file. Includes:
- Powerlevel10k instant prompt
- Oh My Zsh setup
- Plugin configurations
- Custom aliases and functions
- Environment variables (NVM, Java, custom paths)
- Modern tool integrations

### `~/.p10k.zsh`
Powerlevel10k theme configuration. Customized with:
- Classic powerline style
- Unicode icons
- Dark theme
- 12-hour time format
- Compact layout
- Virtualenv support

## 🔄 Updating

To update your configuration:

```bash
cd ~/Desktop/git/zshrc  # or wherever you cloned it
git pull
./install.sh
```

The installer will:
- Update Powerlevel10k to the latest version
- Update Oh My Zsh
- Update NVM
- Preserve your existing `.zshrc` and `.p10k.zsh` (if they exist)

## 🗑️ Uninstalling

To safely remove all installed components:

```bash
./uninstall.sh
```

The uninstall script will:
- Ask for confirmation before removing each component
- Restore your original `.zshrc` from backup (if available)
- Remove Powerlevel10k, Oh My Zsh, NVM, and fonts
- Optionally remove Homebrew packages
- **Note**: Homebrew itself is not automatically removed (you can do this manually if needed)

## 🧪 Testing

This repository includes comprehensive tests with pytest.

### Running Tests

1. **Install test dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run tests:**
   ```bash
   pytest tests/ -v
   ```

3. **Run tests with coverage:**
   ```bash
   pytest tests/ -v --cov=. --cov-report=html --cov-report=term
   ```

4. **View coverage report:**
   ```bash
   open htmlcov/index.html  # macOS
   xdg-open htmlcov/index.html  # Linux
   ```

### Test Coverage

The test suite aims for 90-100% code coverage and includes:
- Script syntax validation
- Configuration file validation
- Installation function tests
- Safety check tests
- Error handling tests
- Uninstall script tests

## 🐛 Troubleshooting

### Fonts Not Displaying Correctly
1. Verify fonts are installed (see [Font Setup](#-font-setup))
2. Ensure your terminal/editor is using "MesloLGS NF" font
3. Restart terminal/editor after font change
4. On Linux, refresh font cache: `fc-cache -f ~/.local/share/fonts`

### Powerlevel10k Prompt Not Showing
1. Check that `~/.p10k.zsh` exists
2. Verify `~/.zshrc` sources it: `[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh`
3. Run `source ~/.zshrc`
4. Check for errors: `zsh -x ~/.zshrc 2>&1 | grep -i error`

### Command Not Found Errors
1. Ensure Homebrew is in PATH:
   ```bash
   eval "$(/opt/homebrew/bin/brew shellenv)"  # macOS Apple Silicon
   # or
   eval "$(/usr/local/Homebrew/bin/brew shellenv)"  # macOS Intel
   # or
   eval "$($HOME/.linuxbrew/bin/brew shellenv)"  # Linux
   ```
2. Restart terminal or run `source ~/.zshrc`

### NVM Not Working
1. Ensure NVM is installed: `test -d ~/.nvm`
2. Check `~/.zshrc` includes NVM setup
3. Restart terminal or run: `source ~/.nvm/nvm.sh`
4. Verify Node.js is installed: `nvm list`

### Python Version Issues
1. Check installed version: `python3 --version`
2. Verify Homebrew Python: `brew list python` or `brew list python@3.10`
3. Check PATH: `which python3`
4. If needed, reinstall: `brew reinstall python` or `brew reinstall python@3.10`

### Xcode Command Line Tools Issues (macOS)
1. Check if installed: `xcode-select -p`
2. If not installed, run: `xcode-select --install`
3. Accept license: `sudo xcodebuild -license accept`
4. Verify: `xcode-select -p`

### iTerm2 Not Installing
1. Ensure Homebrew is installed and in PATH
2. Check if already installed: `test -d /Applications/iTerm.app`
3. Try manual installation: `brew install --cask iterm2`
4. Or download from: https://iterm2.com/

### Restore Previous Configuration
If something goes wrong, restore your backup:

```bash
cp ~/.zshrc.pre-mlubich-backup ~/.zshrc
source ~/.zshrc
```

## 📝 File Structure

```
zshrc/
├── install.sh          # Main installation script
├── uninstall.sh        # Uninstall script
├── config.sh           # Configuration file
├── zshrc               # Zsh configuration template
├── p10k.zsh            # Powerlevel10k theme configuration
├── README.md           # This file
├── requirements.txt    # Python dependencies for testing
├── .gitignore          # Git ignore rules
├── tests/              # Test suite
│   ├── __init__.py
│   └── test_install.py
└── docs/               # Documentation
    ├── architecture.md
    ├── requirements.md
    ├── testing.md
    ├── design.md
    └── api.md
```

## 🔒 Safety & Best Practices

### What This Script Does
- ✅ Backs up existing `.zshrc` before modifying
- ✅ Checks if components are already installed before installing
- ✅ Uses non-destructive operations
- ✅ Provides comprehensive logging
- ✅ Supports configuration via environment variables
- ✅ Includes uninstall script for safe removal

### What This Script Does NOT Do
- ❌ Modify system files outside of `$HOME`
- ❌ Remove existing configurations without backup
- ❌ Install system-level packages without user confirmation (Linux)
- ❌ Overwrite existing `.p10k.zsh` if it exists
- ❌ Force uninstall of Homebrew (must be done manually)

## 📚 Additional Resources

- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [fzf Documentation](https://github.com/junegunn/fzf)
- [MesloLGS NF Fonts](https://github.com/romkatv/powerlevel10k-media)
- [Homebrew Documentation](https://brew.sh/)
- [iTerm2 Documentation](https://iterm2.com/documentation.html)

## 🤝 Contributing

This is a personal configuration repository. Feel free to fork and customize for your own needs!

If you find bugs or have suggestions:
1. Open an issue describing the problem
2. Provide your OS and version information
3. Include relevant error messages or logs

## 📄 License

Personal use. See repository for details.

## 👤 Author

**Misha Lubich**
- GitHub: [@ml-lubich](https://github.com/ml-lubich)
- Email: michaelle.lubich@gmail.com

---

**Note**: This setup is optimized for macOS but works on Linux as well. Some paths and commands may vary by OS. The script automatically detects your OS and adjusts accordingly.

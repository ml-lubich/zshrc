# Complete Installation Guide

This guide provides step-by-step instructions for setting up your development environment using the zshrc configuration.

## Prerequisites

Before running the installation script, ensure you have:

1. **macOS** (Apple Silicon or Intel) or **Linux** (Ubuntu, Debian, Fedora, RHEL, CentOS)
2. **Internet connection** (for downloading packages and fonts)
3. **Administrator/sudo access** (for installing system packages on Linux)
4. **Basic tools**: `curl` and `git` (usually pre-installed)

## Quick Installation

### Step 1: Clone the Repository

```bash
git clone git@github.com:ml-lubich/zshrc.git
cd zshrc
```

### Step 2: Review Configuration (Optional)

Edit `config.sh` if you want to customize:
- Python version (default: latest)
- Node.js version (default: lts)
- Whether to install iTerm2 (macOS only, default: true)
- Other installation options

### Step 3: Run Installation

```bash
chmod +x install.sh
./install.sh
```

The script will:
- ✅ Check for required dependencies
- ✅ Install Homebrew (if not present)
- ✅ Install Xcode Command Line Tools (macOS)
- ✅ Install iTerm2 (macOS, optional)
- ✅ Install Python and Node.js
- ✅ Install development tools
- ✅ Install fonts
- ✅ Configure zsh and Powerlevel10k
- ✅ Backup existing configurations

### Step 4: Restart Terminal

Close your current terminal and open a new one, or run:

```bash
source ~/.zshrc
```

### Step 5: Configure Fonts

**This is critical for Powerlevel10k to display correctly!**

See the [Font Setup](#font-setup) section below for detailed instructions.

## Detailed Installation Steps

### macOS Installation

1. **Xcode Command Line Tools**
   - Automatically installed by the script
   - May prompt for password
   - Takes 5-10 minutes

2. **Homebrew**
   - Installed to `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
   - Automatically added to PATH

3. **iTerm2**
   - Installed via Homebrew Cask
   - Can be disabled by setting `INSTALL_ITERM2=false` in `config.sh`

4. **Python**
   - Latest stable version via Homebrew
   - Can specify version: `PYTHON_VERSION=3.10 ./install.sh`

5. **Node.js & npm**
   - Installed via NVM (Node Version Manager)
   - Latest LTS by default
   - Can specify version: `NODE_VERSION=20 ./install.sh`

### Linux Installation

1. **System Packages**
   - zsh, git, curl installed via system package manager
   - Supports: apt-get (Ubuntu/Debian), dnf (Fedora), yum (RHEL/CentOS)

2. **Homebrew (Linuxbrew)**
   - Optional but recommended
   - Installed to `~/.linuxbrew`

3. **Python**
   - Latest stable via Homebrew or system package manager

4. **Node.js & npm**
   - Installed via NVM

## Font Setup

Powerlevel10k requires **MesloLGS NF** fonts to display icons correctly.

### macOS Terminal

1. Open Terminal → Preferences (⌘,)
2. Select your profile → Text tab
3. Click "Font" → Select "MesloLGS NF Regular"
4. Set size to 12-14pt
5. Click "OK"

### iTerm2

1. Open iTerm2 → Preferences (⌘,)
2. Profiles → Text → Font
3. Select "MesloLGS NF Regular"
4. Set size to 12-14pt
5. **Pro Tip**: Set as default for all profiles

### VS Code

1. Open Settings (⌘, or Ctrl+,)
2. Search for "terminal font"
3. Set `terminal.integrated.fontFamily` to: `"MesloLGS NF"`
4. Or add to `settings.json`:
   ```json
   {
     "terminal.integrated.fontFamily": "MesloLGS NF",
     "terminal.integrated.fontSize": 12
   }
   ```

### Cursor IDE

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

### Verify Font Installation

**macOS:**
```bash
ls ~/Library/Fonts/ | grep -i meslo
```

**Linux:**
```bash
fc-list | grep -i meslo
```

## Configuration Options

### Environment Variables

You can customize installation without editing `config.sh`:

```bash
# Install Python 3.10 instead of latest
PYTHON_VERSION=3.10 ./install.sh

# Install specific Node.js version
NODE_VERSION=20 ./install.sh

# Skip iTerm2 installation
INSTALL_ITERM2=false ./install.sh

# Skip font installation
INSTALL_FONTS=false ./install.sh

# Combine options
PYTHON_VERSION=3.10 NODE_VERSION=20 INSTALL_ITERM2=false ./install.sh
```

### config.sh Options

Edit `config.sh` to set defaults:

```bash
# Python version
export PYTHON_VERSION="3.10"  # or "latest"

# Node.js version
export NODE_VERSION="lts"  # or "latest", "20", "18", etc.

# Installation flags
export INSTALL_ITERM2="true"
export INSTALL_XCODE_TOOLS="true"
export INSTALL_DEV_TOOLS="true"
export INSTALL_FONTS="true"
export INSTALL_NVM="true"
export SET_DEFAULT_SHELL="true"
```

## Idempotency

The installation script is **idempotent** - safe to run multiple times:

- ✅ Checks if components are already installed
- ✅ Only updates files if they differ from repo version
- ✅ Creates backups before overwriting
- ✅ Preserves user customizations

### Running Multiple Times

You can safely run `./install.sh` multiple times:

```bash
# First run - installs everything
./install.sh

# Second run - updates if repo changed, skips if already up to date
./install.sh

# Third run - same behavior
./install.sh
```

## Customization

### Customizing mygit Function

The `mygit` function is fully generalizable:

```bash
# Set custom projects directory
export MYGIT_PROJECTS_DIR="$HOME/projects"

# Set custom editor
export MYGIT_EDITOR="cursor"  # or "vim", "nano", etc.

# Add to ~/.zshrc to make permanent
echo 'export MYGIT_PROJECTS_DIR="$HOME/projects"' >> ~/.zshrc
echo 'export MYGIT_EDITOR="cursor"' >> ~/.zshrc
```

### Adding Custom Aliases

Add to `~/.zshrc`:

```bash
# Your custom aliases
alias myalias='your command here'
```

### Customizing Powerlevel10k

Run the configuration wizard:

```bash
p10k configure
```

Or edit `~/.p10k.zsh` directly.

## Troubleshooting

### Fonts Not Displaying

1. Verify fonts are installed (see [Font Setup](#font-setup))
2. Ensure terminal/editor uses "MesloLGS NF" font
3. Restart terminal/editor
4. On Linux: `fc-cache -f ~/.local/share/fonts`

### Command Not Found

1. Ensure Homebrew is in PATH:
   ```bash
   eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
   eval "$(/usr/local/bin/brew shellenv)"    # Intel Mac
   eval "$($HOME/.linuxbrew/bin/brew shellenv)"  # Linux
   ```
2. Restart terminal or `source ~/.zshrc`

### NVM Not Working

1. Check installation: `test -d ~/.nvm`
2. Source NVM: `source ~/.nvm/nvm.sh`
3. Verify Node.js: `nvm list`

### Python Issues

1. Check version: `python3 --version`
2. Check Homebrew: `brew list python` or `brew list python@3.10`
3. Reinstall if needed: `brew reinstall python`

### Restore Previous Configuration

```bash
# Restore .zshrc
cp ~/.zshrc.pre-mlubich-backup ~/.zshrc
source ~/.zshrc

# Restore .p10k.zsh (if backed up)
cp ~/.p10k.zsh.pre-mlubich-backup ~/.p10k.zsh
```

## Uninstalling

To safely remove all components:

```bash
./uninstall.sh
```

The uninstall script will:
- Ask for confirmation before removing each component
- Restore backups if available
- Remove Powerlevel10k, Oh My Zsh, NVM, fonts
- Optionally remove Homebrew packages
- **Note**: Homebrew itself is not removed (you can do this manually)

## Testing

Run the test suite:

```bash
# Install test dependencies
pip install -r requirements.txt

# Run tests
pytest tests/ -v

# Run with coverage
pytest tests/ -v --cov=. --cov-report=html --cov-report=term
```

## Support

For issues or questions:
1. Check the [README.md](README.md) for detailed documentation
2. Review [Troubleshooting](#troubleshooting) section
3. Check script logs for error messages
4. Open an issue on GitHub

## Next Steps

After installation:

1. ✅ Configure fonts (see [Font Setup](#font-setup))
2. ✅ Customize Powerlevel10k: `p10k configure`
3. ✅ Set up `mygit` function (see [Customization](#customization))
4. ✅ Add your custom aliases to `~/.zshrc`
5. ✅ Explore the installed tools:
   - `fzf` - Fuzzy finder
   - `eza` - Better ls
   - `bat` - Better cat
   - `lazygit` - Git TUI
   - `thefuck` - Typo corrector

Enjoy your new development environment! 🚀


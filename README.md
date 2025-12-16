# Zsh Configuration with Powerlevel10k

A comprehensive, automated setup script for macOS and Linux that installs and configures a complete development environment with:

- **Powerlevel10k** - Beautiful, fast, and highly customizable Zsh prompt
- **Oh My Zsh** - Zsh framework with plugins and themes
- **MesloLGS NF Fonts** - Required Nerd Fonts for Powerlevel10k icons
- **Modern Development Tools** - fzf, autojump, eza, bat, thefuck, lazygit
- **Zsh Plugins** - Auto-suggestions and syntax highlighting
- **NVM** - Node Version Manager
- **Python** - Latest stable version via Homebrew

## 🚀 Quick Start

### Prerequisites

- macOS or Linux (Unix-like system)
- `curl` and `git` installed
- Internet connection

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
- **Python** - Latest stable version
- **Zsh** - Z shell (if not already installed on Linux)
- **Oh My Zsh** - Zsh configuration framework
- **Powerlevel10k** - Zsh theme with instant prompt
- **MesloLGS NF Fonts** - All 4 variants (Regular, Bold, Italic, Bold Italic)

### Development Tools

- **fzf** - Fuzzy finder for files, commands, history
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
     "terminal.integrated.fontFamily": "MesloLGS NF"
   }
   ```

#### Cursor IDE
1. Open Settings (⌘, or Ctrl+,)
2. Search for "terminal font"
3. Set to: `"MesloLGS NF"`

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

## ⚙️ Configuration Files

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
```

## 🐛 Troubleshooting

### Fonts Not Displaying Correctly
1. Verify fonts are installed (see [Font Setup](#-font-setup))
2. Ensure your terminal/editor is using "MesloLGS NF" font
3. Restart terminal/editor after font change

### Powerlevel10k Prompt Not Showing
1. Check that `~/.p10k.zsh` exists
2. Verify `~/.zshrc` sources it: `[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh`
3. Run `source ~/.zshrc`

### Command Not Found Errors
1. Ensure Homebrew is in PATH:
   ```bash
   eval "$(/opt/homebrew/bin/brew shellenv)"  # macOS Apple Silicon
   # or
   eval "$(/usr/local/Homebrew/bin/brew shellenv)"  # macOS Intel
   ```
2. Restart terminal or run `source ~/.zshrc`

### NVM Not Working
1. Ensure NVM is installed: `test -d ~/.nvm`
2. Check `~/.zshrc` includes NVM setup
3. Restart terminal or run: `source ~/.nvm/nvm.sh`

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
├── zshrc               # Zsh configuration template
├── p10k.zsh            # Powerlevel10k theme configuration
├── README.md           # This file
├── .gitignore          # Git ignore rules
└── docs/               # Documentation
    ├── architecture.md
    ├── requirements.md
    ├── testing.md
    ├── design.md
    └── api.md
```

## 🔄 Updating

To update your configuration:
```bash
cd ~/Desktop/git/zshrc  # or wherever you cloned it
git pull
./install.sh
```

## 📚 Additional Resources

- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [fzf Documentation](https://github.com/junegunn/fzf)
- [MesloLGS NF Fonts](https://github.com/romkatv/powerlevel10k-media)

## 🤝 Contributing

This is a personal configuration repository. Feel free to fork and customize for your own needs!

## 📄 License

Personal use. See repository for details.

## 👤 Author

**Misha Lubich**
- GitHub: [@ml-lubich](https://github.com/ml-lubich)
- Email: michaelle.lubich@gmail.com

---

**Note**: This setup is optimized for macOS but works on Linux as well. Some paths and commands may vary by OS.

## Architecture

This repository is intentionally small and well-organized:

### Core Files

- **`scripts/install.sh`**: Single entrypoint that orchestrates all setup steps (OS detection, package managers, fonts, shell configuration).
- **`zshrc`**: Template Zsh configuration that is copied to `~/.zshrc` (with automatic backup).
- **`config/p10k.zsh`**: Powerlevel10k prompt configuration that is copied to `~/.p10k.zsh` (only if it doesn't exist, preserving user customizations).

### Responsibilities

- **Bootstrap layer**: `scripts/install.sh` (imperative operations, installs and configures tools).
- **Shell configuration layer**: `zshrc` and `config/p10k.zsh` (user-level shell behavior).
- **Uninstall layer**: `scripts/uninstall.sh` (safe removal with confirmations).
- **Configuration layer**: `scripts/config.sh` (installation customization).

### File Handling

- **`zshrc`**: Always copied to `~/.zshrc` (existing file backed up as `~/.zshrc.pre-mlubich-backup`).
- **`config/p10k.zsh`**: Only copied to `~/.p10k.zsh` if it doesn't exist (preserves user customizations).
- Both files are tracked in git and properly handled by the installation script.




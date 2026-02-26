## Design

- **Single entrypoint**
  - `scripts/install.sh` is the one script you run; it orchestrates everything.

- **OS-specific behavior**
  - A small OS detection function chooses between macOS and Linux paths.
  - Linux-specific package installation is isolated in `install_zsh_and_git_linux`.

- **Explicit responsibilities**
  - Each major step (Homebrew install, Python, fonts, Oh My Zsh, Powerlevel10k, `.zshrc` & `.p10k.zsh`) has its own helper function.
  - No silent fallbacks: failures are logged, and the script exits on critical errors.

- **User safety**
  - Existing `~/.zshrc` is backed up once as `~/.zshrc.pre-install-backup` before modification.
  - On first install, the user's existing `~/.zshrc` is copied to `~/.zshrc.local` before overwrite, with bare `source`/`. ` lines wrapped in `[ -f ... ] &&` guards. This means uninstalling a third-party tool (which deletes its completion/init files) won't leave broken references that error on every shell start. That file is never overwritten. Our config runs first (adds tools), then sources `.zshrc.local`. User keeps all paths, vars, aliases.
  - `p10k.zsh` from repo is only copied to `~/.p10k.zsh` if it doesn't exist (preserves user customizations).
  - Both `zshrc` and `p10k.zsh` are tracked in git and properly handled by the installation script.

- **File organization**
  - Scripts in `scripts/` directory
  - Configuration templates: `zshrc` in root, `p10k.zsh` in `config/` directory
  - Tests in `tests/` directory
  - Documentation in `docs/` directory




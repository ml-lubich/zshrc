## Design

- **Single entrypoint**
  - `install.sh` is the one script you run; it orchestrates everything.

- **OS-specific behavior**
  - A small OS detection function chooses between macOS and Linux paths.
  - Linux-specific package installation is isolated in `install_zsh_and_git_linux`.

- **Explicit responsibilities**
  - Each major step (Homebrew install, Python, fonts, Oh My Zsh, Powerlevel10k, `.zshrc` & `.p10k.zsh`) has its own helper function.
  - No silent fallbacks: failures are logged, and the script exits on critical errors.

- **User safety**
  - Existing `~/.zshrc` is backed up once as `~/.zshrc.pre-mlubich-backup`.
  - Powerlevel10k configuration is only created if it does not already exist.




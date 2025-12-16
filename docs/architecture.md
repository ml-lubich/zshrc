## Architecture

This repository is intentionally small:

- **`install.sh`**: Single entrypoint that orchestrates all setup steps (OS detection, package managers, fonts, shell configuration).
- **`zshrc`**: Template Zsh configuration that is copied to `~/.zshrc`.
- **Optional `p10k.zsh`**: Powerlevel10k prompt configuration, if you choose to add one to the repo later.

Responsibilities are separated as:

- **Bootstrap layer**: `install.sh` (imperative operations, installs and configures tools).
- **Shell configuration layer**: `zshrc` and optional `p10k.zsh` (user-level shell behavior).




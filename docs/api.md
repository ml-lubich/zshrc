## Public interface

This repository exposes a single “public API”:

- **Script**
  - `install.sh`
    - Usage:
      ```bash
      ./scripts/install.sh
      ```
    - Behavior:
      - Detect OS.
      - Ensure Homebrew/Linuxbrew is installed and on `PATH`.
      - Install Python via Homebrew.
      - Ensure `zsh`, `git`, and `curl` are present (Linux).
      - Install MesloLGS Nerd Fonts (macOS/Linux).
      - Install Oh My Zsh and Powerlevel10k.
      - Configure `~/.zshrc` and `~/.p10k.zsh` using repo templates (if present).




## zshrc bootstrap

**Goal:** One‑shot setup script to get a fresh macOS or Linux dev environment using Zsh + Powerlevel10k with MesloLGS Nerd Fonts and a usable Python.

This repository is designed to be cloned to a new machine and then run:

```bash
cd zshrc
chmod +x install.sh
./install.sh
```

### What `install.sh` does

- **OS detection**
  - Supports **macOS** and **Linux** (modern distros with `apt`, `dnf`, or `yum`).

- **Homebrew / Linuxbrew**
  - Installs **Homebrew** (or **Linuxbrew**) if it is not present.
  - Adds Brew to the current shell session using `brew shellenv` so subsequent steps can use it.

- **Python**
  - Installs **latest stable Python** from Homebrew: `brew install python`.
  - Leaves any existing Python installs alone.

- **Zsh + Git (Linux only)**
  - If needed, installs `zsh`, `git`, and `curl` using `apt`, `dnf`, or `yum`.

- **Fonts (MesloLGS Nerd Fonts)**
  - Downloads MesloLGS Nerd Fonts from the official Powerlevel10k media repo.
  - Installs them to:
    - `~/Library/Fonts` on macOS.
    - `~/.local/share/fonts` on Linux (and runs `fc-cache` if available).

- **Powerlevel10k**
  - Installs Powerlevel10k into `~/.powerlevel10k` from GitHub.

- **Oh My Zsh**
  - Installs Oh My Zsh (non-interactively) into `~/.oh-my-zsh`.
  - Leaves any existing `~/.zshrc` backed up as `~/.zshrc.pre-mlubich-backup`.

- **Zsh configuration**
  - If a `zshrc` file exists in this repo, copies it to `~/.zshrc`.
  - Otherwise, generates a **minimal** `~/.zshrc` that:
    - Points `ZSH` to `~/.oh-my-zsh`
    - Sets `ZSH_THEME="powerlevel10k/powerlevel10k"`
    - Enables the `git` plugin
    - Sources `~/.p10k.zsh` if present

- **Powerlevel10k configuration**
  - If repo contains a `p10k.zsh`, copies it to `~/.p10k.zsh`.
  - Otherwise, defers to the interactive `p10k configure` wizard the first time a new Zsh session starts.

- **Default shell**
  - Attempts to set the default shell to `zsh` via `chsh -s "$(command -v zsh)"`.
  - If this fails (for example on locked-down systems), it logs a message pointing to the manual command.

### After running the script

1. **Restart your terminal.**
2. Set your terminal profile’s font to one of the **MesloLGS NF** fonts that were installed.
3. If Powerlevel10k prompts you, run:

```bash
p10k configure
```

to finish configuring your prompt.

If something goes wrong with your prompt or shell behavior, you can restore your previous configuration from:

- `~/.zshrc.pre-mlubich-backup`

### Git / Repository setup

Once you are happy with the setup, you can push this repository to GitHub (if not already done):

```bash
cd /Users/mlubich/Desktop/git/zshrc
git init
git remote add origin git@github.com:ml-lubich/zshrc.git
git add .
git commit -m "Add cross-platform zsh + Powerlevel10k bootstrap"
git branch -M main
git push -u origin main
```

### Ownership and license

- Author: **Misha Lubich** (`michaelle.lubich@gmail.com`)
- GitHub: `https://github.com/ml-lubich`



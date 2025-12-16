## Testing

This repository is primarily a shell/bootstrap setup, but we still enforce a clear, multi‑layer testing strategy:

- **Automated tests** (Python + pytest)
- **Manual smoke tests** (on a real machine / user account)
- **Safety guarantees** (no system file modifications, backups before changes)

The goal is to make the installer and uninstaller **safe, repeatable, and observable**.

---

## Automated Testing (pytest)

Automated tests live under `tests/` and are run with `pytest`. They **do not execute** the shell scripts end‑to‑end (to avoid mutating your real system); instead they:

- Validate shell script **syntax** with `bash -n`.
- Inspect script **content** for safety invariants and required functionality.
- Validate `zshrc` structure and content.

### How to Run

From the repo root:

```bash
cd ~/Desktop/git/zshrc  # or wherever you cloned this repo

# 1. Create and activate a virtualenv (recommended)
python3 -m venv .venv
source .venv/bin/activate

# 2. Install test dependencies
pip install -r requirements.txt

# 3. Run tests
pytest tests/ -v
```

This will run:

- `tests/test_install.py` – tests for `install.sh` and `uninstall.sh`
- `tests/test_zshrc_config.py` – tests for `zshrc` content and structure

Coverage is reported over the **Python test code** (shell scripts are treated as data, not as Python execution).

### What Automated Tests Cover

#### 1. Script Syntax & Executability

- `install.sh` and `uninstall.sh`:
  - Exist in the repo.
  - Are **executable** (`os.access(..., X_OK)`).
  - Pass `bash -n` (no syntax errors).

#### 2. Safety Invariants

- `install.sh`:
  - Uses `set -euo pipefail`.
  - Contains a backup mechanism:
    - Backs up `~/.zshrc` / `~/.p10k.zsh` to `*.pre-mlubich-backup` before overwriting.
    - Does not recreate the backup if it already exists.
  - Only modifies user‑space paths under `$HOME`.
  - Does **not** contain dangerous operations on `/etc` or similar system directories (any such patterns must appear only in comments).

- `uninstall.sh`:
  - Uses a `confirm` function and **always** asks for confirmation before destructive operations.
  - Attempts to restore from backups (`restore_backup`) before removing `~/.zshrc` or `~/.p10k.zsh`.

- Editor configs:
  - Automated tests assert that `install.sh` and `uninstall.sh` **do not reference**:
    - `.vimrc`
    - `init.vim`
    - `nvim` or `~/.config/nvim`
  - This guarantees we do **not** touch existing Vim/Neovim configuration.

#### 3. Cross‑Platform & Tooling

Tests inspect `install.sh` to ensure we:

- Detect OS and Linux distribution:
  - `detect_os`
  - `detect_linux_distro`
  - References to `/etc/os-release` or `redhat-release`.
- Support:
  - macOS (Apple Silicon & Intel) via `/opt/homebrew` and `/usr/local`.
  - Linux via `apt-get`, `dnf`, or `yum`.
- Have functions to install:
  - Homebrew / Linuxbrew.
  - Python (`install_python`), configurable via `PYTHON_VERSION`.
  - NVM + Node (`install_nvm`, `NODE_VERSION`).
  - Dev tools: `fzf`, `autojump`, `eza`, `bat`, `thefuck`, `lazygit`, `zsh-autosuggestions`, `zsh-syntax-highlighting`.
  - MesloLGS NF fonts on macOS and Linux.

#### 4. zshrc Content & Structure

`tests/test_zshrc_config.py` verifies that `zshrc`:

- Enables Powerlevel10k instant prompt.
- Configures Oh My Zsh and plugins (git, z, fzf, autojump, colored-man-pages, web-search, extract).
- Sources Homebrew‑installed plugins (autosuggestions, syntax highlighting) correctly.
- Defines and configures:
  - `mygit` function using `MYGIT_PROJECTS_DIR` and `MYGIT_EDITOR` env variables (no hardcoding your username).
  - Modern tool aliases for `eza`, `bat`, `thefuck`, `lazygit`, etc.
  - FZF integration with ripgrep (`rg`) and fd (`fd`/`fdfind`).
- Is organized into clear sections and contains helpful comments.

---

## Manual Smoke Testing

Because these scripts ultimately change your shell environment, we still require **manual smoke tests** on a real machine.

### Recommended Flow (New Machine or Throwaway User)

1. **Clone and Install**

   ```bash
   git clone git@github.com:ml-lubich/zshrc.git
   cd zshrc
   chmod +x scripts/install.sh scripts/uninstall.sh scripts/config.sh
   ./scripts/install.sh
   ```

2. **Verify Shell & Prompt**

   - Open a **new terminal**.
   - Confirm:
     - `zsh` starts without errors.
     - Powerlevel10k prompt appears.
     - Pressing Enter does not show any startup warnings.

3. **Verify Fonts**

   - Set the terminal font to **MesloLGS NF** following the README / INSTALLATION_GUIDE.
   - Confirm icons and glyphs render correctly in the prompt.

4. **Verify Tools**

   In a new zsh session, run:

   ```bash
   zsh --version
   python3 --version
   node --version || echo "Node not installed yet"
   git --version

   fzf --version || echo "fzf missing"
   rg --version  || echo "ripgrep missing"
   fd --version  || echo "fd missing"

   lazygit --version || echo "lazygit missing"
   ```

5. **Verify Custom Functions**

   ```bash
   mygit            # Should cd into $MYGIT_PROJECTS_DIR (default: ~/Desktop/git)
   mygit -n testapp # Should create & open a new project in your editor (MYGIT_EDITOR)
   ```

6. **Verify Uninstall**

   ```bash
   ./uninstall.sh
   ```

   - Confirm that it:
     - Asks for confirmation before each removal.
     - Offers to restore backups where available.
     - Leaves non‑zsh, non‑Powerlevel10k system state alone (Homebrew, Xcode tools, etc. are not removed unless you choose so).

---

## Edge Cases & Safety Considerations

The combination of automated and manual tests is designed to cover:

- Running `./install.sh` multiple times (idempotency).
- Existing `~/.zshrc` and `~/.p10k.zsh`:
  - They are backed up before first modification.
  - They can be restored manually or via `uninstall.sh`.
- Systems without:
  - Homebrew (installer will install it where appropriate).
  - Certain dev tools (installer will install them or warn and continue).
- No interaction with:
  - Vim / Neovim configs.
  - System `/etc` files or other global configuration.

If you extend the installer (e.g., add new tools or configs), you should:

1. Update or add tests under `tests/` to:
   - Assert the new behavior (e.g., new functions, new safety checks).
   - Assert you still don’t touch unwanted system/editor configs.
2. Update this `docs/testing.md` to reflect:
   - New smoke tests.
   - Any additional safety requirements.

---

## Summary

- **Automated tests** give fast feedback on script safety and structure.
- **Manual smoke tests** validate real environment behavior.
- **Backups + explicit confirmations** protect existing user setups.
- **No Vim/Neovim modification** is enforced both by design and by tests.

This combination is designed to give you high confidence that running `install.sh` and `uninstall.sh` will not “ruin” existing setups and will remain maintainable over time.

# Quick Start

## Step 1 - Clone and run

```bash
git clone https://github.com/ml-lubich/zshrc.git
cd zshrc
./scripts/install.sh
```

(or `git clone git@github.com:ml-lubich/zshrc.git` if you use SSH)

## Step 2 - Reload shell

```bash
exec zsh
```

## Step 3 - Set font

Set your terminal font to **MesloLGS NF** (required for icons).

- Terminal: Preferences → Profiles → Text → Font
- iTerm2: Preferences → Profiles → Text → Font
- VS Code / Cursor: Settings → Terminal Font

## Step 4 (optional) - Configure prompt

```bash
p10k configure
```

---

**Done.** Your shell now has Powerlevel10k, fzf, eza, bat, lazygit, and more.

| Command      | Description                    |
|-------------|--------------------------------|
| `mygit`     | Go to ~/dev                    |
| `mygit foo` | Go to ~/dev/foo                |
| `mygit -n x`| Create ~/dev/x and open editor |
| `f` / `fuck`| Fix last command typo         |
| `lg`        | LazyGit                        |
| `ls` / `ll` | eza (when installed)           |

**Your config:** Install copies your existing `~/.zshrc` to `~/.zshrc.local` on first run (bare `source` lines are guarded so uninstalled tools won't break your shell). Our tools go in `~/.zshrc`, yours stay in `.zshrc.local` (sourced at end). Nothing is replaced; we add tools on top.

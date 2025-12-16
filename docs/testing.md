## Testing

Because this repository is primarily a shell bootstrap, testing is focused on **manual verification**:

- **Dry run review**
  - Read `install.sh` before running to confirm it matches your expectations.

- **First run on a fresh machine or throwaway user**
  - Run:
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
  - Verify:
    - `zsh` starts without errors.
    - Powerlevel10k loads and the prompt appears.
    - MesloLGS NF fonts are selectable in the terminal and render correctly.
    - `python3 --version` shows a modern Python installed via Homebrew.

- **Smoke checks**
  - Open a new terminal and run:
    - `zsh --version`
    - `p10k configure` (verify the wizard runs).
    - `git --version`




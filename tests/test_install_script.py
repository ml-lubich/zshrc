"""
Tests for install.sh script functionality.

These tests verify the installation script logic, file operations, and configuration.
"""
import os
import subprocess
import tempfile
from pathlib import Path
import pytest


class TestInstallScriptStructure:
    """Test the structure and syntax of install.sh."""
    
    def test_install_script_exists(self, repo_dir):
        """Verify install.sh exists in the repository."""
        install_script = repo_dir / "scripts" / "install.sh"
        assert install_script.exists(), "install.sh should exist"
        assert install_script.is_file(), "install.sh should be a file"
    
    def test_install_script_is_executable(self, repo_dir):
        """Verify install.sh is executable."""
        install_script = repo_dir / "scripts" / "install.sh"
        assert os.access(install_script, os.X_OK), "install.sh should be executable"
    
    def test_install_script_syntax(self, repo_dir):
        """Verify install.sh has valid bash syntax."""
        install_script = repo_dir / "scripts" / "install.sh"
        result = subprocess.run(
            ["bash", "-n", str(install_script)],
            capture_output=True,
            text=True
        )
        assert result.returncode == 0, f"install.sh has syntax errors: {result.stderr}"
    
    def test_install_script_shebang(self, repo_dir):
        """Verify install.sh has correct shebang."""
        install_script = repo_dir / "scripts" / "install.sh"
        with open(install_script, "r") as f:
            first_line = f.readline().strip()
        assert first_line == "#!/usr/bin/env bash", "install.sh should have bash shebang"


class TestInstallScriptFunctions:
    """Test individual functions and logic in install.sh."""
    
    def test_install_script_contains_required_functions(self, repo_dir):
        """Verify install.sh contains required functions."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        
        required_functions = [
            "log",
            "err",
            "detect_os",
            "install_homebrew_macos",
            "install_homebrew_linux",
            "install_python",
            "install_dev_tools",
            "install_powerlevel10k",
            "configure_zshrc",
        ]
        
        for func in required_functions:
            assert f"{func}()" in content or f"function {func}" in content, \
                f"install.sh should contain function: {func}"
    
    def test_install_script_installs_fzf(self, repo_dir):
        """Verify install.sh includes fzf in dev tools."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        assert '"fzf"' in content, "install.sh should install fzf"
    
    def test_install_script_installs_ripgrep(self, repo_dir):
        """Verify install.sh includes ripgrep in dev tools."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        assert '"ripgrep"' in content or '"rg"' in content, "install.sh should install ripgrep"
    
    def test_install_script_installs_fd(self, repo_dir):
        """Verify install.sh includes fd in dev tools."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        assert '"fd"' in content, "install.sh should install fd"
    
    def test_install_script_handles_linux(self, repo_dir):
        """Verify install.sh has Linux-specific installation logic."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        assert "install_dev_tools_linux" in content, "install.sh should have Linux-specific dev tools installation"
        assert "install_zsh_and_git_linux" in content, "install.sh should install zsh/git on Linux"
    
    def test_install_script_handles_macos(self, repo_dir):
        """Verify install.sh has macOS-specific installation logic."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        assert "install_xcode" in content or "xcode-select" in content, \
            "install.sh should handle Xcode tools on macOS"
        assert "install_iterm2" in content or "iterm2" in content.lower(), \
            "install.sh should handle iTerm2 on macOS"


class TestInstallScriptSafety:
    """Test safety features of install.sh."""
    
    def test_install_script_backs_up_existing_zshrc(self, repo_dir):
        """Verify install.sh backs up existing .zshrc."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        assert "backup" in content.lower() or ".pre-" in content, \
            "install.sh should backup existing .zshrc"
    
    def test_install_script_uses_set_euo_pipefail(self, repo_dir):
        """Verify install.sh uses strict error handling."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        assert "set -euo pipefail" in content or "set -eu" in content, \
            "install.sh should use strict error handling (set -euo pipefail)"
    
    def test_install_script_does_not_modify_system_files(self, repo_dir):
        """Verify install.sh only modifies user files, not system files."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()
        
        # Should not modify system directories
        dangerous_paths = ["/usr/bin", "/usr/local/bin", "/etc", "/bin", "/sbin"]
        for path in dangerous_paths:
            # Allow comments or documentation mentioning these paths
            lines_with_path = [line for line in content.split('\n') 
                             if path in line and not line.strip().startswith('#')]
            # Should not have actual modifications to system paths
            assert not any('>' in line or '>>' in line or 'cp' in line or 'mv' in line 
                          for line in lines_with_path), \
                f"install.sh should not modify system path: {path}"

    def test_install_script_does_not_touch_vim_configs(self, repo_dir):
        """Verify install.sh does not modify Vim/Neovim configuration files."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()

        forbidden_vim_paths = [
            ".vimrc",
            "init.vim",
            ".config/nvim",
        ]

        for path in forbidden_vim_paths:
            assert path not in content, \
                f"install.sh should not reference Vim/Neovim config path: {path}"

    def test_install_script_never_removes_zshrc_directly(self, repo_dir):
        """Verify install.sh does not delete ~/.zshrc, relying on backups instead."""
        install_script = repo_dir / "scripts" / "install.sh"
        content = install_script.read_text()

        # Look for obviously destructive operations on .zshrc
        dangerous_patterns = [
            "rm -f \"$HOME/.zshrc\"",
            "rm -f \"${HOME}/.zshrc\"",
            "rm ~/.zshrc",
        ]

        for pattern in dangerous_patterns:
            assert pattern not in content, \
                "install.sh should never delete ~/.zshrc directly (must rely on backup/overwrite semantics)"


class TestConfigurationFiles:
    """Test configuration file handling."""
    
    def test_zshrc_exists(self, repo_dir):
        """Verify zshrc configuration file exists."""
        zshrc = repo_dir / "zshrc"
        assert zshrc.exists(), "zshrc configuration file should exist"
    
    def test_zshrc_contains_powerlevel10k(self, repo_dir):
        """Verify zshrc includes Powerlevel10k configuration."""
        zshrc = repo_dir / "zshrc"
        content = zshrc.read_text()
        assert "powerlevel10k" in content.lower(), "zshrc should configure Powerlevel10k"
    
    def test_zshrc_contains_fzf_config(self, repo_dir):
        """Verify zshrc includes fzf configuration."""
        zshrc = repo_dir / "zshrc"
        content = zshrc.read_text()
        assert "fzf" in content.lower(), "zshrc should configure fzf"
    
    def test_zshrc_contains_ripgrep_config(self, repo_dir):
        """Verify zshrc includes ripgrep configuration."""
        zshrc = repo_dir / "zshrc"
        content = zshrc.read_text()
        # Should have ripgrep integration with fzf
        assert "ripgrep" in content.lower() or "rg" in content, \
            "zshrc should configure ripgrep for fzf"
    
    def test_zshrc_contains_fd_config(self, repo_dir):
        """Verify zshrc includes fd configuration."""
        zshrc = repo_dir / "zshrc"
        content = zshrc.read_text()
        assert "fd" in content.lower() or "fdfind" in content.lower(), \
            "zshrc should configure fd for fzf"
    
    def test_zshrc_contains_rgg_function(self, repo_dir):
        """Verify zshrc includes rgg function for ripgrep + fzf."""
        zshrc = repo_dir / "zshrc"
        content = zshrc.read_text()
        assert "rgg()" in content or "function rgg" in content, \
            "zshrc should include rgg function for content search"


class TestUninstallScript:
    """Test uninstall.sh script."""
    
    def test_uninstall_script_exists(self, repo_dir):
        """Verify uninstall.sh exists."""
        uninstall_script = repo_dir / "scripts" / "uninstall.sh"
        assert uninstall_script.exists(), "uninstall.sh should exist"
    
    def test_uninstall_script_syntax(self, repo_dir):
        """Verify uninstall.sh has valid bash syntax."""
        uninstall_script = repo_dir / "scripts" / "uninstall.sh"
        result = subprocess.run(
            ["bash", "-n", str(uninstall_script)],
            capture_output=True,
            text=True
        )
        assert result.returncode == 0, f"uninstall.sh has syntax errors: {result.stderr}"
    
    def test_uninstall_script_safety(self, repo_dir):
        """Verify uninstall.sh has safety confirmations."""
        uninstall_script = repo_dir / "scripts" / "uninstall.sh"
        content = uninstall_script.read_text()
        assert "confirm" in content.lower(), "uninstall.sh should ask for confirmation"


class TestConfigFile:
    """Test config.sh configuration file."""
    
    def test_config_file_exists(self, repo_dir):
        """Verify config.sh exists."""
        config_file = repo_dir / "scripts" / "config.sh"
        assert config_file.exists(), "config.sh should exist"
    
    def test_config_file_has_variables(self, repo_dir):
        """Verify config.sh exports configuration variables."""
        config_file = repo_dir / "scripts" / "config.sh"
        content = config_file.read_text()
        assert "PYTHON_VERSION" in content, "config.sh should define PYTHON_VERSION"
        assert "NODE_VERSION" in content, "config.sh should define NODE_VERSION"
        assert "INSTALL_DEV_TOOLS" in content, "config.sh should define INSTALL_DEV_TOOLS"


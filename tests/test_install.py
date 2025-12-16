#!/usr/bin/env python3
"""
Comprehensive pytest tests for install.sh script
Tests script structure, safety, and functionality
"""

import os
import re
import subprocess
import pytest
from pathlib import Path

# Get repository root
REPO_DIR = Path(__file__).parent.parent
SCRIPTS_DIR = REPO_DIR / "scripts"
INSTALL_SCRIPT = SCRIPTS_DIR / "install.sh"
UNINSTALL_SCRIPT = SCRIPTS_DIR / "uninstall.sh"
ZSHRC_FILE = REPO_DIR / "zshrc"
P10K_FILE = REPO_DIR / "p10k.zsh"


class TestScriptSyntax:
    """Test script syntax and basic structure"""
    
    def test_install_script_exists(self):
        """Verify install.sh exists"""
        assert INSTALL_SCRIPT.exists(), "install.sh should exist"
    
    def test_install_script_executable(self):
        """Verify install.sh is executable"""
        assert os.access(INSTALL_SCRIPT, os.X_OK), "install.sh should be executable"
    
    def test_install_script_syntax(self):
        """Test install.sh bash syntax"""
        result = subprocess.run(
            ["bash", "-n", str(INSTALL_SCRIPT)],
            capture_output=True,
            text=True
        )
        assert result.returncode == 0, f"install.sh syntax error: {result.stderr}"
    
    def test_uninstall_script_exists(self):
        """Verify uninstall.sh exists"""
        assert UNINSTALL_SCRIPT.exists(), "uninstall.sh should exist"
    
    def test_uninstall_script_executable(self):
        """Verify uninstall.sh is executable"""
        assert os.access(UNINSTALL_SCRIPT, os.X_OK), "uninstall.sh should be executable"
    
    def test_uninstall_script_syntax(self):
        """Test uninstall.sh bash syntax"""
        result = subprocess.run(
            ["bash", "-n", str(UNINSTALL_SCRIPT)],
            capture_output=True,
            text=True
        )
        assert result.returncode == 0, f"uninstall.sh syntax error: {result.stderr}"


class TestScriptContent:
    """Test script content and structure"""
    
    def test_install_script_shebang(self):
        """Verify install.sh has correct shebang"""
        with open(INSTALL_SCRIPT) as f:
            first_line = f.readline().strip()
        assert first_line == "#!/usr/bin/env bash", "install.sh should have bash shebang"
    
    def test_install_script_set_euo_pipefail(self):
        """Verify install.sh uses strict error handling"""
        content = INSTALL_SCRIPT.read_text()
        assert "set -euo pipefail" in content, "install.sh should use 'set -euo pipefail'"
    
    def test_required_functions_exist(self):
        """Verify all required functions are defined"""
        content = INSTALL_SCRIPT.read_text()
        required_functions = [
            "log",
            "err",
            "detect_os",
            "install_homebrew_macos",
            "install_python",
            "install_nvm",
            "install_powerlevel10k",
            "configure_zshrc",
            "main"
        ]
        for func in required_functions:
            assert f"{func}()" in content, f"Function {func}() should be defined"
    
    def test_zshrc_file_exists(self):
        """Verify zshrc file exists"""
        assert ZSHRC_FILE.exists(), "zshrc file should exist"
    
    def test_p10k_file_exists(self):
        """Verify p10k.zsh file exists"""
        assert P10K_FILE.exists(), "p10k.zsh file should exist"


class TestSafetyChecks:
    """Test safety features and user data protection"""
    
    def test_backup_mechanism(self):
        """Verify backup mechanism exists"""
        content = INSTALL_SCRIPT.read_text()
        assert ".pre-mlubich-backup" in content or "BACKUP_EXISTING" in content, \
            "install.sh should create backups"
    
    def test_no_system_file_modification(self):
        """Verify script doesn't modify system files"""
        content = INSTALL_SCRIPT.read_text()
        # Check for dangerous system paths (excluding comments)
        dangerous_patterns = [
            r'rm\s+-rf\s+/etc/',
            r'cp\s+.*\s+/etc/',
            r'mv\s+.*\s+/etc/',
        ]
        for pattern in dangerous_patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            # Filter out comments
            for match in matches:
                line_num = content[:content.find(match)].count('\n') + 1
                line = content.split('\n')[line_num - 1]
                assert line.strip().startswith('#'), \
                    f"Potentially dangerous system file operation found: {match}"
    
    def test_only_user_directory_modifications(self):
        """Verify script only modifies user directories"""
        content = INSTALL_SCRIPT.read_text()
        # Script should only modify $HOME, not system directories
        # This is a basic check - more thorough testing would require execution
        assert "$HOME" in content or "~/" in content, \
            "Script should use $HOME for user directories"
    
    def test_uninstall_has_confirmations(self):
        """Verify uninstall script asks for confirmation"""
        content = UNINSTALL_SCRIPT.read_text()
        assert "confirm" in content.lower(), \
            "uninstall.sh should ask for confirmation before destructive operations"


class TestNoEditorConfigImpact:
    """Ensure we don't touch vim/neovim or other editor configs."""
    
    def test_install_does_not_reference_vim_configs(self):
        """install.sh should not modify vim/neovim config files."""
        content = INSTALL_SCRIPT.read_text()
        forbidden = [
            ".vimrc",
            "init.vim",
            "nvim",
            ".config/nvim",
        ]
        for marker in forbidden:
            assert marker not in content, f"install.sh should not reference {marker}"
    
    def test_uninstall_does_not_reference_vim_configs(self):
        """uninstall.sh should not modify vim/neovim config files."""
        content = UNINSTALL_SCRIPT.read_text()
        forbidden = [
            ".vimrc",
            "init.vim",
            "nvim",
            ".config/nvim",
        ]
        for marker in forbidden:
            assert marker not in content, f"uninstall.sh should not reference {marker}"


class TestGeneralizability:
    """Test that scripts are generalizable and not hardcoded"""
    
    def test_mygit_uses_env_vars(self):
        """Verify mygit function uses environment variables"""
        content = ZSHRC_FILE.read_text()
        assert "MYGIT_PROJECTS_DIR" in content, \
            "mygit should use MYGIT_PROJECTS_DIR environment variable"
        assert "MYGIT_EDITOR" in content, \
            "mygit should use MYGIT_EDITOR environment variable"
    
    def test_no_hardcoded_user_paths(self):
        """Verify no hardcoded user-specific paths"""
        content = ZSHRC_FILE.read_text()
        # Check for hardcoded /Users/ paths (excluding comments and MYGIT vars)
        hardcoded_pattern = r'/Users/[^/]+'
        matches = re.findall(hardcoded_pattern, content)
        for match in matches:
            # Check if it's in a comment or export statement
            line_num = content[:content.find(match)].count('\n')
            lines = content.split('\n')
            if line_num < len(lines):
                line = lines[line_num]
                # Allow in comments or MYGIT exports
                if not (line.strip().startswith('#') or 'MYGIT' in line or 'export' in line):
                    pytest.fail(f"Hardcoded user path found: {match} in line {line_num + 1}")
    
    def test_homebrew_path_detection(self):
        """Verify Homebrew path detection works for both architectures"""
        content = INSTALL_SCRIPT.read_text()
        assert "/opt/homebrew" in content, "Should support Apple Silicon"
        assert "/usr/local" in content or "$HOME/.linuxbrew" in content, \
            "Should support Intel Mac or Linux"


class TestOSSupport:
    """Test cross-platform support"""
    
    def test_os_detection_function(self):
        """Verify OS detection function exists"""
        content = INSTALL_SCRIPT.read_text()
        assert "detect_os" in content, "Should have OS detection function"
    
    def test_macos_specific_features(self):
        """Verify macOS-specific features are present"""
        content = INSTALL_SCRIPT.read_text()
        assert "install_xcode_tools" in content or "xcode-select" in content, \
            "Should install Xcode CLI tools on macOS"
        assert "install_iterm2" in content or "iterm2" in content.lower(), \
            "Should install iTerm2 on macOS"
    
    def test_linux_support(self):
        """Verify Linux support is present"""
        content = INSTALL_SCRIPT.read_text()
        assert "install_zsh_and_git_linux" in content, \
            "Should have Linux installation function"
        # Check for common Linux package managers
        assert any(pm in content for pm in ["apt-get", "dnf", "yum"]), \
            "Should support common Linux package managers"


class TestToolInstallation:
    """Test that required tools are installed"""
    
    def test_python_installation(self):
        """Verify Python installation function exists and is configurable"""
        content = INSTALL_SCRIPT.read_text()
        assert "install_python" in content, \
            "Should have Python installation function"
        # Should allow configuring a specific Python version via PYTHON_VERSION
        assert "PYTHON_VERSION" in content, \
            "Should allow configuring Python version via PYTHON_VERSION"
    
    def test_nvm_installation(self):
        """Verify NVM installation function exists"""
        content = INSTALL_SCRIPT.read_text()
        assert "install_nvm" in content, "Should have NVM installation function"
    
    def test_dev_tools_installation(self):
        """Verify development tools installation"""
        content = INSTALL_SCRIPT.read_text()
        required_tools = ["fzf", "autojump", "eza", "bat", "thefuck", "lazygit"]
        for tool in required_tools:
            assert tool in content.lower(), f"Should install {tool}"


class TestConfigurationFiles:
    """Test configuration file handling"""
    
    def test_zshrc_configuration(self):
        """Verify zshrc configuration function"""
        content = INSTALL_SCRIPT.read_text()
        assert "configure_zshrc" in content, "Should have zshrc configuration function"
    
    def test_p10k_configuration(self):
        """Verify p10k configuration function"""
        content = INSTALL_SCRIPT.read_text()
        assert "configure_p10k_config" in content, \
            "Should have p10k configuration function"
    
    def test_font_installation(self):
        """Verify font installation for both platforms"""
        content = INSTALL_SCRIPT.read_text()
        assert "install_meslo_fonts" in content or "MesloLGS" in content, "Should install MesloLGS fonts"
        assert "MesloLGS NF" in content, "Should install MesloLGS NF fonts"


class TestIdempotency:
    """Test that the script is idempotent (safe to run multiple times)"""
    
    def test_zshrc_idempotency_check(self):
        """Verify zshrc configuration checks for existing files"""
        content = INSTALL_SCRIPT.read_text()
        assert "cmp -s" in content or "already exists" in content.lower(), \
            "Should check if files exist before overwriting"
    
    def test_powerlevel10k_idempotency(self):
        """Verify Powerlevel10k installation is idempotent"""
        content = INSTALL_SCRIPT.read_text()
        assert "already present" in content.lower() or "already installed" in content.lower(), \
            "Should check if Powerlevel10k is already installed"
    
    def test_backup_only_once(self):
        """Verify backup is only created once"""
        content = INSTALL_SCRIPT.read_text()
        assert ".pre-mlubich-backup" in content, \
            "Should use backup naming convention"
        # Check that it doesn't create backup if one exists
        assert "! -f" in content or "not exist" in content.lower(), \
            "Should check if backup exists before creating"


class TestConfigurationHandling:
    """Test configuration file and environment variable handling"""
    
    def test_config_file_sourcing(self):
        """Verify config.sh is sourced if it exists"""
        content = INSTALL_SCRIPT.read_text()
        assert "config.sh" in content, "Should source config.sh if present"
    
    def test_environment_variables(self):
        """Verify environment variables are used for configuration"""
        content = INSTALL_SCRIPT.read_text()
        config_vars = [
            "PYTHON_VERSION",
            "NODE_VERSION",
            "INSTALL_ITERM2",
            "INSTALL_XCODE_TOOLS",
            "BACKUP_EXISTING"
        ]
        for var in config_vars:
            assert var in content, f"Should use {var} environment variable"


class TestErrorHandling:
    """Test error handling and safety checks"""
    
    def test_error_exit_on_failure(self):
        """Verify script exits on critical errors"""
        content = INSTALL_SCRIPT.read_text()
        assert "set -euo pipefail" in content, \
            "Should exit on error (set -e)"
        assert "exit 1" in content, \
            "Should explicitly exit on errors"
    
    def test_require_cmd_function(self):
        """Verify require_cmd function exists for dependency checking"""
        content = INSTALL_SCRIPT.read_text()
        assert "require_cmd" in content, \
            "Should have require_cmd function to check dependencies"


class TestLinuxSupport:
    """Test Linux-specific functionality"""
    
    def test_linux_distro_detection(self):
        """Verify Linux distribution detection"""
        content = INSTALL_SCRIPT.read_text()
        assert "detect_linux_distro" in content, \
            "Should detect Linux distribution"
        assert "/etc/os-release" in content or "redhat-release" in content, \
            "Should check standard Linux distro files"
    
    def test_linux_package_managers(self):
        """Verify support for common Linux package managers"""
        content = INSTALL_SCRIPT.read_text()
        package_managers = ["apt-get", "dnf", "yum"]
        found = any(pm in content for pm in package_managers)
        assert found, \
            "Should support at least one Linux package manager"


if __name__ == "__main__":
    pytest.main([__file__, "-v", "--cov=../", "--cov-report=term-missing"])

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
INSTALL_SCRIPT = REPO_DIR / "install.sh"
UNINSTALL_SCRIPT = REPO_DIR / "uninstall.sh"
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
        assert "BACKUP_SUFFIX" in content or ".pre-mlubich-backup" in content, \
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
        assert "install_xcode_cli_tools_macos" in content or "xcode-select" in content, \
            "Should install Xcode CLI tools on macOS"
        assert "install_iterm2_macos" in content or "iterm2" in content.lower(), \
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
        """Verify Python installation function exists"""
        content = INSTALL_SCRIPT.read_text()
        assert "install_python" in content, \
            "Should have Python installation function"
        # Should fallback to Python 3.10 if latest fails
        assert "python@3.10" in content or "python3.10" in content, \
            "Should have fallback to Python 3.10"
    
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
        assert "install_meslo_fonts" in content, "Should install MesloLGS fonts"
        assert "MesloLGS NF" in content, "Should install MesloLGS NF fonts"


if __name__ == "__main__":
    pytest.main([__file__, "-v", "--cov=../", "--cov-report=term-missing"])

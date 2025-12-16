"""
Tests for zshrc configuration file content and structure.
"""
import re
from pathlib import Path
import pytest


class TestZshrcContent:
    """Test zshrc configuration file content."""
    
    @pytest.fixture
    def zshrc_content(self, repo_dir):
        """Load zshrc file content."""
        zshrc = repo_dir / "zshrc"
        return zshrc.read_text()
    
    def test_zshrc_has_instant_prompt(self, zshrc_content):
        """Verify zshrc includes Powerlevel10k instant prompt."""
        assert "p10k-instant-prompt" in zshrc_content, \
            "zshrc should include Powerlevel10k instant prompt"
    
    def test_zshrc_has_oh_my_zsh(self, zshrc_content):
        """Verify zshrc configures Oh My Zsh."""
        assert "oh-my-zsh" in zshrc_content.lower() or "ZSH=" in zshrc_content, \
            "zshrc should configure Oh My Zsh"
    
    def test_zshrc_has_plugins(self, zshrc_content):
        """Verify zshrc includes plugin configuration."""
        assert "plugins=" in zshrc_content or "plugin" in zshrc_content.lower(), \
            "zshrc should configure plugins"
    
    def test_zshrc_has_fzf_plugin(self, zshrc_content):
        """Verify zshrc includes fzf plugin."""
        # Check for fzf in plugins array or fzf configuration
        assert "fzf" in zshrc_content.lower(), "zshrc should include fzf"
    
    def test_zshrc_has_autosuggestions(self, zshrc_content):
        """Verify zshrc includes zsh-autosuggestions."""
        assert "zsh-autosuggestions" in zshrc_content, \
            "zshrc should include zsh-autosuggestions"
    
    def test_zshrc_has_syntax_highlighting(self, zshrc_content):
        """Verify zshrc includes zsh-syntax-highlighting."""
        assert "zsh-syntax-highlighting" in zshrc_content, \
            "zshrc should include zsh-syntax-highlighting"
    
    def test_zshrc_has_nvm_config(self, zshrc_content):
        """Verify zshrc includes NVM configuration."""
        assert "NVM_DIR" in zshrc_content or "nvm" in zshrc_content.lower(), \
            "zshrc should configure NVM"
    
    def test_zshrc_has_mygit_function(self, zshrc_content):
        """Verify zshrc includes mygit function."""
        assert "mygit()" in zshrc_content or "function mygit" in zshrc_content, \
            "zshrc should include mygit function"
    
    def test_zshrc_has_modern_tools(self, zshrc_content):
        """Verify zshrc includes modern tool aliases."""
        modern_tools = ["eza", "bat", "thefuck", "lazygit"]
        for tool in modern_tools:
            assert tool in zshrc_content.lower(), f"zshrc should configure {tool}"
    
    def test_zshrc_has_fzf_ripgrep_integration(self, zshrc_content):
        """Verify zshrc integrates fzf with ripgrep."""
        # Should have FZF_DEFAULT_COMMAND or ripgrep configuration
        assert "FZF" in zshrc_content or "ripgrep" in zshrc_content.lower() or "rg" in zshrc_content, \
            "zshrc should integrate fzf with ripgrep"
    
    def test_zshrc_has_fzf_fd_integration(self, zshrc_content):
        """Verify zshrc integrates fzf with fd."""
        # Should have fd configuration for fzf
        assert "fd" in zshrc_content.lower() or "fdfind" in zshrc_content.lower(), \
            "zshrc should integrate fzf with fd"
    
    def test_zshrc_has_rgg_function(self, zshrc_content):
        """Verify zshrc includes rgg function for content search."""
        assert "rgg()" in zshrc_content or "function rgg" in zshrc_content, \
            "zshrc should include rgg function for ripgrep + fzf search"
    
    def test_zshrc_has_ff_alias(self, zshrc_content):
        """Verify zshrc includes ff alias for fzf."""
        # Check for alias ff or function ff
        assert re.search(r'alias\s+ff\s*=', zshrc_content) or "ff=" in zshrc_content, \
            "zshrc should include ff alias for fzf file finder"


class TestZshrcStructure:
    """Test zshrc file structure and organization."""
    
    @pytest.fixture
    def zshrc_content(self, repo_dir):
        """Load zshrc file content."""
        zshrc = repo_dir / "zshrc"
        return zshrc.read_text()
    
    def test_zshrc_has_sections(self, zshrc_content):
        """Verify zshrc is organized into sections."""
        # Should have section comments
        assert "====" in zshrc_content or "#" in zshrc_content[:100], \
            "zshrc should be organized into sections"
    
    def test_zshrc_has_comments(self, zshrc_content):
        """Verify zshrc has helpful comments."""
        comment_lines = [line for line in zshrc_content.split('\n') 
                        if line.strip().startswith('#') and len(line.strip()) > 1]
        assert len(comment_lines) > 5, "zshrc should have helpful comments"


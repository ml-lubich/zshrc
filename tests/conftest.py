"""
Pytest configuration and fixtures for testing zshrc installation scripts.
"""
import os
import tempfile
import shutil
from pathlib import Path
import pytest


@pytest.fixture
def temp_home(tmp_path):
    """Create a temporary home directory for testing."""
    home = tmp_path / "home"
    home.mkdir()
    return home


@pytest.fixture
def repo_dir():
    """Get the repository root directory."""
    return Path(__file__).parent.parent


@pytest.fixture
def mock_install_dir(tmp_path):
    """Create a mock installation directory structure."""
    install_dir = tmp_path / "install"
    install_dir.mkdir()
    
    # Create mock files
    (install_dir / "zshrc").write_text("# Mock zshrc file\n")
    (install_dir / "config").mkdir(exist_ok=True)
    (install_dir / "config" / "p10k.zsh").write_text("# Mock p10k config\n")
    (install_dir / "install.sh").write_text("#!/bin/bash\necho 'mock install'\n")
    
    return install_dir


@pytest.fixture
def mock_env(monkeypatch, temp_home):
    """Mock environment variables for testing."""
    monkeypatch.setenv("HOME", str(temp_home))
    monkeypatch.setenv("SHELL", "/bin/bash")
    return temp_home


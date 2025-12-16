#!/usr/bin/env bash
# Configuration file for zshrc installation
# This file can be sourced to customize installation behavior

# Python version to install
# Options: "latest" (installs latest stable), "3.10", "3.11", "3.12", etc.
export PYTHON_VERSION="${PYTHON_VERSION:-latest}"

# Node.js version to install via NVM
# Options: "latest" (installs latest LTS), "lts", or specific version like "20", "18", etc.
export NODE_VERSION="${NODE_VERSION:-lts}"

# Install iTerm2 on macOS (default: true)
export INSTALL_ITERM2="${INSTALL_ITERM2:-true}"

# Install Xcode Command Line Tools on macOS (default: true)
export INSTALL_XCODE_TOOLS="${INSTALL_XCODE_TOOLS:-true}"

# Backup existing configuration files (default: true)
export BACKUP_EXISTING="${BACKUP_EXISTING:-true}"

# Install development tools via Homebrew (default: true)
export INSTALL_DEV_TOOLS="${INSTALL_DEV_TOOLS:-true}"

# Install Oh My Zsh (default: true)
export INSTALL_OH_MY_ZSH="${INSTALL_OH_MY_ZSH:-true}"

# Install Powerlevel10k (default: true)
export INSTALL_POWERLEVEL10K="${INSTALL_POWERLEVEL10K:-true}"

# Install MesloLGS NF Fonts (default: true)
export INSTALL_FONTS="${INSTALL_FONTS:-true}"

# Install NVM (default: true)
export INSTALL_NVM="${INSTALL_NVM:-true}"

# Set default shell to zsh (default: true)
export SET_DEFAULT_SHELL="${SET_DEFAULT_SHELL:-true}"


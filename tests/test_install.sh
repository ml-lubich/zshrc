#!/usr/bin/env bash

# Integration tests for install.sh
# These tests verify the install script functions correctly

set -euo pipefail

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$TEST_DIR/.." && pwd)"

test_count=0
pass_count=0
fail_count=0

test_pass() {
  ((test_count++))
  ((pass_count++))
  echo "✅ PASS: $1"
}

test_fail() {
  ((test_count++))
  ((fail_count++))
  echo "❌ FAIL: $1"
  return 1
}

test_syntax_check() {
  if bash -n "$REPO_DIR/install.sh"; then
    test_pass "install.sh syntax check"
  else
    test_fail "install.sh syntax check"
  fi
}

test_uninstall_syntax_check() {
  if bash -n "$REPO_DIR/uninstall.sh"; then
    test_pass "uninstall.sh syntax check"
  else
    test_fail "uninstall.sh syntax check"
  fi
}

test_zshrc_exists() {
  if [ -f "$REPO_DIR/zshrc" ]; then
    test_pass "zshrc file exists"
  else
    test_fail "zshrc file exists"
  fi
}

test_p10k_exists() {
  if [ -f "$REPO_DIR/p10k.zsh" ]; then
    test_pass "p10k.zsh file exists"
  else
    test_fail "p10k.zsh file exists"
  fi
}

test_install_functions_defined() {
  local functions=(
    "log"
    "err"
    "detect_os"
    "install_homebrew_macos"
    "install_python"
    "install_nvm"
    "install_oh_my_zsh"
    "configure_zshrc"
  )
  
  local all_found=true
  for func in "${functions[@]}"; do
    # Check for function definition (with or without spaces before the parenthesis)
    if ! grep -qE "^${func}\s*\(\)" "$REPO_DIR/install.sh"; then
      test_fail "Function $func not found in install.sh"
      all_found=false
    fi
  done
  
  if [ "$all_found" = true ]; then
    test_pass "All required functions defined in install.sh"
  fi
}

test_safety_checks() {
  # Check that install.sh doesn't modify system files
  # Look for /etc/ references that WRITE (not read-only)
  # Reading from /etc/os-release is safe
  local dangerous_ops
  dangerous_ops=$(grep -nE "(rm|cp|mv|>|>>).*\/etc\/" "$REPO_DIR/install.sh" | grep -v "^[[:space:]]*#" || true)
  if [ -n "$dangerous_ops" ]; then
    test_fail "install.sh may modify system files in /etc/: $dangerous_ops"
  else
    test_pass "install.sh doesn't modify system files"
  fi
  
  # Check that backups are created
  if grep -q "BACKUP_SUFFIX\|\.pre-mlubich-backup" "$REPO_DIR/install.sh"; then
    test_pass "install.sh creates backups"
  else
    test_fail "install.sh doesn't create backups"
  fi
}

test_mygit_generalizable() {
  # Check that mygit uses environment variables
  if grep -q "MYGIT_PROJECTS_DIR\|MYGIT_EDITOR" "$REPO_DIR/zshrc"; then
    test_pass "mygit function is generalizable (uses env vars)"
  else
    test_fail "mygit function is not generalizable"
  fi
}

test_no_hardcoded_paths() {
  # Check for hardcoded user paths (should use $HOME)
  if grep -E "/Users/[^/]+" "$REPO_DIR/zshrc" | grep -v "#.*/Users/" | grep -v "export.*MYGIT"; then
    test_fail "zshrc contains hardcoded user paths"
  else
    test_pass "zshrc doesn't contain hardcoded user paths"
  fi
}

main() {
  echo "Running install.sh tests..."
  echo ""
  
  test_syntax_check
  test_uninstall_syntax_check
  test_zshrc_exists
  test_p10k_exists
  test_install_functions_defined
  test_safety_checks
  test_mygit_generalizable
  test_no_hardcoded_paths
  
  echo ""
  echo "=========================================="
  echo "Test Results:"
  echo "  Total:  $test_count"
  echo "  Passed: $pass_count"
  echo "  Failed: $fail_count"
  echo "=========================================="
  
  if [ $fail_count -eq 0 ]; then
    echo "✅ All tests passed!"
    exit 0
  else
    echo "❌ Some tests failed."
    exit 1
  fi
}

main "$@"


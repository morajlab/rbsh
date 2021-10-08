#!/bin/bash

# Check Shellspec is installed
check_shellspec_installed() {
  if command -v shellspec &> /dev/null; then
    echo "true"
  fi
}

# Install Shellspec latest version
install_shellspec() {
  curl -fsSL https://git.io/shellspec | sh -s -- --yes
}

# Check prerequisite are installed
check_prerequisite() {
  if [[ $(check_shellspec_installed) != "true" ]]; then
    install_shellspec || exit 1
  fi
}

# Run test script
check_prerequisite

shellspec $*

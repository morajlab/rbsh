#!/bin/bash

DOWNLOAD_SOURCE_URL="https://github.com/morajlab/rbsh.git"
INSTALL_PATH="$HOME/.rbsh_src"

# Check if target object is installed
is_installed() {
  type "$1" > /dev/null 2>&1
}

# Download and extract source code
download_rbsh() {
  cd /tmp/

  if is_installed "git"; then
    git clone $DOWNLOAD_SOURCE_URL $INSTALL_PATH && rm -rf $INSTALL_PATH/.git
  elif is_installed "curl"; then
    curl -SLO $DOWNLOAD_SOURCE_URL | tar -xf - -C $INSTALL_PATH
  elif is_installed "wget"; then
    wget -qO- $DOWNLOAD_SOURCE_URL | tar -xf - -C $INSTALL_PATH
  fi
}

# Add binary path to PATH env variable
add_path() {
cat >> ~/.bashrc <<- EOF
if ! command -v rbsh &> /dev/null; then
  export PATH="$INSTALL_PATH/bin:\$PATH"
fi
EOF
}

download_rbsh && add_path

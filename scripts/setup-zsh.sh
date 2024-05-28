#!/bin/bash

# Function to check if zsh is already installed
check_zsh_installed() {
  if command -v zsh &> /dev/null; then
    echo "zsh is already installed."
    exit 0
  fi
}

# Function to install zsh on Fedora
install_zsh_fedora() {
  echo "Detected Fedora. Installing zsh using dnf..."
  sudo dnf install -y zsh
  if [ $? -eq 0 ]; then
    echo "zsh installed successfully on Fedora."
  else
    echo "Failed to install zsh on Fedora."
  fi
}

# Function to install zsh on macOS
install_zsh_macos() {
  echo "Detected macOS. Installing zsh using brew..."
  if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing Homebrew first..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install zsh
  if [ $? -eq 0 ]; then
    echo "zsh installed successfully on macOS."
  else
    echo "Failed to install zsh on macOS."
  fi
}

# Check if zsh is already installed
check_zsh_installed

# Detect operating system and install zsh
if [ -f /etc/fedora-release ]; then
  install_zsh_fedora
elif [ "$(uname)" == "Darwin" ]; then
  install_zsh_macos
else
  echo "Unsupported operating system."
fi

# install omz
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

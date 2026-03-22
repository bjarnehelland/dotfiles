#!/usr/bin/env bash

set -o errexit

DOTFILES_REPO="https://github.com/bjarnehelland/dotfiles.git"
DOTFILES_DIR="$HOME/Code/bjarnehelland/dotfiles"

reset_color=$(tput sgr 0)

info() {
  printf "%s[*] %s%s\n" "$(tput setaf 4)" "$1" "$reset_color"
}

success() {
  printf "%s[*] %s%s\n" "$(tput setaf 2)" "$1" "$reset_color"
}

warn() {
  printf "%s[*] %s%s\n" "$(tput setaf 3)" "$1" "$reset_color"
}

install_xcode() {
  if xcode-select -p >/dev/null 2>&1; then
    warn "xCode Command Line Tools already installed"
  else
    info "Installing xCode Command Line Tools..."
    xcode-select --install
    info "Waiting for xCode Command Line Tools installation to complete..."
    until xcode-select -p >/dev/null 2>&1; do
      sleep 5
    done
    success "xCode Command Line Tools installed"
    sudo xcodebuild -license accept
  fi
}

clone_dotfiles() {
  if [ -d "$DOTFILES_DIR/.git" ]; then
    warn "Dotfiles already cloned at $DOTFILES_DIR"
  else
    info "Cloning dotfiles..."
    mkdir -p "$(dirname "$DOTFILES_DIR")"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
}

install_homebrew() {
  if command -v brew &>/dev/null; then
    warn "Homebrew already installed"
  else
    info "Installing Homebrew..."
    sudo --validate
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_packages() {
  info "Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/brew/Brewfile"
}

stow_dotfiles() {
  info "Stowing dotfiles..."
  local packages
  packages=$(find "$DOTFILES_DIR/stow" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort)

  for pkg in $packages; do
    info "  Stowing $pkg"
    stow -d "$DOTFILES_DIR/stow" --target "$HOME" "$pkg"
  done
}

setup_ssh() {
  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    warn "SSH key already exists"
  else
    info "Generating SSH key..."
    bash "$DOTFILES_DIR/scripts/generate_github_ssh.sh"
  fi

  echo ""
  info "Your SSH public key has been copied to the clipboard."
  info "Add it to GitHub: https://github.com/settings/keys"
  echo ""
  read -rp "Press Enter after adding the key to GitHub to switch the remote to SSH..."

  git -C "$DOTFILES_DIR" remote set-url origin git@github.com:bjarnehelland/dotfiles.git
  success "Remote switched to SSH"
}

info "########################"
info "####### dotfiles #######"
info "########################"

install_xcode
clone_dotfiles
install_homebrew
install_packages
stow_dotfiles
setup_ssh

success "Done! Run 'make macos' to configure macOS defaults."

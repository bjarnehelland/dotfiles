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

# Prompt for sudo once, then refresh the timestamp in the background so
# long-running steps (brew bundle casks, xcodebuild) don't re-prompt.
keep_sudo_alive() {
  info "Caching sudo credentials (asked once, kept alive in background)..."
  sudo --validate
  (
    while sudo --non-interactive true 2>/dev/null; do
      sleep 60
      kill -0 "$$" 2>/dev/null || exit
    done
  ) &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
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
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_packages() {
  info "Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/brew/Brewfile"

  echo ""
  read -rp "Install work (Stacc) packages? [y/N] " work
  if [[ "$work" =~ ^[Yy]$ ]]; then
    info "Installing work packages from Brewfile.work..."
    brew bundle --file="$DOTFILES_DIR/brew/Brewfile.work"
  fi
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

  if gh auth status >/dev/null 2>&1; then
    warn "Already logged in to GitHub CLI"
  else
    info "Logging in to GitHub CLI..."
    gh auth login
  fi

  # Detect the existing key on GitHub by matching a prefix of its base64 body
  local key_prefix
  key_prefix=$(awk '{print $2}' "$HOME/.ssh/id_ed25519.pub" | cut -c1-40)
  local title
  title=$(scutil --get ComputerName)

  if gh ssh-key list 2>/dev/null | grep -qF "$key_prefix"; then
    warn "SSH key already added to GitHub"
  else
    info "Adding SSH key to GitHub for authentication and signing..."
    gh ssh-key add "$HOME/.ssh/id_ed25519.pub" --title "$title" --type authentication
    gh ssh-key add "$HOME/.ssh/id_ed25519.pub" --title "$title" --type signing
  fi

  local ssh_remote="git@github.com:bjarnehelland/dotfiles.git"
  if [[ "$(git -C "$DOTFILES_DIR" remote get-url origin 2>/dev/null)" == "$ssh_remote" ]]; then
    warn "Dotfiles remote already set to SSH"
  else
    git -C "$DOTFILES_DIR" remote set-url origin "$ssh_remote"
    success "Dotfiles remote switched to SSH"
  fi
}

info "########################"
info "####### dotfiles #######"
info "########################"

keep_sudo_alive
install_xcode
clone_dotfiles
install_homebrew
install_packages
stow_dotfiles
setup_ssh

success "Done! Run 'make macos' to configure macOS defaults."

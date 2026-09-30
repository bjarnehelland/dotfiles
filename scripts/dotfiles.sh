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
    return 0
  fi

  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Locate the brew binary (Apple Silicon vs Intel)
  local brew_path
  if [[ -x /opt/homebrew/bin/brew ]]; then
    brew_path="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_path="/usr/local/bin/brew"
  else
    warn "Could not locate brew binary after install — aborting"
    exit 1
  fi

  # Make brew available for the rest of this script
  eval "$("$brew_path" shellenv)"

  # Persist to ~/.zprofile so future shells pick brew up (matches the
  # post-install instructions Homebrew prints)
  local zprofile="$HOME/.zprofile"
  local shellenv_line="eval \"\$($brew_path shellenv)\""
  if ! grep -qF "$shellenv_line" "$zprofile" 2>/dev/null; then
    info "Adding Homebrew shellenv to ~/.zprofile..."
    {
      echo ""
      echo "$shellenv_line"
    } >> "$zprofile"
  fi
}

install_packages() {
  info "Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/brew/Brewfile"
}

# Claude Code is installed with its native installer rather than the Homebrew
# cask so the binary can auto-update itself. It lands in ~/.local/bin, which
# .zshenv puts ahead of /opt/homebrew/bin on PATH.
install_claude_code() {
  if [ -x "$HOME/.local/bin/claude" ]; then
    warn "Claude Code already installed"
  else
    info "Installing Claude Code (native installer)..."
    curl -fsSL https://claude.ai/install.sh | bash
  fi
}

install_pi() {
  if npm list -g @mariozechner/pi-coding-agent --depth=0 >/dev/null 2>&1; then
    warn "pi-coding-agent already installed"
  else
    info "Installing pi-coding-agent..."
    npm install -g @mariozechner/pi-coding-agent
  fi
}

# Herdr plugins are a git checkout plus a binary built on install, so they are
# installed rather than stowed — only config.toml belongs in the repo. The
# build step shells out to go, which the Brewfile provides.
install_herdr_plugins() {
  local plugins=("kryptamine/herdr-auto-title")

  for repo in "${plugins[@]}"; do
    if herdr plugin list 2>/dev/null | grep -qF "github:$repo@"; then
      warn "Herdr plugin $repo already installed"
    else
      info "Installing Herdr plugin $repo..."
      herdr plugin install --yes "$repo"
    fi
  done
}

# Herdr's agent-state hooks are generated per agent and stamped with an
# integration version ("managed by herdr; reinstalling or updating the
# integration overwrites this file"), so they are installed rather than
# stowed — herdr owns the file and rewrites it on every update.
install_herdr_integrations() {
  local integrations=("claude" "pi")

  # Installing pi's npm package does not create its runtime directories.
  # Herdr requires the extension directory to exist before installing its hook.
  mkdir -p "$HOME/.pi/agent/extensions"

  for name in "${integrations[@]}"; do
    if herdr integration status 2>/dev/null | grep -qE "^${name}: current"; then
      warn "Herdr integration $name already current"
    else
      info "Installing Herdr integration $name..."
      herdr integration install "$name"
    fi
  done
}

stow_dotfiles() {
  info "Stowing dotfiles..."

  # Ensure ~/.claude (and skills/, hooks/) exist as real directories before
  # stowing so stow symlinks individual keep-list files instead of folding the
  # whole tree into one symlink (which would make Claude write all its runtime
  # data into the repo). hooks/ matters especially: herdr generates its own
  # hook in there, and a folded symlink would land it inside the repo.
  mkdir -p "$HOME/.claude/skills" "$HOME/.claude/hooks"

  # Same for lazygit: it writes state.yml next to config.yml, which would
  # land in the repo if stow folded the directory into a symlink.
  mkdir -p "$HOME/Library/Application Support/lazygit"

  local packages
  packages=$(find "$DOTFILES_DIR/stow" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort)

  for pkg in $packages; do
    info "  Stowing $pkg"
    stow -d "$DOTFILES_DIR/stow" --target "$HOME" "$pkg"
  done
}

# Populate ~/.config/git/allowed_signers so git can verify SSH signatures
# locally (git log --show-signature, git verify-commit). The stowed
# gitconfig already enables signing and points at this file.
configure_git_signing() {
  local signers_file="$HOME/.config/git/allowed_signers"
  local pub
  pub=$(cat "$HOME/.ssh/id_ed25519.pub")
  local email
  email=$(git config --global user.email)
  local entry="$email $pub"

  mkdir -p "$(dirname "$signers_file")"
  touch "$signers_file"

  if grep -qF "$pub" "$signers_file"; then
    warn "Allowed-signers already contains this key"
  else
    info "Adding SSH key to git allowed_signers..."
    printf '%s\n' "$entry" >> "$signers_file"
    success "Allowed-signers updated"
  fi
}

configure_github_known_hosts() {
  local known_hosts="$HOME/.ssh/known_hosts"

  if ssh-keygen -F github.com -f "$known_hosts" >/dev/null 2>&1; then
    warn "GitHub SSH host key already configured"
    return 0
  fi

  # Published by GitHub; avoid trusting an unverified ssh-keyscan response.
  # https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
  info "Adding GitHub SSH host key..."
  mkdir -p "$HOME/.ssh"
  printf '\ngithub.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl\n' >> "$known_hosts"
}

setup_ssh() {
  configure_github_known_hosts

  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    warn "SSH key already exists"
  else
    info "Generating SSH key..."
    bash "$DOTFILES_DIR/scripts/generate_github_ssh.sh"
  fi

  if gh auth status --hostname github.com >/dev/null 2>&1; then
    warn "Already logged in to GitHub CLI"
  else
    info "Logging in to GitHub CLI..."
    gh auth login --hostname github.com --scopes admin:ssh_signing_key
  fi

  # Existing logins may predate signing-key registration in setup.
  if ! gh api --hostname github.com user/ssh_signing_keys >/dev/null 2>&1; then
    info "Requesting GitHub SSH signing-key access..."
    gh auth refresh --hostname github.com --scopes admin:ssh_signing_key
    gh api --hostname github.com user/ssh_signing_keys >/dev/null
  fi

  # Detect the existing key on GitHub by matching a prefix of its base64 body.
  # GitHub stores auth and signing as separate registrations even for the same
  # key, so we check each type independently.
  local key_prefix
  key_prefix=$(awk '{print $2}' "$HOME/.ssh/id_ed25519.pub" | cut -c1-40)
  local title
  title=$(scutil --get ComputerName)

  # gh ssh-key list output is tab-separated: TITLE\tKEY\tADDED\tID\tTYPE
  local registered_types
  local registered_keys
  registered_keys=$(gh ssh-key list)
  registered_types=$(printf '%s\n' "$registered_keys" | awk -F'\t' -v k="$key_prefix" 'index($2, k) { print $5 }')

  if echo "$registered_types" | grep -qx "authentication"; then
    warn "SSH key already registered on GitHub for authentication"
  else
    info "Adding SSH key to GitHub for authentication..."
    gh ssh-key add "$HOME/.ssh/id_ed25519.pub" --title "$title" --type authentication
  fi

  if echo "$registered_types" | grep -qx "signing"; then
    warn "SSH key already registered on GitHub for signing"
  else
    info "Adding SSH key to GitHub for signing..."
    gh ssh-key add "$HOME/.ssh/id_ed25519.pub" --title "$title" --type signing
  fi

  configure_git_signing

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
install_claude_code
install_pi
install_herdr_plugins
stow_dotfiles
install_herdr_integrations
setup_ssh

success "Done! Run 'make macos' to configure macOS defaults."

# Bjarne dotfiles

This is the home of all my dotfiles. These are files that add custom configurations to my computer and applications, primarily the terminal.

## How to install

1. Clone this repo:
```sh
git clone git@github.com:bjarnehelland/dotfiles.git ~/Code/bjarnehelland/dotfiles
cd ~/Code/bjarnehelland/dotfiles
```

2. Run the setup script (installs Xcode CLI tools, Homebrew, packages, and stows dotfiles):
```sh
make setup
```

3. Configure macOS defaults:
```sh
make macos
```

## Usage

```sh
make brew   # Install/update Homebrew packages from Brewfile
make stow   # Re-stow all dotfiles
make macos  # Apply macOS defaults
```

## Structure

```
brew/Brewfile    # Homebrew packages, casks, and VS Code extensions
stow/            # Dotfiles managed by GNU Stow
  agents/        # Claude agents config
  bin/           # Custom CLI tools
  claude/        # Claude Code settings
  direnv/        # direnv config
  ghostty/       # Ghostty terminal config
  git/           # Git config
  k9s/           # k9s Kubernetes UI config
  nvim/          # Neovim config (LazyVim)
  starship/      # Starship prompt config
  streamdeck/    # Stream Deck config
  television/    # Television file picker config
  zsh/           # Zsh shell config
scripts/         # Setup and utility scripts
```

## Software

- Terminal: [Ghostty](https://ghostty.dev)
- Shell: [zsh](https://www.zsh.org)
- Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
- Editor: [Neovim](https://neovim.io)
- Git: [lazygit](https://github.com/jesseduffield/lazygit)
- Package manager: [Homebrew](https://brew.sh)

## Hardware

- Laptop: [MacBook Pro](https://www.apple.com/macbook-pro) (Apple M1 Chip, 16GB RAM)
- Keyboard: [HHKB hybrid type-s](https://www.hhkeyboard.com/uk/products/hybrid-type-s)

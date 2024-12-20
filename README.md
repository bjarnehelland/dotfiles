# Dotfiles

This is the home of all my dotfiles. These are files that add custom configurations to my computer and applications, primarily the terminal.

## How to install

My dotfiles are managed by [Nix](https://nixos.org/).

1. Install [Homebrew](https://brew.sh/)
2. Install Nix package manager via [Nix Official](https://nixos.org/download.html#nix-install-macos)
3. Run `./generate_github_ssh.sh` to generate a new SSH key and add it to your GitHub account.
4. Run the following command to install the dotfiles: 
```sh
make setup
```

## Software

- Terminal: [Wezterm](https://wezfurlong.org/wezterm)
- Font: [Monaspace](https://monaspace.githubnext.com/)
- Colors: [catppuccin](https://github.com/catppuccin/catppuccin)
- Shell: [zsh](https://fishshell.com)
- Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
  - Session manager: [sesh](https://github.com/joshmedeski/sesh)
- Editor: [Neovim](https://neovim.io)
- Git: [lazygit](https://github.com/jesseduffield/lazygit)
- macOS package manager: [Homebrew](https://brew.sh)

## Hardware

- Laptop: [MacBook Pro](https://www.apple.com/macbook-pro) (13-inch, 2020, Apple M1 Chip, 16GB RAM)
- Mouse: Apple trackpad

## Keyboards

- [HHKB hybrid type-s](https://www.hhkeyboard.com/uk/products/hybrid-type-s) (daily driver)

## Notes

- [NixOS](https://nixos.org)
- [Home Manager](https://nix-community.github.io/home-manager)
- [Nix packages](https://search.nixos.org/packages)
- [Nix darwin](https://daiderd.com/nix-darwin/manual/index.html)
- [Alternative Nix installer (DeterminateSystems)](https://github.com/DeterminateSystems/nix-installer)

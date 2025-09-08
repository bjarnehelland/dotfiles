# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed by Nix, specifically using nix-darwin and home-manager for macOS configuration. The repository provides a declarative way to manage system configuration, installed packages, and user dotfiles.

## Key Commands

### Initial Setup
```sh
make setup  # Initial build and switch to the configuration
```

### Configuration Updates
```sh
make sync        # Apply configuration changes
make sync-debug  # Apply with debug output if something goes wrong
make update      # Update flake inputs (nixpkgs, home-manager, etc.)
```

### Development Commands
```sh
# Format Nix files
nix fmt

# Build without switching (dry run)
nix build .#darwinConfigurations.Bjarnes-MacBook-Pro.system --extra-experimental-features 'nix-command flakes'
```

## Architecture

### Nix Flake Structure
- `flake.nix`: Main entry point defining the system configuration
- `modules/`: System-level Darwin configuration
  - `nix-core.nix`: Core Nix settings
  - `system.nix`: macOS system preferences
  - `apps.nix`: Package installations (nixpkgs + Homebrew)
  - `host-users.nix`: User account configuration
- `home/`: User-level home-manager configuration
  - `default.nix`: Main home configuration and symlinks
  - `shell.nix`: Zsh configuration and aliases
  - `git.nix`: Git configuration
  - `starship.nix`: Starship prompt configuration
  - `tmux.nix`: Tmux configuration
  - `core.nix`: Core packages for the user

### Configuration Files
The actual dotfiles are stored in `stow/` and managed by GNU Stow symlinks:
- `stow/nvim/.config/nvim/`: Neovim configuration (LazyVim-based)
- `stow/ghostty/.config/ghostty/`: Ghostty terminal configuration

### Custom CLI Tools
Located in `stow/bin/.config/bin/`:
- `d`: Development server launcher that finds `package.json` files and runs dev scripts (npm/yarn/pnpm/bun)
- `bs`: Blocc solution sync tool that finds `solution.yaml` files and runs `blocc sync`


### Key Technologies
- **Nix Darwin**: macOS system configuration
- **Home Manager**: User environment management
- **GNU Stow**: Dotfile symlink management
- **Homebrew**: GUI apps and packages not available in nixpkgs
- **Shell**: Zsh with custom aliases
- **Editor**: Neovim with LazyVim configuration
- **Terminal**: Ghostty

## Important Notes

- The hostname is hardcoded as "Bjarnes-MacBook-Pro" in flake.nix and must match your system
- Homebrew must be installed manually before running `make setup`
- The repository assumes an Apple Silicon Mac (aarch64-darwin)
- GNU Stow manages symlinks from `stow/` directories to their target locations
- Changes to Nix configuration require running `make sync` to apply
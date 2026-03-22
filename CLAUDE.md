# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for macOS. It uses Homebrew for package management and GNU Stow for managing dotfile symlinks.

## Key Commands

### Initial Setup
```sh
make install-homebrew  # Install Homebrew
```

## Architecture

### Directory Structure
- `brew/Brewfile`: Homebrew package definitions (formulae, casks, VS Code extensions)
- `stow/`: Dotfiles managed by GNU Stow symlinks
  - `stow/nvim/.config/nvim/`: Neovim configuration (LazyVim-based)
  - `stow/ghostty/.config/ghostty/`: Ghostty terminal configuration
- `scripts/`: Setup and utility scripts
- `bettertouchtool/`: BetterTouchTool configuration

### Custom CLI Tools
Located in `stow/bin/.config/bin/`:
- `d`: Development server launcher that finds `package.json` files and runs dev scripts (npm/yarn/pnpm/bun)
- `bs`: Blocc solution sync tool that finds `solution.yaml` files and runs `blocc sync`

### Key Technologies
- **Homebrew**: Package management
- **GNU Stow**: Dotfile symlink management
- **Shell**: Zsh with custom aliases
- **Editor**: Neovim with LazyVim configuration
- **Terminal**: Ghostty

## Important Notes

- The repository assumes an Apple Silicon Mac (aarch64-darwin)
- GNU Stow manages symlinks from `stow/` directories to their target locations

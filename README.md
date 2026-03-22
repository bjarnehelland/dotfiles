# Bjarne dotfiles

This is the home of all my dotfiles. These are files that add custom
configurations to my computer and applications, primarily the terminal.

## How to install

Run this on a fresh Mac — it handles everything (Xcode CLI tools, cloning, Homebrew, packages, stow, and SSH setup):

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/bjarnehelland/dotfiles/main/scripts/dotfiles.sh)
```

Then configure macOS defaults:

```sh
make macos
```

## Usage

```sh
make brew   # Install/update Homebrew packages from Brewfile
make stow   # Re-stow all dotfiles
make macos  # Apply macOS defaults
```

# Bjarne dotfiles

This is the home of all my dotfiles. These are files that add custom
configurations to my computer and applications, primarily the terminal.

## How to install

1. Install Xcode Command Line Tools (gives you `git`):

```sh
xcode-select --install
```

2. Clone this repo via HTTPS (no SSH key needed on a fresh Mac):

```sh
git clone https://github.com/bjarnehelland/dotfiles.git ~/Code/bjarnehelland/dotfiles
cd ~/Code/bjarnehelland/dotfiles
```

3. Run the setup script (installs Homebrew, packages, and stows dotfiles):

```sh
make setup
```

4. Configure macOS defaults:

```sh
make macos
```

5. Switch remote to SSH after setting up your SSH key:

```sh
bash scripts/generate_github_ssh.sh
git remote set-url origin git@github.com:bjarnehelland/dotfiles.git
```

## Usage

```sh
make brew   # Install/update Homebrew packages from Brewfile
make stow   # Re-stow all dotfiles
make macos  # Apply macOS defaults
```

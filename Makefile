# please change 'hostname' to your hostname
install-homebrew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

install-nix:
	sh <(curl -L https://nixos.org/nix/install)

setup:
	cd nix-darwin && nix build .#darwinConfigurations.MacBookPro.system \
	   --extra-experimental-features 'nix-command flakes'

sync:
	stow .
	cd nix-darwin && darwin-rebuild switch --flake .#MacBookPro

sync-debug:
	cd nix-darwin && darwin-rebuild switch --flake .#MacBookPro --show-trace

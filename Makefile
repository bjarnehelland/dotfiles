# please change 'hostname' to your hostname
install-homebrew:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash

install-nix:
	curl -L https://nixos.org/nix/install | sh

setup:
	cd nix-darwin && nix build .#darwinConfigurations.MacBookPro.system \
	   --extra-experimental-features 'nix-command flakes'
	cd nix-darwin && ./result/sw/bin/darwin-rebuild switch --flake .#MacBookPro

sync:
	cd nix-darwin && darwin-rebuild switch --flake .#MacBookPro

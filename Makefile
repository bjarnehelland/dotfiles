# please change 'hostname' to your hostname
install-homebrew:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash

install-nix:
	curl -L https://nixos.org/nix/install | sh

setup:
	nix build .#darwinConfigurations.Bjarnes-MacBook-Pro.system \
	   --extra-experimental-features 'nix-command flakes'
	./result/sw/bin/darwin-rebuild switch --flake .

sync:
	darwin-rebuild switch --flake .

sync-debug:
	darwin-rebuild switch --flake . --show-trace

update:
	nix flake update

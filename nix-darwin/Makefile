# please change 'hostname' to your hostname
build:
	nix build .#darwinConfigurations.MacBookPro.system \
	   --extra-experimental-features 'nix-command flakes'

sync:
	darwin-rebuild switch --flake .#MacBookPro

sync-debug:
	darwin-rebuild switch --flake .#MacBookPro --show-trace

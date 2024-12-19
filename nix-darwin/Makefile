# please change 'hostname' to your hostname
deploy:
	nix build .#darwinConfigurations.MacBookPro.system \
	   --extra-experimental-features 'nix-command flakes'

	./result/sw/bin/darwin-rebuild switch --flake .#MacBookPro

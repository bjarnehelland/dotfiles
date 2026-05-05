.PHONY: setup macos stow unstow brew repos

setup:
	bash scripts/dotfiles.sh

macos:
	bash scripts/macos-setup.sh

repos:
	bash scripts/clone_repos.sh

stow:
	@for pkg in $$(ls -d stow/*/); do \
		echo "Stowing $$(basename $$pkg)"; \
		stow -d stow --target $(HOME) $$(basename $$pkg); \
	done

unstow:
	@for pkg in $$(ls -d stow/*/); do \
		echo "Unstowing $$(basename $$pkg)"; \
		stow -d stow --target $(HOME) -D $$(basename $$pkg); \
	done

brew:
	brew bundle --file=brew/Brewfile
	@if [ -f brew/Brewfile.work ]; then \
		read -p "Install work (Stacc) packages? [y/N] " work; \
		if [ "$$work" = "y" ] || [ "$$work" = "Y" ]; then \
			brew bundle --file=brew/Brewfile.work; \
		fi; \
	fi

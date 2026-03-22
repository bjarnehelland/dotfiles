setup:
	bash scripts/dotfiles.sh

macos:
	bash scripts/macos-setup.sh

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

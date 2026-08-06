.PHONY: setup macos stow unstow brew repos streamdeck

setup:
	bash scripts/dotfiles.sh

macos:
	bash scripts/macos-setup.sh

repos:
	bash scripts/clone_repos.sh

stow:
	@mkdir -p $(HOME)/.claude/skills
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

streamdeck:
	bash scripts/streamdeck-backup.sh

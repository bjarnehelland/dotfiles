#!/usr/bin/env bash

set -e

if ! command -v brew >/dev/null; then
  echo "==> Installing Homebrew ..."
  if [[ "$OSTYPE" = darwin* ]]; then
    curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
  else
    curl -fsSL 'https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh' | sh -c
  fi
fi


# TODO: Keep an eye out for a different `--no-quarantine` solution.
# It's currently exported in zshrc:
# export HOMEBREW_CASK_OPTS="--no-quarantine"
# https://github.com/Homebrew/homebrew-bundle/issues/474
brew bundle --file homebrew/Brewfile --verbose

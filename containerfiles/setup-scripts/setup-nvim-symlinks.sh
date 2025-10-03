#!/usr/bin/env bash
# If Neovim is present, symlink vim/vi and set system git editor to nvim.
set -euo pipefail

if command -v nvim >/dev/null 2>&1; then
  ln -sf "$(command -v nvim)" /usr/local/bin/vim
  ln -sf "$(command -v nvim)" /usr/local/bin/vi
  git config --system core.editor "nvim" || true
fi

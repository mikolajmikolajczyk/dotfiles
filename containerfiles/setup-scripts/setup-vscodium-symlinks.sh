#!/usr/bin/env bash
# If codium is present, symlink as code.
set -euo pipefail

if command -v codium >/dev/null 2>&1; then
  ln -sf "$(command -v codium)" /usr/local/bin/code
fi

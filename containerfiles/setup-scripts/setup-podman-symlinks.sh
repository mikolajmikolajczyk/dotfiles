#!/usr/bin/env bash
# If podman-remote is present, symlink as podman.
set -euo pipefail

if command -v podman-remote >/dev/null 2>&1; then
  ln -sf "$(command -v podman-remote)" /usr/local/bin/podman
  ln -sf "$(command -v podman-remote)" /usr/local/bin/docker
fi

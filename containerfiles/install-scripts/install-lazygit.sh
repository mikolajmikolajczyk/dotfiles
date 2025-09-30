#!/usr/bin/env bash
# Usage: install-lazygit.sh <lazygit_version>
# Installs official prebuilt LazyGit to /opt/lazygit and symlinks /usr/local/bin/lazygit
set -euo pipefail
ver="${1:?missing lazygit version}"

arch="$(uname -m)"
case "$arch" in
  x86_64) pkg="lazygit_${ver}_linux_x86_64.tar.gz" ;;
  aarch64) pkg="lazygit_${ver}_linux_arm64.tar.gz" ;;
  *) echo "Unsupported arch: ${arch}" >&2; exit 1 ;;
esac

curl -fsSL -o /tmp/lazygit.tar.gz \
  "https://github.com/jesseduffield/lazygit/releases/download/v${ver}/${pkg}"

install -d -m 0755 /opt/lazygit
tar -xzf /tmp/lazygit.tar.gz -C /opt/lazygit
ln -sf /opt/lazygit/lazygit /usr/local/bin/lazygit
rm -f /tmp/lazygit.tar.gz

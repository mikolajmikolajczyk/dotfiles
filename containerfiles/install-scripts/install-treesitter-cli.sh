#!/usr/bin/env bash
# Usage: install-tree-sitter.sh <tree_sitter_version>
# Installs official prebuilt tree-sitter CLI to /opt/tree-sitter and symlinks /usr/local/bin/tree-sitter
set -euo pipefail
ver="${1:?missing tree-sitter version}"

arch="$(uname -m)"
case "$arch" in
  x86_64)  pkg="tree-sitter-linux-x64.gz" ;;
  aarch64) pkg="tree-sitter-linux-arm64.gz" ;;
  *) echo "Unsupported arch: ${arch}" >&2; exit 1 ;;
esac

url="https://github.com/tree-sitter/tree-sitter/releases/download/v${ver}/${pkg}"

curl -fsSL -o /tmp/tree-sitter.gz "$url"

install -d -m 0755 /opt/tree-sitter
# Release asset is a single gzipped binary (no tar)
gunzip -c /tmp/tree-sitter.gz > /opt/tree-sitter/tree-sitter
chmod +x /opt/tree-sitter/tree-sitter

ln -sf /opt/tree-sitter/tree-sitter /usr/local/bin/tree-sitter
rm -f /tmp/tree-sitter.gz

# Smoke test
tree-sitter --version

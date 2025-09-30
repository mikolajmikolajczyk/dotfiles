#!/usr/bin/env bash
set -euo pipefail
# Usage: install-opentofu.sh <version>
version="${1:?missing opentofu version}"
arch="$(uname -m)"
case "$arch" in
  x86_64) a=amd64 ;;
  aarch64) a=arm64 ;;
  *) echo "unsupported arch: $arch" >&2; exit 1 ;;
esac
curl -fsSL "https://github.com/opentofu/opentofu/releases/download/v${version}/tofu_${version}_linux_${a}.zip" -o /tmp/tofu.zip
unzip -o /tmp/tofu.zip -d /usr/local/bin
rm -f /tmp/tofu.zip
tofu version >/dev/null

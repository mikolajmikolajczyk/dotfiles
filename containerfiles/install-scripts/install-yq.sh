#!/usr/bin/env bash
# Usage: install-yq.sh <yq_version>
# Installs mikefarah/yq (Go edition) static binary to /usr/local/bin/yq
set -euo pipefail
ver="${1:?missing yq version}"

arch="$(uname -m)"
case "$arch" in
  x86_64) yq_arch="amd64" ;;
  aarch64) yq_arch="arm64" ;;
  *) echo "Unsupported arch: ${arch}" >&2; exit 1 ;;
esac

curl -fsSL -o /usr/local/bin/yq \
  "https://github.com/mikefarah/yq/releases/download/v${ver}/yq_linux_${yq_arch}"
chmod +x /usr/local/bin/yq
yq --version >/dev/null

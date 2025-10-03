#!/usr/bin/env bash
set -euo pipefail
# Usage: install-gvm.sh <gvm_version>
gvm_ver="${1:?missing gvm version}"

arch="$(uname -m)"
case "$arch" in
x86_64) garch="amd64" ;;
aarch64) garch="arm64" ;;
*)
  echo "unsupported arch: $arch" >&2
  exit 1
  ;;
esac

url="https://github.com/andrewkroh/gvm/releases/download/v${gvm_ver}/gvm-linux-${garch}"
curl -fsSL -o /usr/local/bin/gvm "$url"
chmod +x /usr/local/bin/gvm

# sanity check (does not require network)
gvm -h >/dev/null

dnf install -y delve

#!/usr/bin/env bash
# Usage: install-starship.sh <version_or_latest>
# Installs Starship to /usr/local/bin/starship. If "latest", uses latest release.
set -euo pipefail
ver="${1:?missing starship version (or 'latest')}"

arch="$(uname -m)"
case "$arch" in
  x86_64) star_arch="x86_64-unknown-linux-gnu" ;;
  aarch64) star_arch="aarch64-unknown-linux-gnu" ;;
  *) echo "Unsupported arch: ${arch}" >&2; exit 1 ;;
esac

if [[ "${ver}" == "latest" ]]; then
  url="https://github.com/starship/starship/releases/latest/download/starship-${star_arch}.tar.gz"
else
  url="https://github.com/starship/starship/releases/download/v${ver}/starship-${star_arch}.tar.gz"
fi

curl -fsSL -o /tmp/starship.tgz "${url}"
tar -xzf /tmp/starship.tgz -C /usr/local/bin starship
chmod +x /usr/local/bin/starship
rm -f /tmp/starship.tgz

/usr/local/bin/starship --version >/dev/null

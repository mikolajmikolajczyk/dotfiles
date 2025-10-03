#!/usr/bin/env bash
set -euo pipefail
ver="${1:?missing hugo version}"

arch="$(uname -m)"
case "$arch" in
  x86_64) a="Linux-64bit" ;;
  aarch64) a="Linux-ARM64" ;;
  *) echo "Unsupported arch: ${arch}" >&2; exit 1 ;;
esac

curl -fsSL -o /tmp/hugo.tar.gz \
  "https://github.com/gohugoio/hugo/releases/download/v${ver}/hugo_${ver}_${a}.tar.gz"

tar -C /usr/local/bin -xzf /tmp/hugo.tar.gz hugo
rm -f /tmp/hugo.tar.gz

hugo version >/dev/null
